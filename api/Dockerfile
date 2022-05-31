FROM python:3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN pip install pip --upgrade
RUN pip install poetry
RUN pip install pytest pytest-cov

COPY /api/poetry.lock /api/poetry.lock
COPY /api/pyproject.toml /api/pyproject.toml
RUN cd /api; poetry export -f requirements.txt --output requirements.txt --without-hashes
RUN cd /api; pip install -r requirements.txt


#COPY /api/docker-entrypoint.sh /api/docker-entrypoint.sh
RUN chmod +x api/docker-entrypoint.sh
WORKDIR /api/dacit_api
ENTRYPOINT ["/api/docker-entrypoint.sh"]
