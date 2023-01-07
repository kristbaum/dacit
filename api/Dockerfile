FROM python:3.11
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV POETRY_VIRTUALENVS_CREATE=False

RUN addgroup --system django \
    && adduser --system --ingroup django django

RUN apt update && apt install -y build-essential python-dev
RUN pip install poetry

COPY /api/poetry.lock /api/poetry.lock
COPY /api/pyproject.toml /api/pyproject.toml
RUN cd /api; poetry install

COPY --chown=django:django /api/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

COPY --chown=django:django /api /api

USER django

ENTRYPOINT ["/docker-entrypoint.sh"]
