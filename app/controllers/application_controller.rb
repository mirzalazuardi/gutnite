class ApplicationController < ActionController::API
  rescue_from ActiveRecord::AssociationNotFoundError do |exception|
    render json: { error: "Association not found: #{exception.message}" }, status: :not_found
  end
end
