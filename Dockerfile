FROM nginx
LABEL maintainer=jxy133@student.bham.ac.uk
EXPOSE 80

RUN apt update && \
    apt install -y curl unzip
ARG GCC_VERSION=10
RUN apt install -y g++-$GCC_VERSION build-essential
ARG JDK_VERSION=17
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install -y openjdk-$JDK_VERSION-jdk-headless openjdk-$JDK_VERSION-jdk
ARG PYTHON_VERSION=3.9
RUN apt install -y python$PYTHON_VERSION
RUN apt install -y ruby
ARG NODEJS_VERSION=18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt install -y nodejs
ARG CODEQL_VERSION=2.10.1
RUN mkdir /codeql-home && \
    curl -fSsLk "https://github.com/github/codeql-cli-binaries/releases/download/v$CODEQL_VERSION/codeql-linux64.zip" -o /tmp/codeql-linux64.zip && \
    unzip -q /tmp/codeql-linux64.zip -d /tmp && \
    curl -fSsLk "https://github.com/github/codeql/archive/refs/tags/codeql-cli/v$CODEQL_VERSION.zip" -o /tmp/codeql.zip && \
    unzip -q /tmp/codeql.zip -d /tmp && \
    mv /tmp/codeql-codeql-cli-v$CODEQL_VERSION /codeql-home/codeql-repo && \
    mv /tmp/codeql /codeql-home && \
    rm -rf /tmp/codeql-linux64.zip /tmp/codeql.zip
ENV PATH="/codeql-home/codeql:${PATH}"
COPY server /opt/
COPY build/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf
CMD ["/opt/server"]