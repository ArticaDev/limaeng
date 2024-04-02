# README

## Install instructions

1. Install docker [and docker compose](https://www.docker.com/get-started/)
2. Clone this repo
3. Create a .env from the example provided, using `cp .env.example .env`
4. Run `docker-compose up`

After these steps, the API should be running at port 3000

Additionaly, if you have a local rails instalation and would like to use it, you can run `docker-compose up -d mongo` to boot only the database container and run `bundle exec rails s -p 3000 -b '0.0.0.0'` to run you rails server.