# Generated by Django 4.1.7 on 2023-04-09 09:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('dacit_app', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='dacituser',
            name='public_id',
            field=models.BigIntegerField(default=4446726800333, unique=True),
        ),
    ]