FROM mcr.microsoft.com/mssql/server:2019-CU8-ubuntu-16.04

USER root

ENV SA_PASSWORD=SaPassword1

ENV ACCEPT_EULA=Y

RUN apt-get -y update

WORKDIR /startup

COPY ./import_shard245.sh /startup/import_shard245.sh

COPY ./start_shard245.sh /startup/start_shard245_shard245.sh

RUN chmod 777 /startup/import_shard245.sh

RUN chmod 777 /startup/start_shard245.sh

EXPOSE 1433

USER mssql

CMD ["/startup/start_shard245.sh"]