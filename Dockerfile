FROM hkjn/docker:17.06.2-ce
RUN apk add --no-cache python3 && \
    pip3 install docker-squash
ENTRYPOINT ["/usr/bin/docker-squash"]
CMD [""]

