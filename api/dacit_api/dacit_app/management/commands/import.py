import os
import csv
import sys
import pytz
import uuid
import hashlib

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
TZINFO = pytz.timezone('UTC')


def toInt(x):
    if isinstance(x, str):
        try:
            return int(float(x))
        except:
            pass

    return None


def toScore(x):
    x = toInt(x)

    if x:
        return x

    return 0


def isURL(x):
    try:
        validate = URLValidator()
        validate(x)

        return True
    except ValidationError:
        pass

    return False


def toURL(x):
    if isURL(x):
        return x

    return ''


def toDatetime(x):
    if x:
        if '.' not in x: x += '.0'  # convert to proper date format

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
                            self.obj.objects.bulk_create(processed_rows, **args)
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


class CreateUser(Create):
    name = 'User'

    def __init__(self, folder_path):
        self.file_path = os.path.join(folder_path, 'user.csv')
        self.obj = CustomUser

    def convert(self, row):
        if not row.get('username'):
            row['username'] = uuid.uuid4().hex[:15]

        if not row.get('email'):
            row['email'] = f"{row['username']}@artigo.org"

        if not row.get('password'):
            password = uuid.uuid4().hex.encode('utf-8')
            row['password'] = hashlib.sha256(password).hexdigest()

        return self.obj(
            id = toInt(row.get('id')),
            username = row.get('username'),
            email = row.get('email'),
            password = row.get('password'),
            first_name = row.get('first_name'),
            last_name = row.get('last_name'),
            date_joined = toDatetime(row.get('date_joined')),
            is_anonymous = row.get('is_anonymous') == 'True',
        )


class ImportWordList(Create):
    name = 'Text_Stimulus'

    def __init__(self, folder_path):
        self.file_path = os.path.join(folder_path, 'WORTLISTE_IMPORTIERT.csv')
        self.obj = Text_Stimulus

    def convert(self, row):
        return self.obj(
            text = row.get('lemma'),
            wd_lexeme_url = row.get('lexemeId'),
            wd_item_url = row.get('q_concept'),
            wc_picture_url = row.get('picture'),
            description = row.get('q_conceptDescription'),
        )

class ImportBW(Create):
    name = 'Text_Stimulus'

    def __init__(self, folder_path):
        self.file_path = os.path.join(folder_path, 'B_W_MIN_PAARE.csv')
        self.obj = Text_Stimulus

    def convert(self, row):
        print(ext_Stimulus.objects.get(text=row.get('Wort_1')))
        print(ext_Stimulus.objects.get(text=row.get('Wort_2')))
        #return self.obj(
            #text = row.get('Wort_1'),
            #user_audio_creatable = True,
            #language = 'DE',
            #min_pair_class = 'B_W',
        #)


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--input', type=str, default='/import')

    def handle(self, *args, **options):
        start_time = timezone.now()

        if os.path.isdir(options['input']):
            ImportWordList(options['input']).process()
            ImportBW(options['input']).process()
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
