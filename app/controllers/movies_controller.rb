class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    order_param  =  params[:sort_by] || "title"
    order_param  += params[:order] == "desc" ? " DESC" : " ASC"
    rating_param =  params[:ratings] || {}
    @movies      =  Movie.order_by(order_param)
    @movies      =  @movies.filter_on_ratings(rating_param.keys) if rating_param.keys.present?
    rating_pairs =  Movie::ALL_RATINGS.zip([])
    @all_ratings =  Hash[rating_pairs].merge(rating_param)
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

end
