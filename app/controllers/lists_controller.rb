class ListsController < ApplicationController
  before_action :set_lists

  def index
    @random_movie = Movie.all.sample
  end

  def show
    @selected_list = List.find(params[:id])
    @movies = @selected_list.movies
    @bookmark = Bookmark.new
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to list_path(@list), notice: "List created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_lists
    @lists = List.all
  end

  def list_params
    params.require(:list).permit(:name)
  end
end
