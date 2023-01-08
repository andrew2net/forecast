# Forecast

This is a Ruby coding assessment project. The open-meteo.com API is used to fetch locations and forecasts.

## Prerequisites

Ruby version: 3.1.0

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Installation

- Clone the repository

```sh
git clone https://github.com/andrew2net/forecast.git
cd forecast
```

- Install dependencies

```sh
bundle install
```

- Set up the database

No databases are used in this project.

- Run the server

To enable the cache in development mode, use the following command once:

```sh
rails dev:cache
Development mode is now being cached.
```

To disable the cache, use the command again:

```sh
rails dev:cache
Development mode is no longer being cached.
```

To run the server use:

```sh
rails server
```

- Testing

To run the test suite, use the following command:

```sh
bundle exec rspec
```

## Usage

Visit <http://127.0.0.1:3000>, enter a zip code or a city name, and click the button "Search". Wait a few seconds until forecast is fetched. If successful, a found location, cache usage, and temperatures will be displayed. If unsuccessful, an error message will be shown.

## Documentation

- https://open-meteo.com/en/docs/geocoding-api#api-documentation
- https://open-meteo.com/en/docs/gem-api#api-documentation

## License

This project is licensed under the MIT License.
