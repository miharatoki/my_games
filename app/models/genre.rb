class Genre < ApplicationRecord
  has_many :posts, dependent: :destroy

  def self.select_array
    genres_array = Array.new
    self.all.each do |genre|
      genres_array << [genre.name, genre.id]
    end
    return genres_array
  end
end
