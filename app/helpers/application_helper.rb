module ApplicationHelper
  def genre_array
    genre_array = []
    Genre.all.each do |genre|
      genre_array << [genre.name, genre.id]
    end
    genre_array
  end
end
