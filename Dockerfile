# VERSION 1.10.9
# AUTHOR: Matthieu "Puckel_" Roisil
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t puckel/docker-airflow .
# SOURCE: https://github.com/puckel/docker-airflow

FROM muyouming/base
LABEL maintainer="muyouming"

# Never prompt the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.10.9
ARG AIRFLOW_USER_HOME=/usr/local/airflow
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

# Disable noisy "Handling signal" log messages:
# ENV GUNICORN_CMD_ARGS --log-level WARNING


# RUN echo "deb http://mirrors.163.com/debian/ buster main non-free contrib" > /etc/apt/sources.list
# RUN echo "deb http://mirrors.163.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list
# RUN echo "deb http://mirrors.163.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list
# RUN echo "deb-src http://mirrors.163.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list
# RUN echo "deb-src http://mirrors.163.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list
# RUN echo "deb-src http://mirrors.163.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list
# RUN echo "deb http://mirrors.163.com/debian-security/ buster/updates main non-free contrib" >> /etc/apt/sources.list
# RUN echo "deb-src http://mirrors.163.com/debian-security/ buster/updates main non-free contrib" >> /etc/apt/sources.list


## do update, upgrade (which may not be needed) & install:
# RUN apt-get update -y && apt-get -y upgrade


RUN set -ex \
    && useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow \
    && conda config --add channels conda-forge \
    && conda install airflow airflow-with-async airflow-with-atlas airflow-with-aws airflow-with-azure-mgmt-containerinstance airflow-with-azure_blob_storage airflow-with-azure_cosmos airflow-with-azure_data_lake airflow-with-cassandra airflow-with-celery airflow-with-cgroups airflow-with-cloudant airflow-with-crypto airflow-with-dask airflow-with-databricks airflow-with-datadog airflow-with-docker airflow-with-druid airflow-with-elasticsearch airflow-with-emr airflow-with-flask_oauth airflow-with-grpc airflow-with-hashicorp airflow-with-hdfs airflow-with-jdbc airflow-with-jenkins airflow-with-jira airflow-with-kerberos airflow-with-kubernetes airflow-with-ldap airflow-with-mongo airflow-with-mssql airflow-with-mysql airflow-with-oracle airflow-with-pagerduty airflow-with-papermill airflow-with-password airflow-with-postgres airflow-with-qds airflow-with-rabbitmq airflow-with-redis airflow-with-salesforce airflow-with-samba airflow-with-segment airflow-with-sendgrid airflow-with-sentry airflow-with-slack airflow-with-snowflake airflow-with-ssh airflow-with-statsd airflow-with-vertica airflow-with-virtualenv airflow-with-webhdfs airflow-with-winrm redis -y

COPY script/entrypoint.sh /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg

RUN chown -R airflow: ${AIRFLOW_USER_HOME}

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_USER_HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]
