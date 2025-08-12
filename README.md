# Goodnight App

## setup

1. After cloning the repository, run the following command to install dependencies:
    ```
    bundle install
    rails db:drop db:create db:migrate db:seed
    ```
2. Start the Rails server:
    ```
    rails server
    ```
3. Open your browser and navigate to `http://localhost:3000/docs`, i'm already provide API documentation on this path,
    this also can hit the endpoints directly from the browser.
4. Happy testing!

## spec files

- `spec/requests/api/v1/follows_spec.rb`: Contains tests for the follow API endpoints.
- `spec/requests/api/v1/sleep_records_spec.rb`: Contains tests for the sleep records API endpoints.
