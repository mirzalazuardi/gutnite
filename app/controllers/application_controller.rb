class ApplicationController < ActionController::API
  include Pagy::Backend

  rescue_from ActiveRecord::AssociationNotFoundError do |exception|
    render json: { error: "Association not found: #{exception.message}" }, status: :not_found
  end

  def render_list(source, serializer, opts = {}, opt_serializer = {})
    if source.empty?
      render json: [], status: :ok
    else
      pagy, records = QueryCacheService.new(source, **opts).call
      pagy_headers_merge(pagy)
      render json: serializer.new(records, **opt_serializer).serialize, status: :ok
    end
  end
end
