# EEHBV Backend Python

**EEHBV** is a web application developed in the context of the research project
[Energieeffiziente Energiewandlung in der industriellen Holzbe- und -verarbeitung vom Prozess bis zum Stromnetz](https://www.fnr.de/index.php?id=11150&fkz=2220HV046C)
(Energy efficient energy conversion in industrial wood working from process to
power grid), government-funded by the German Federal Ministry of Food and 
Agriculture.

This repository contains the backend for EEHBV, written in Python, to be used 
in combination with the frontend in the repository **eehbv-frontend**.

## Build docker image

To build the docker image run
<pre><code>docker build -t saw-leipzig/eehbv-api .</code></pre>

The `Dockerfile` references an image **markuswb/pandas-flask-sqlalchemy**. 
This can be built with the file `Dockerfile_multistage_base` which will
take some time. But a production ready image exists on
[Docker Hub](https://hub.docker.com/r/markuswb/pandas-flask-sqlalchemy) 
and will be downloaded if necessary.

## Deployment
The app consists of a frontend and a backend Docker container. Additionally, a 
**MariaDB** or **MySQL** instance is necessary for the database.
A complete setup for deployment with **docker compose** is described in the
file `docker-compose.all.yml`. To start the setup, rename the environment
variables file `.env.template` to `.env`, adjust the database server 
settings in it, and run
<pre><code>docker compose -f docker-compose.all.yml up -d</code></pre>

The section for the **phpMyAdmin** service in `docker-compose.all.yml` is optional 
and only for administrative purposes. Only the frontend container should be 
revealed to a public network.

## Development setup

### Database setup
Start the database container with
<pre><code>docker compose -f docker-compose.db.yml up -d</code></pre>
After the first start, import the database file `eehbv_proto.sql` and grant
the user `eehbv` access to it.

### Start development server
To start the backend app with the development server, set the environment 
variables `FLASK_APP=eehbv.py` and `FLASK_CONFIG=development` and run
<pre><code>
flask run
</code></pre>