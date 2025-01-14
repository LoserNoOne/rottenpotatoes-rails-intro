class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.ratings
    session[:ratings] ||= @all_ratings

    session[:ratings] = params[:ratings].keys if params[:ratings]
    session[:method] = params[:method] if params[:method]

    # if params[:method].nil? && params[:ratings].nil? && (!session[:method].nil? || !session[:ratings].nil?)
    #   redirect_to movies_path(:method => session[:method], :ratings => session[:ratings])
    # end

    @ratings = session[:ratings]
    @sort = session[:method]

    @movies = Movie.where(rating: @ratings).order(@sort)
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
