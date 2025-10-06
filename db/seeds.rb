# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "json"
require "open-uri"

puts "Cleaning up..."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

urls = {
  "Top Rated"   => "https://tmdb.lewagon.com/movie/top_rated",
  "Now Playing" => "https://tmdb.lewagon.com/movie/now_playing",
  "Upcoming"    => "https://tmdb.lewagon.com/movie/upcoming",
  "Popular"     => "https://tmdb.lewagon.com/movie/popular"
}

urls.each do |list_name, url|
  puts "Creating list: #{list_name}"
  list = List.create!(name: list_name)

  movies = JSON.parse(URI.open(url).read)["results"]

  movies.each do |movie_data|
    # Skip movies with missing title or overview
    next if movie_data["title"].blank? || movie_data["overview"].blank?

    # Build full poster URL
    poster_url = movie_data["poster_path"].present? ? "https://image.tmdb.org/t/p/w500#{movie_data["poster_path"]}" : nil

    # Find or create the movie (avoid duplicates)
    movie = Movie.find_or_create_by!(
      title: movie_data["title"],
      overview: movie_data["overview"]
    )

    # Update poster and rating (in case they changed)
    movie.update!(
      poster_url: poster_url,
      rating: movie_data["vote_average"]
    )

    # Create a bookmark linking the movie to the list
    Bookmark.create!(
      list: list,
      movie: movie,
      comment: "Imported from #{list_name}"
    )
  end
end

puts "✅ Seeding complete: #{List.count} lists, #{Movie.count} movies, #{Bookmark.count} bookmarks."
