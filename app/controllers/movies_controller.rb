class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect_to movies_path(from_session) if from_session
    movies_param = setup_sorting_filtering_params
    order_clause = "#{movies_param[:sort_by]} #{movies_param[:order]}"
    @movies      = Movie.order_by(order_clause)
    @movies      = @movies.filter_on_ratings(movies_param[:ratings].keys) if movies_param[:ratings].keys.size > 0
    rating_pairs = Movie::ALL_RATINGS.zip([])
    @all_ratings = Hash[rating_pairs].merge(movies_param[:ratings])
    session[:movies_param] = movies_param
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def setup_sorting_filtering_params
    sort_by      = params[:sort_by] || "title"
    order_param  = params[:order]   || "asc"
    rating_param = params[:ratings] || {}
    { sort_by: sort_by, order: order_param , ratings: rating_param }
  end

  def from_session
    if session[:movies_param] && !params[:ratings] && !params[:sort_by] && !params[:order]
      session[:movies_param]
    end
  end
end
