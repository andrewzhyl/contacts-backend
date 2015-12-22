require 'jwt'
require "grape-swagger"

module API::V1
  class Base < Grape::API

    mount API::V1::Auth
    mount API::V1::Users
    mount API::V1::Contacts

    add_swagger_documentation(
      api_version: "v1",
      hide_documentation_path: true,
      mount_path: GrapeSwaggerRails.options.url,
      hide_format: true
    )

  end
end
