FROM python:3.10-slim-bullseye

# 设置环境变量
ENV ORACLE_HOME=/opt/oracle/instantclient
ENV LD_LIBRARY_PATH=$ORACLE_HOME
ENV PATH=$ORACLE_HOME:$PATH

# 安装必要的依赖项
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libaio1  \
    libc6-dev \
    wget  \
    gcc \
    libpq-dev \
    unzip &&  \
    rm -rf /var/lib/apt/lists/*

# 下载 Oracle Instant Client
RUN mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/2115000/instantclient-basic-linux.x64-21.15.0.0.0dbru.zip && \
    unzip instantclient-basic-linux.x64-21.15.0.0.0dbru.zip && \
    rm -f *.zip  && \
    mv instantclient_21_15 instantclient

RUN pip install --upgrade pip && pip install cx-Oracle