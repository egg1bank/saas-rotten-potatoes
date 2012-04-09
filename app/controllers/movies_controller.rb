class MoviesController < ApplicationController
  helper_method :presenter, :movie

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def index
    redirect_to movies_path(from_session) if from_session.present?
    @movies = Movie.scoped
    session[:movies_hash] = params.slice(:order, :sort_by, :filters)
  end

  def new

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

  def similar
    @movies = movie.similar
    if @movies.blank?
      redirect_to movies_path, notice: "'#{movie.title}' has no director info"
    end
  end

  private

  def from_session
    if session[:movies_hash] && !params[:filters] && !params[:sort_by] && !params[:order]
      session[:movies_hash]
    end
  end

  def movie
    Movie.find(params[:id])
  end

  def presenter
    MoviePresenter.new(@movies, Movie::ALL_RATINGS, params)
  end
end
