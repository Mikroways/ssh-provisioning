FROM alpine:3.7

COPY add-users.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/add-users.sh"]
