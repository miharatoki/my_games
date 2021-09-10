module UsersHelper
  def no_posts?(user)
    user.posts.empty?
  end
end
