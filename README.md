# Skylz

Rails 7 app for keeping track of your skills in various areas. Think of it as a personal database of the things you know that you don't want to forget.
Potential uses in organisations for keeping staff up-to-date with their knowledge and finding out what needs to be practiced.

Uses Tailwind CSS with Flowbite and Stimulus for JavaScript.

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

Start the dev server to keep Tailwind settings up to date:

```
$ ./bin/dev
```


## Troubleshooting Postgres on Local

If you get this error message:
`psql: error: connection to server on socket "/tmp/.s.PGSQL.5432" failed: No such file or directory`
you can try this:

 ```bash
$ rm /usr/local/var/postgres/postmaster.pid

$ brew services restart postgresql
```

[From Stack Overflow](https://stackoverflow.com/questions/69754628/psql-error-connection-to-server-on-socket-tmp-s-pgsql-5432-failed-no-such)

## Pulling production database to local

### backup local

```bash
$ pg_dump -U andy skylz_development > skylz_development_backup-DATE.sql

# ChatGPT suggests:
# $ pg_dump -Fc --no-acl --no-owner -h localhost -U <user> skylz_development > latest.dump

$ rails db:drop
$ rails db:create
```

### Pull down from heroku


```bash
$ heroku pg:backups:capture --app skylz
$ heroku pg:backups:download --app skylz
```

and to restore:

```bash
$ pg_restore -d skylz_development latest.dump
```


maybe try this:

```bash
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U <user> -d skylz_development latest.dump
```
