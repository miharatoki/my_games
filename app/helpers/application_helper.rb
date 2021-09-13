module ApplicationHelper
  def genre_array
    genre_array = []
    Genre.all.each do |genre|
      genre_array << [genre.name, genre.id]
    end
    genre_array
  end
  
  def sort_array
    sort_array = [['新着順', 'created_at DESC'], ['投稿順', 'created_at ASC'], ['総合評価', 'total_score DESC'], ['ストーリー', 'story_score DESC'], ['グラフィック', 'graphic_score DESC'],
                  ['主題歌・BGM', 'sound_score DESC'], ['操作性', 'operability_score DESC'], ['ゲームバランス', 'balance_score DESC']]
  end
end
