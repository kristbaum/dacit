# Dacit

Crowdsourcing dialectal and situational utterances for training cochlear implant wearers

# Client

## Building

From the dacit directory.
flutter gen-l10n


# Server


A training app for people with Cochlea Implants

# Structure

Django Backend / Flutter Frontend

"""
python3 -m venv venv
pip install poetry
poetry install
"""

## Frontend

Install Flutter

"""
sudo snap install --classic flutter
sudo snap install --classic android-studio
sudo snap install chromium
echo -e "export CHROME_EXECUTABLE=/snap/bin/chromium" >> ~/.bashrc
echo -e "alias google-chrome='chromium'" >> ~/.bashrc
"""

Open Android studio and configure it

To check settings:
"""
echo $CHROME_EXECUTABLE
flutter doctor
"""

Install command-line tools https://web.archive.org/web/20211204120608/https://www.fluttercampus.com/guide/202/cmdline-tools-component-is-missing-error-flutter/

Build translations the first time:
cd dacit
flutter gen-l10n
