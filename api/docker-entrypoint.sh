#!/bin/bash

# python3 manage.py runserver 0.0.0.0:8000


uwsgi \
--http :8000 \
--wsgi-file core/wsgi.py \
--master \
--processes 1 \
--threads 1 
