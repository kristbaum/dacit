import os
import csv
import sys
import uuid
import hashlib
import logging
from core import settings

from tqdm import tqdm
from dacit_app.models import *
from datetime import datetime
from django.db import connection
from django.apps import apps
from django.utils import timezone
from django.core.management import BaseCommand, CommandError
from django.core.management.color import no_style
from django.core.validators import URLValidator
from django.core.exceptions import ValidationError

OBJ_MAPPING = {}

DATE_FORMAT = '%Y-%m-%d %H:%M:%S.%f'
TZINFO = 'UTC'


def toDatetime(x):
    if x:
        if '.' not in x:
            x += '.0'  # convert to proper date format

        return datetime.strptime(x, DATE_FORMAT).replace(tzinfo=TZINFO)

    return timezone.now()


class Create:
    def process(self):
        args = {'ignore_conflicts': True}

        if os.path.exists(self.file_path):
            with open(self.file_path, 'r') as csv_file:
                data = csv.reader(csv_file)
                processed_rows = []
                columns = next(data)

                for row in tqdm(data, f'Import {self.name}', file=sys.stdout):
                    obj = self.convert(dict(zip(columns, row)))

                    if obj is not None:
                        processed_rows.append(obj)

                    if len(processed_rows) > 5000:
                        try:
                            self.obj.objects.bulk_create(
                                processed_rows, **args)
                        except Exception as error:
                            print(error)

                        processed_rows = []

                if processed_rows:
                    try:
                        self.obj.objects.bulk_create(processed_rows, **args)
                    except Exception as error:
                        print(error)
        else:
            sys.stdout(f'{self.file_path} does not exist.')


class ImportWordList(Create):
    name = 'Text_Stimulus'

    def __init__(self, folder_path):
        self.file_path = os.path.join(folder_path, 'WORTLISTE_IMPORTIERT.csv')
        self.obj = Text_Stimulus

    def convert(self, row):
        return self.obj(
            text=row.get('lemma'),
            wd_lexeme_url=row.get('lexemeId'),
            wd_item_url=row.get('q_concept'),
            wc_picture_url=row.get('picture'),
            description=row.get('q_conceptDescription'),
        )


class ImportMinPair(Create):
    name = 'Min_Pair'

    def __init__(self, folder_path, filename, min_pair_class):
        self.file_path = os.path.join(folder_path, filename)
        self.obj = Min_Pair
        self.min_pair_class = min_pair_class

    def convert(self, row):
        word_1 = None
        word_1_text = text = row.get('Wort_1')
        word_2 = None
        word_2_text = text = row.get('Wort_2')
        #print("Wort1 und 2: " + str(word_1_text) + " " + str(word_2_text))

        word_1 = Text_Stimulus.objects.filter(text=word_1_text).first()
        if word_1 is None:
            word_1 = Text_Stimulus(
                text=word_1_text, creator=row.get('Madoo_Nutzername'))
            word_1.save()

        word_2 = Text_Stimulus.objects.filter(text=word_2_text).first()
        if word_2 is None:
            word_2 = Text_Stimulus(
                text=word_2_text, creator=row.get('Madoo_Nutzername'))
            word_2.save()

        if (word_1 is None) and (word_2 is None):
            print("Error, both words couldn't be found")

        filename_1 = row.get('Datei_T_Spalte1')
        filename_2 = row.get('Datei_T_Spalte2')

        if filename_1 is not None and filename_1 != '':
            default_speaker = DacitUser.objects.filter(
                public_id=1).first()
            audio_file = Audio(
                speaker=default_speaker,
                audio='audio/' + filename_1 + '.wav',
                language='de',
                dicalect='Hochdeutsch',
                text_stimulus=word_1
            )
            audio_file.save()

        if filename_2 is not None and filename_2 != '':
            default_speaker = DacitUser.objects.filter(
                public_id=1).first()
            audio_file = Audio(
                speaker=default_speaker,
                audio='audio/' + filename_2 + '.wav',
                language='de',
                dicalect='Hochdeutsch',
                text_stimulus=word_2
            )
            audio_file.save()

        return self.obj(
            min_pair_class=self.min_pair_class,
            first_part=word_1,
            second_part=word_2,
        )


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--input', type=str, default='/import')

    def handle(self, *args, **options):
        start_time = timezone.now()

        logging.info('Create default speaker')
        self.obj = DacitUser(email="default@example.example", public_id=1)
        self.obj.save()

        logging.info('Create default speaker')
        if os.path.isdir(options['input']):
            ImportWordList(options['input']).process()
            ImportMinPair(options['input'],
                          "B_W_MIN_PAARE.csv", 'B_W').process()
            ImportMinPair(options['input'],
                          "F_W_MIN_PAARE.csv", 'F_W').process()
            ImportMinPair(options['input'],
                          "H_R_MIN_PAARE.csv", 'H_R').process()
            ImportMinPair(options['input'],
                          "K_T_MIN_PAARE.csv", 'K_T').process()
            ImportMinPair(options['input'],
                          "PF_F_MIN_PAARE.csv", 'PF_F').process()
            ImportMinPair(options['input'],
                          "R_L_MIN_PAARE.csv", 'R_L').process()
        else:
            raise CommandError('Input is not a directory.')

        end_time = timezone.now()
        duration = end_time - start_time

        txt = f'Import took {duration.total_seconds()} seconds.'
        self.stdout.write(self.style.SUCCESS(txt))

        configs = [apps.get_app_config(x) for x in ['dacit_app']]
        models = [list(config.get_models()) for config in configs]

        with connection.cursor() as cursor:
            for model in models:
                for sql in connection.ops.sequence_reset_sql(no_style(), model):
                    cursor.execute(sql)

        self.stdout.write(self.style.SUCCESS('Successfully reset AutoFields.'))
