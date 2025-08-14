class QueryCacheService
  include Pagy::Backend

  Result = Struct.new(:records, :pagination)

  def initialize(source, options = {})
    @source       = source
    @cache_key    = options[:cache_key]
    @page         = [options[:page].to_i, 1].max
    @items        = [0, Pagy::DEFAULT[:limit]].min
  end

  def call
    rows = source
    paginated_rows, pagy = paginate(rows)
    fullname_cache_key = "#{cache_key}:page#{page}_#{items}"

    records, pagination = Rails.cache.fetch(fullname_cache_key, expires_in: 15.minutes) do
      [pagy, paginated_rows]
    end
  end

  private

  attr_reader :source, :page, :items, :cache_key
  
  def paginate(scope)
    pagy, paginated_records = pagy(scope, page: page, items: items)
    [paginated_records, pagy]
  end
end
