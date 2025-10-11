class BookmarksController < ApplicationController

  # GET /lists/:list_id/bookmarks/new
  # Displays the form to add a new movie (bookmark) to a specific list
  def new
    # Find the parent list from the URL parameter
    @list = List.find(params[:list_id])

    # Initialize a new, empty bookmark for the form
    @bookmark = Bookmark.new
  end

  # POST /lists/:list_id/bookmarks
  # Creates and saves a new bookmark (movie + comment) in the selected list
  def create
    # Find the list the bookmark will belong to
    @list = List.find(params[:list_id])

    # Build a new bookmark object using form parameters
    @bookmark = Bookmark.new(bookmark_params)

    # Explicitly associate the bookmark with the selected list
    @bookmark.list = @list

    # If validation passes and the bookmark is saved successfully
    if @bookmark.save
      # Redirect back to the list page with a success message
      redirect_to @list, notice: "Movie added to the list!"
    else
      # If saving fails (e.g. validation error), re-render the list view
      # with errors visible in the modal or form
      @list = @list
      @movies = @list.movies
      render "lists/show", status: :unprocessable_entity
    end
  end

  # DELETE /bookmarks/:id
  # Deletes a bookmark (removes a movie from a list)
  def destroy
    # Find the bookmark by ID
    @bookmark = Bookmark.find(params[:id])

    # Remove it from the database
    @bookmark.destroy

    # Redirect back to the list page the bookmark belonged to
    redirect_to @bookmark.list, notice: "Bookmark removed!"
  end

  private

  # Strong parameters – only allow these fields to be submitted from the form
  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id)
  end
end
