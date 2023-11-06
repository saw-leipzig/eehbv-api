mkdir dist\eehbv\db
copy Installation.pdf dist\eehbv\
copy Bedienungsanleitung.pdf dist\eehbv\
copy docker-compose.hub.yml dist\eehbv\docker-compose.yml
copy .env.template dist\eehbv\.env
copy eehbv_proto.sql dist\eehbv\db\init.sql
jar cvMf dist\eehbv.zip -C dist\eehbv\ .