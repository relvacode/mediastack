FROM a5huynh/oauth2_proxy
EXPOSE 9000
RUN adduser -D -u 1000 oauth2_proxy
COPY static /config/static/
COPY oauth2_proxy.cfg /config/
USER oauth2_proxy
ENTRYPOINT ["./bin/oauth2_proxy", "-config=/config/oauth2_proxy.cfg", "--http-address=0.0.0.0:9000", "-upstream"]
