FROM docker
RUN apk add --no-cache python3 && \
    pip3 install docker-squash
ENTRYPOINT ["/usr/bin/docker-squash"]
CMD [""]

