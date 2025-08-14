# config/initializers/oas_rails.rb
OasRails.configure do |config|
  # Basic Information about the API
  config.info.title = 'Goodnight API'
  config.info.version = '1.0.0'
  config.info.summary = 'Goodnight API Documentation'
  config.info.description = <<~HEREDOC
    # Welcome to Goodnight app

    ## Question

    We want to know how do you structure the code and design the API
    Please use Rails for this project

    We would like you to implement a "good night" application to let users
    track when they go to bed and when they wake up.
    We require some restful APIS to achieve the following:
    1. Clock In operation, and return all clocked-in times, ordered by
    created time.
    2. Users can follow and unfollow other users.
    3. See the sleep records of a user's All following users' sleep
    records. from the previous week, which are sorted based on the duration
    of All friends sleep length.
    This is 3rd requirement response example
    {
    record 1 from user A,
    record 2 from user B,
    record 3 from user A,
    ...
    }
    Please implement the model, database migrations, schema, and JSON API.
    Additionally, write tests for the APIs.
    Consider that the system must efficiently handle a growing user base,
    managing high data volumes and concurrent requests. Document the
    strategies used to achieve this.
    You can assume that there are only two fields on the users "id" and
    "name"
    .
    You do not need to implement any user registration API.
    You can use any gems you like.
    *Sometimes, requirements may not be entirely clear. In such cases,
    please feel free to make reasonable assumptions and propose the best
    solution based on your experience and judgment.

    After you finish the project, please send me your GitHub project link.
    We want to see all of your development commits.
    - It is important to have separate commits with clear descriptions for
    each change.
    - In Tripla, it is not a good practice to have one commit with a lot of
    changes.
    Please ensure that you have granted permission for Google Meet to share
    your screen, as we may need you to do so during the meeting

  HEREDOC
  config.info.contact.name = 'mirzalazuardi hermawan'
  config.info.contact.email = 'mirzalazuardi@gmail.com'
  config.info.contact.url = 'https://mirzalazuardi.com'

  # Servers Information. For more details follow: https://spec.openapis.org/oas/latest.html#server-object
  config.servers = [{ url: 'http://localhost:3000', description: 'Local' }]

  # Tag Information. For more details follow: https://spec.openapis.org/oas/latest.html#tag-object
  config.tags = [{ name: "Users", description: "Manage the `amazing` Users table." }]

  # Optional Settings (Uncomment to use)

  # Extract default tags of operations from namespace or controller. Can be set to :namespace or :controller
  # config.default_tags_from = :namespace

  # Automatically detect request bodies for create/update methods
  # Default: true
  # config.autodiscover_request_body = false

  # Automatically detect responses from controller renders
  # Default: true
  # config.autodiscover_responses = false

  # API path configuration if your API is under a different namespace
  config.api_path = "/api/v1/users"

  # Apply your custom layout. Should be the name of your layout file
  # Example: "application" if file named application.html.erb
  # Default: false
  # config.layout = "application"

  # Override general rapi-doc settings
  # config.rapidoc_configuration
  # default: {}

  # Add a logo to rapi-doc
  # config.rapidoc_logo_url
  # default: nil

  # Excluding custom controllers or controllers#action
  # Example: ["projects", "users#new"]
  # config.ignored_actions = []

  # #######################
  # Authentication Settings
  # #######################

  # Whether to authenticate all routes by default
  # Default is true; set to false if you don't want all routes to include security schemas by default
  # config.authenticate_all_routes_by_default = true

  # Default security schema used for authentication
  # Choose a predefined security schema
  # [:api_key_cookie, :api_key_header, :api_key_query, :basic, :bearer, :bearer_jwt, :mutual_tls]
  # config.security_schema = :bearer

  # Custom security schemas
  # You can uncomment and modify to use custom security schemas
  # Please follow the documentation: https://spec.openapis.org/oas/latest.html#security-scheme-object
  #
  # config.security_schemas = {
  #  bearer:{
  #   "type": "apiKey",
  #   "name": "api_key",
  #   "in": "header"
  #  }
  # }

  # ###########################
  # Default Responses (Errors)
  # ###########################

  # The default responses errors are set only if the action allow it.
  # Example, if you add forbidden then it will be added only if the endpoint requires authentication.
  # Example: not_found will be setted to the endpoint only if the operation is a show/update/destroy action.
  # config.set_default_responses = true
  # config.possible_default_responses = [:not_found, :unauthorized, :forbidden, :internal_server_error, :unprocessable_entity]
  # config.response_body_of_default = "Hash{ message: String }"
  # config.response_body_of_unprocessable_entity= "Hash{ errors: Array<String> }"
end
