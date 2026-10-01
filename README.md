# Skylz

Rails 7 app for keeping track of your skills in various areas. Think of it as a personal database of the things you know that you don't want to forget.
Potential uses in organisations for keeping staff up-to-date with their knowledge and finding out what needs to be practiced.

Uses Tailwind CSS with Flowbite and Stimulus for JavaScript.

## Local development with Docker

Docker with Compose is the only prerequisite. Rails runs with the project's
locked Ruby 3.1.4 and gems; PostgreSQL 15 runs in its own container.

```bash
docker compose up -d --build web
```

Open http://localhost:3001. Startup prepares the database and builds Tailwind CSS.
The initial build downloads Ruby and compiles gems, so it takes a few minutes.
On a fresh database, sign in with `andy@andyfoster.net` / `changeme`, or register
a new account. The sample admin is seeded only in development.
Skill generation requires `OPENAI_API_KEY` in your shell before starting Compose.

```bash
# Logs
docker compose logs -f web
# Console
docker compose exec web bin/rails console
# Setup smoke test (registration, example data, skills, dashboard)
docker compose exec -e RAILS_ENV=test web bundle exec rspec spec/requests/local_setup_spec.rb
# Full legacy suites (currently contain stale fixtures and scaffold specs)
docker compose exec -e RAILS_ENV=test web bin/rails db:prepare
docker compose exec web bin/rails test
docker compose exec -e RAILS_ENV=test web bundle exec rspec
# Rebuild CSS automatically while editing
docker compose --profile watch up -d css
# Stop (database data is retained)
docker compose down
```

Source files are mounted into the Rails container, so edits reload normally.
Rebuild with `docker compose up -d --build web` after changing dependencies.
PostgreSQL is available at `127.0.0.1:5433`, user/password `skylz`/`skylz`,
database `skylz_development`. These credentials are for local development only.
The database lives in a Docker volume and survives container restarts.
Set `PORT` or `POSTGRES_PORT` before the Compose command to change published ports.

### Running Rails on the host instead

Install Ruby 3.1.4 (the version in `.ruby-version`), Node/npm, and libpq, then:

```bash
docker compose up -d db
bundle install
npm ci
bin/setup
bin/dev
```

`config/database.yml` defaults to the Docker database. Override connections with
`PGHOST`, `PGPORT`, `PGUSER`, and `PGPASSWORD` if needed.

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
