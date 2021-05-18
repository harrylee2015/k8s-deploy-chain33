FROM ubuntu
RUN apt-get update \
    && apt-get install -y net-tools \
    && apt-get install -y iputils-ping
WORKDIR /app/chain33/
COPY resource/chain33  /app/chain33/
COPY resource/chain33-cli   /app/chain33/
COPY resource/start.sh   /app/chain33/
COPY yaml/chain33-config.yaml /app/chain33/
COPY yaml/chain33-service.yaml /app/chain33/
COPY yaml/chain33-statefulSet.yaml /app/chain33/
COPY yaml/chain33-storageClass.yaml /app/chain33/
RUN chmod +x /app/chain33/start.sh
CMD ["/app/chain33/chain33","-f","/app/chain33/chain33.toml"]