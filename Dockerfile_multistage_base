ARG base_img=python:3.9.12-alpine3.15


# Builder stage:
FROM ${base_img} AS builder

RUN apk update
RUN apk add make automake gcc g++ openssl-dev libffi-dev cargo rust

RUN adduser -D application
WORKDIR /home/application
RUN python -m venv /home/application/venv
ENV PATH=/home/application/venv/bin:$PATH

COPY requirements.txt ./
RUN pip install -r requirements.txt && pip install waitress


# Final stage:
FROM ${base_img}

RUN apk add --no-cache libstdc++ && \
    adduser -D application	
WORKDIR /home/application
COPY --from=builder /home/application/venv venv
RUN chown -R application /home/application/venv
ENV PATH=/home/application/venv/bin:$PATH

USER application