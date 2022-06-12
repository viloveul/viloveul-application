FROM maven:3.8.5-openjdk-8 AS builder
ENV HOME=/usr/app
RUN mkdir -p $HOME
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends unzip wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
ARG CONTEXT_HASH=3d801de07b3e55dbd4ae88edc5bc3963ab4e08e0
RUN wget https://github.com/viloveul/viloveul-package-context/archive/$CONTEXT_HASH.zip -O /tmp/viloveul-context.zip && \
    unzip /tmp/viloveul-context.zip -d /tmp && \
    mvn -f /tmp/viloveul-package-context-$CONTEXT_HASH clean install -DskipTests
RUN rm -rf /tmp/*
ADD pom.xml $HOME
RUN mvn verify --fail-never
ADD ./src $HOME/src
WORKDIR $HOME
RUN mvn clean compile package -DskipTests -Dspring.profiles.active=production

FROM openjdk:8-jre-slim
COPY --from=builder /usr/app/target/viloveul-application.jar /usr/src/application.jar
COPY ./viloveul.sh /usr/local/bin/viloveul
ENV HOME=/home/viloveul
RUN mkdir -p $HOME && \
    mkdir -p /app && \
    chmod a+x /usr/local/bin/viloveul
WORKDIR $HOME
STOPSIGNAL SIGINT
EXPOSE 8090
ENTRYPOINT ["/usr/local/bin/viloveul"]