class ListsController < ApplicationController
   before_action :set_list, only: [:show, :edit, :update, :destroy]

  # GET /lists
  def index
    @lists = List.all
    @list = List.new
    @random_movies = Movie.all.sample(@lists.count)
  end

   # GET /lists/:id
  # Displays a single list and its associated movies
  def show
    # Get all movies belonging to this list
    @movies = @list.movies
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

  def edit
  end

  def update
     if @list.update(list_params)
      redirect_to root_path()
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy

    redirect_to root_path, status: :see_other, notice: "List was successfully deleted."
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :photo)
  end
end
