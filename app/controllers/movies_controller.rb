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
    @shouldRedirect = false
    @all_ratings = Movie.all_ratings

    puts params[:ratings]
    if params[:ratings]
      if params[:sort_by]
        session[:sort_by] = params[:sort_by]
      end
      session[:ratings] = params[:ratings]
      @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort_by])
    elsif params[:sort_by]
      session[:sort_by] = params[:sort_by]
      @movies = Movie.all.order(params[:sort_by])
    elsif session[:ratings]
      params[:ratings] = session[:ratings]
      @movies = Movie.where(:rating => session[:ratings].keys).order(session[:sort_by])
      @shouldRedirect = true
    elsif session[:sort_by]
      params[:sort_by] = session[:sort_by]
      @movies = Movie.all.order(session[:sort_by])
      @shouldRedirect = true
    else
      @movies = Movie.all
    end 

    if (@shouldRedirect)
      redirect_to movies_path(:sort => session[:sort_by], :ratings => session[:ratings])
    end

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
