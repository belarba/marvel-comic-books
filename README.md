# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# Marvel Comics App

This project is a Rails application that interacts with the Marvel API to fetch information about comics and characters.

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Testing](#testing)
- [API Rate Limiting](#api-rate-limiting)


## Installation

To get started with the application, you need to have Ruby and Rails installed on your machine. Follow the steps below:

1. **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/marvel-comics-app.git
    cd marvel-comics-app
    ```

2. **Install the dependencies:**
    ```bash
    bundle install
    ```

## Configuration

You need to set up the Marvel API keys to interact with the API. Follow the steps below:

1. **Create `.env` file:**
    ```bash
    touch .env
    ```

2. **Add your Marvel API keys to the `.env` file:**
    ```env
    MARVEL_PUBLIC_KEY=your_public_key
    MARVEL_PRIVATE_KEY=your_private_key
    ```

3. **Install `dotenv-rails` gem (if not already installed):**
    Add this line to your Gemfile:
    ```ruby
    gem 'dotenv-rails', groups: [:development, :test]
    ```

    Then run:
    ```bash
    bundle install
    ```

## Usage

  To start the Rails server, run:
  ```bash
  rails server
  ```
Visit `http://localhost:3000` in your web browser to access the application. 

## Testing

  To run the tests, run:
  ```bash
  rails test
  ```
**Mocking API Requests**

This projects uses [Webmock](https://github.com/bblimke/webmock) to mock API durubg testing. The test suite includes tests for `MarvelService` and `ComicsController`.

## API Rate Limiting

To handle API rate limiting, the application implements caching for the API responses using [Rails Cache](https://guides.rubyonrails.org/caching_with_rails.html). Additionally, consider implementing retry lofic with exponential backoff.
