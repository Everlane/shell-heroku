FROM ghcr.io/cased/shell:pr-28
COPY --from=ghcr.io/cased/ssh-oauth-handlers:latest /bin/app /bin/heroku-ssh
COPY --from=ghcr.io/cased/jump:latest /bin/app /bin/jump
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
CMD []
ADD entrypoint.sh jump.yml /
RUN curl https://cli-assets.heroku.com/install.sh | sh
