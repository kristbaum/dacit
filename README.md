# Dacit

Dialect adapted cochlear implant training
A training app for people with Cochlea Implants

Crowdsourcing dialectal and situational utterances for training cochlear implant wearers

# Development Setup

## Client

### Building

From the dacit directory.
flutter gen-l10n

## Server


## Structure

Django Backend / Flutter Frontend

```
python3 -m venv venv
pip install poetry
poetry install

# Generate new secret:
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'

python3 manage.py runserver
```

## Frontend

Install Flutter

```
sudo snap install --classic flutter
sudo snap install --classic android-studio
sudo snap install chromium
echo -e "export CHROME_EXECUTABLE=/snap/bin/chromium" >> ~/.bashrc
echo -e "alias google-chrome='chromium'" >> ~/.bashrc
```

Open Android studio and configure it

To check settings:
```
echo $CHROME_EXECUTABLE
flutter doctor
```

Install command-line tools https://web.archive.org/web/20211204120608/https://www.fluttercampus.com/guide/202/cmdline-tools-component-is-missing-error-flutter/

Build translations the first time:
cd dacit
flutter gen-l10n

# Start

Run Database
```
docker run post
```

## Migrate and Import
```
docker compose exec api python manage.py migrate
docker compose exec api python3 manage.py import
docker compose exec api python3 manage.py createsuperuser
```
