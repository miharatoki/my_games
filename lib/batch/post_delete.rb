class Batch::PostDelete
  def self.post_delete
    guest = User.find_by(name: 'ゲストユーザー', email: 'guest@example.com')
    # ゲストユーザーに関連づけられた投稿とコメント、いいねを削除
    guest.posts.destroy_all
    p 'ゲストユーザーの投稿を削除しました'
  end
end