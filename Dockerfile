FROM markuswb/pandas-flask-sqlalchemy

EXPOSE 5000

ENV FLASK_APP eehbv.py
ENV FLASK_CONFIG docker

COPY app app
COPY eehbv.py config.py boot.sh ./
USER root
RUN chmod +x boot.sh
USER application
CMD ["./boot.sh"]