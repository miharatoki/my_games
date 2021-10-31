module ApplicationHelper
  def genre_search_array
    genre_search_array = []
    Genre.all.each { |genre| genre_search_array << [genre.name, genre.id] }
    genre_search_array << ['全て表示', 9]
    genre_search_array
  end

  def sort_array
    sort_array = ['新着順', '投稿順', '総合評価', 'ストーリー', 'グラフィック', '主題歌・BGM', '操作性', 'ゲームバランス']
    sort_array
  end

end
