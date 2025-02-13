# syntax=docker/dockerfile:1
FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app/project

RUN uv venv .venv --python 3.10
ENV PATH="/app/project/.venv/bin:$PATH"

RUN --mount=type=secret,id=git_token \
    export GIT_TOKEN=$(cat /run/secrets/git_token) && \
    git clone https://${GIT_TOKEN}@github.com/TundeAtSN/evalchemy.git

WORKDIR /app/project/evalchemy

RUN uv sync --no-dev
