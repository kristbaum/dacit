# Generated by Django 4.1.7 on 2023-04-09 09:47

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('dacit_app', '0002_alter_dacituser_public_id'),
    ]

    operations = [
        migrations.AlterField(
            model_name='dacituser',
            name='public_id',
            field=models.BigIntegerField(null=True, unique=True),
        ),
    ]
