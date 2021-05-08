FROM ubuntu
RUN apt-get update \
    && apt-get install -y net-tools \
    && apt-get install -y iputils-ping
WORKDIR /app/chain33/
COPY resource/chain33  /app/chain33/
COPY resource/chain33-cli   /app/chain33/
CMD ["/app/chain33/chain33","-f","/app/chain33/chain33.toml"]