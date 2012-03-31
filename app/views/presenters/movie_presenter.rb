class MoviePresenter
  include Rails.application.routes.url_helpers

  def initialize(movies, ratings, params)
    @movies   = movies
    @ratings  = ratings
    @params   = params
  end

  def css_for_column(name)
    return "hilite" if @params["sort_by"] == name.to_s
    if !@params["sort_by"] && name == :title
      "hilite"
    end
  end

  def url_for_column(name)
    is_asc_current  = @params[:order] == "asc" && @params[:sort_by] == name.to_s
    params_hash     = {
      sort_by: name,
      order:   is_asc_current ? "desc" : "asc",
      filters: @params.fetch(:filters){{}}
    }
    movies_path(params_hash)
  end

  def ratings
    rating_pairs    = @ratings.zip([])
    current_ratings =
      @params
        .fetch(:filters){{}}
        .fetch(:ratings){{}}
    Hash[rating_pairs].merge(current_ratings)
  end

  def movies
    handler = MoviesSortedFiltered.new(@movies, @params) do |params|
      params[:filters][:ratings] = params[:filters].fetch(:ratings){{}}.keys
      params
    end

    handler.results
  end

end