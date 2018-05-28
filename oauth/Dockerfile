FROM a5huynh/oauth2_proxy
EXPOSE 80
COPY static /config/static/
COPY oauth2_proxy.cfg /config/
ENTRYPOINT ["./bin/oauth2_proxy", "-config=/config/oauth2_proxy.cfg", "-upstream"]
