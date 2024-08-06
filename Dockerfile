FROM python:3.10-slim-bullseye

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/usr/lib/oracle/21.15/client64/lib:${LD_LIBRARY_PATH}

# 更换为阿里云的 Debian 源并安装系统依赖项
RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list && \
    rm -Rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libaio1 \
        wget \
        unzip \
        python3-dev \
        default-libmysqlclient-dev \
        build-essential \
        pkg-config \
        procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 复制 requirements.txt 文件
COPY requirements/requirements.txt .

# 安装 Python 依赖项
RUN pip3 install --no-cache-dir --upgrade pip setuptools && \
    pip3 install --no-cache-dir --upgrade -r requirements.txt && \
    rm requirements.txt

# 下载并安装 Oracle Instant Client，然后清理下载的文件
RUN wget https://download.oracle.com/otn_software/linux/instantclient/2115000/instantclient-basic-linux.x64-21.15.0.0.0dbru.zip && \
    unzip instantclient-basic-linux.x64-21.15.0.0.0dbru.zip -d /usr/lib/oracle/ && \
    rm instantclient-basic-linux.x64-21.15.0.0.0dbru.zip && \
    mkdir -p /usr/lib/oracle/21.15 && \
    ln -s /usr/lib/oracle/instantclient_21_15 /usr/lib/oracle/21.15/client64 && \
    rm -rf /usr/lib/oracle/instantclient_21_15/*.md /usr/lib/oracle/instantclient_21_15/*.html

# 设置默认命令
CMD ["python3"]