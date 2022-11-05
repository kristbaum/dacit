#!/bin/bash

#python3 manage.py runserver 0.0.0.0:8000
#echo Running here:
#pwd
#ls
#sleep 1000

uwsgi \
--socket :8000 \
--wsgi-file core/wsgi.py \
--master \
--processes 1 \
--threads 1 

#--chdir /api/ \

#
#--stats :8001

#api/dacit_api/dacit_api/wsgi.py
#api/dacit_api/manage.py