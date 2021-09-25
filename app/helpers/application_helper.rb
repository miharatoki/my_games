module ApplicationHelper

  def genre_search_array
    genre_search_array = []
    Genre.all.each { |genre| genre_search_array << [genre.name, genre.id] }
    genre_search_array << ['全て表示', 9]
    return genre_search_array
  end

  def sort_array
    sort_array = [
                  ['新着順', 'created_at DESC'], ['投稿順', 'created_at ASC'], ['総合評価', 'total_score DESC'], ['ストーリー', 'story_score DESC'],
                  ['グラフィック', 'graphic_score DESC'], ['主題歌・BGM', 'sound_score DESC'], ['操作性', 'operability_score DESC'], ['ゲームバランス', 'balance_score DESC']
                 ]
    return sort_array
  end
end
