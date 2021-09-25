module PostsHelper

  def genre_array
    genre_array = []
    Genre.all.each { |genre| genre_array << [genre.name, genre.id] }
    return genre_array
  end

end
