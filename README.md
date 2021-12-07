# Cased Shell on Heroku

This repo contains the configuration of a Heroku application that combines [Cased Shell](https://cased.com), [a SSH daemon that authenticates against Heroku](https://github.com/cased/ssh-oauth-handlers), and the Heroku CLI. The result allows your team to use the Heroku CLI in a secure, auditable fashion.

<img width="1050" alt="image" src="https://user-images.githubusercontent.com/47/144297536-638f3cd3-acff-4d86-9afb-1fa62d0bb73e.png">

## Deploying

1. Create a [new Heroku app](https://dashboard.heroku.com/new-app).
2. Create a [new Cased Shell instance](https://app.cased.com/shells/new) with a matching hostname. On the Settings tab, enable Certificate Authentication.
3. Fork and clone this repo.
4. Run the following commands to deploy Cased Shell to Heroku:

```
export APP_NAME=your-heroku-app-name

heroku git:remote -a $APP_NAME
heroku stack:set container
heroku labs:enable runtime-dyno-metadata

heroku config:add CASED_SHELL_HOSTNAME=$APP_NAME.herokuapp.com
heroku config:add CASED_SHELL_SECRET=<obtain from your Shell Instance's Settings tab on https://app.cased.com/>

# Create a new Heroku OAuth client. Used to authenticate and authorize connections to the Heroku CLI.
heroku plugins:install heroku-cli-oauth
heroku clients:create "$APP_NAME.herokuapp.com" https://$APP_NAME.herokuapp.com/oauth/auth/callback
heroku config:add HEROKU_OAUTH_ID=<set to `HEROKU_OAUTH_ID` from command output above>
heroku config:add HEROKU_OAUTH_SECRET=<set to `HEROKU_OAUTH_SECRET` from command output above>
heroku config:add COOKIE_SECRET=`openssl rand -hex 32`
heroku config:add COOKIE_ENCRYPT=`openssl rand -hex 16`

git push heroku main
```

Open https://$APP_NAME.herokuapp.com in your browser and login.

## Configuring your Shell

To change the prompts displayed by your shell, edit `jump.yaml`, commit, and push to Heroku. See https://github.com/cased/jump#writing-queries for documentation covering the format of `jump.yaml`.
