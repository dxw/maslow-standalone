# Standalone Maslow [![Build Status](https://travis-ci.org/crossgovernmentservices/maslow-standalone.png?branch=master)](https://travis-ci.org/crossgovernmentservices/maslow-standalone)

This is a fork of [Maslow](https://github.com/alphagov/maslow), an app built by
the Government Digital Service to track the user needs behind GOV.UK.

This fork removes internal GDS dependencies and changes the app to store data
in its own database, rather than using the separate
[Need API](https://github.com/alphagov/govuk_need_api). This should make
it easier for other teams to set up their own instances.

## Dependencies

- Ruby (2.1.5)
- A running PostgreSQL instance

## Getting started

You can get started locally, or on [Heroku](https://heroku.com) with one-click deployment.

Note the app also comes with a Dockerfile, with an [example docker-compose configuration](https://github.com/crossgovernmentservices/dev-env/blob/4302de4f08b5178c771216db33ddacf1ce9ba808/docker-compose.yml#L1-L17)

## Getting started locally

    # Installs gem dependencies, creates database tables, and creates the first
    # user account
    bin/setup

    # Starts the Maslow server
    foreman start

### Running tests

Prepare the test database once:

    docker-compose run --rm maslow bin/rake db:test:prepare

Run the tests with:

    docker-compose run --rm maslow bin/rake spec

## Getting started on Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Follow the on-screen instructions, and once the app has successfully installed, you will be redirected to a login screen.

At this point, you have either provided Heroku with a subdomain for your app, or Heroku chose a name for you at random (e.g. **agile-wave-4184**)

Add a new user account using the following Rake task, e.g. user Jane with email address **jane@example.org** using password **a_random_password** for the Maslow instance at https://agile-wave-4184.herokuapp.com

    heroku  run bin/rake "users:create_first_user[Jane,jane@example.org,a_random_password]" --app agile-wave-4184
    

## Configuration

- `INSTANCE_NAME`: the name to give to this instance of Maslow (eg. your team or
  product name).
- `DATABASE_URI`: the URL to a PostgreSQL database in the production environment
- `FORCE_SSL`: when present, will force all requests to use SSL.
- `MASLOW_HOST`: the hostname on which Maslow is running, used to build URLs

### Email

- `EMAIL_FROM_ADDRESS`: the address which emails appear to be sent from
- `SMTP_HOST`: the hostname of the SMTP server used to send outbound emails
- `SMTP_USERNAME`: the username used to connect to the SMTP server
- `SMTP_PASSWORD`: the password used to connect to the SMTP server
- `SMTP_DOMAIN`: the HELO domain used when sending emails (optional)

### Basic authentication

In addition to the user authentication, you can protect the app with HTTP Basic
Authentication by setting the `USER` and `PASSWORD` configurations appropriately
in your environment.

## Major changes

- Data is now stored in a local PostgreSQL database, instead of making API
  requests to the Need API.

- The app has been upgraded to Rails 4.2, and includes a new RSpec test suite.

- The "need statuses" feature has been replaced with the ability to make
  separate decisions about whether a need is in scope, complete and being met.

- Organisation tagging has been replaced with a more flexible tagging feature,
  which allows for custom tag types to be created.

- User authentication is now provided by Devise instead of GOV.UK Signon.

- The notes, decisions and revisions for a need are displayed to users in a
  single feed for each need.

## Caveats

- We're currently missing the search and organisation filtering features. These
could be added back in the future.

- GOV.UK-specific questions have been removed from needs, such as the 'impact'
and 'justifications'.
