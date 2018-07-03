# MovieKin API
RoR API part of MovieKin, stackoverflow clone service for Q&A about movies.

## Tech Stack
* Ruby (v2.5.1)
* Ruby on Rails (v5.2.0)
* RSpec (v3.7)
* Rubocop (v0.56.0)
* Sidekiq (v5.1.3)
* Redis (v4.1.0)

## System Environment

### Development
* macOS version 10.13.5 (High Sierra).

### Deployment
* Not prepared yet.

## Run Development Server
Run sidekiq.
```sh
sidekiq
```
Register cron job (Sidekiq worker).
```sh
$ crontab -e
```
Add following line if there isn't.
```
0 6 * * 5 rake movie_task
```
Run rails server.
```sh
rails s
```

## Test

```
$ rspec [spec file path - optional]
```

## Deploy

### Database
Temporarily using sqlite3 (this project is not production-ready)

### Web Server
```
$ rails server
```