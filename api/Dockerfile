FROM python:3.10
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN pip install pip --upgrade
RUN pip install poetry

COPY /api/poetry.lock /api/poetry.lock
COPY /api/pyproject.toml /api/pyproject.toml
RUN cd /api; poetry export -f requirements.txt --output requirements.txt --without-hashes
RUN cd /api; pip install -r requirements.txt


COPY /api/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
