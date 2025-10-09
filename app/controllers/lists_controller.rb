class ListsController < ApplicationController

  # GET /lists
  def index
    @lists = List.all
    @list = List.new
    @random_movies = Movie.all.sample(@lists.count)
  end

   # GET /lists/:id
  # Displays a single list and its associated movies
  def show
    # Find the selected list by its ID
    @selected_list = List.find(params[:id])
    # Get all movies belonging to this list
    @movies = @selected_list.movies
    # Initialize a new bookmark for adding movies to the list
    @bookmark = Bookmark.new
  end

  # GET /lists/new
  # Renders a form for creating a new list
  def new
    @list = List.new
  end

  # POST /lists
  # Creates a new list and saves it to the database
  def create
    # Build a new list object with the permitted parameters
    @list = List.new(list_params)
    # If successfully saved → redirect to the show page
    if @list.save
      redirect_to list_path(@list), notice: "List created successfully!"
    # If validation fails → re-render the form with error messages
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
