FROM mcr.microsoft.com/mssql/server:2019-CU8-ubuntu-16.04

USER root

ENV SA_PASSWORD=SaPassword1

ENV ACCEPT_EULA=Y

RUN apt-get -y update

WORKDIR /startup

COPY ./import.sh /startup/import.sh

COPY ./start.sh /startup/start.sh

RUN chmod 777 /startup/import.sh

RUN chmod 777 /startup/start.sh

EXPOSE 1433

USER mssql

CMD ["/startup/start.sh"]