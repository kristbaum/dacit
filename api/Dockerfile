FROM python:3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN pip install pip --upgrade
RUN pip install poetry
RUN pip install pytest pytest-cov

COPY /api /api
RUN cd /api; poetry export -f requirements.txt --output requirements.txt --without-hashes
RUN cd /api; pip install -r requirements.txt

WORKDIR /api/dacit_api
RUN chmod +x /api/docker-entrypoint.sh
ENTRYPOINT ["/api/docker-entrypoint.sh"]