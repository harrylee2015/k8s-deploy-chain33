FROM busybox:latest
WORKDIR  /app/chain33
COPY replace.sh /app/chain33/
RUN chmod +x /app/chain33/replace.sh
CMD ["sh","replace.sh"]