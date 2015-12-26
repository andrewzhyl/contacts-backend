require 'jwt'

module API::V1::Defaults

  extend ActiveSupport::Concern

  included do
    prefix "api"
    version "v1", using: :path
    default_format :json
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    helpers do
      def permitted_params
        @permitted_params ||= declared(params,
                                       include_missing: false)
      end

      def clean_params(params)
        ActionController::Parameters.new(params)
      end

      def logger
        Rails.logger
      end

      def authenticate!
        begin
          puts "----22-----"
          puts request.headers.inspect

          payload, header = TokenProvider.valid?(token)
          @current_user = User.find_by(id: payload['user_id'])
        rescue
          error!('Unauthorized', 401)
        end
      end


      def current_user
        @current_user ||= authenticate!
      end

      def token
        request.headers['Authorization'].split(' ').last
      end

    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: e.message, status: 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error_response(message: e.message, status: 422)
    end

  end

end
