class SearchesController < ApplicationController
    before_action :get_path

    def genre_search

      searched_posts = Post.where(genre_id: (params[:genre]))
      @posts = searched_posts.page(params[:page]).per(6)
      if @path[:controller] == 'users'
        @user = User.find(params[:user_id])
        render 'users/show'
      elsif @path[:controller] == 'posts'
        render 'posts/index'
      end
    end

    private
    def get_path
      @path = Rails.application.routes.recognize_path(request.referer)
    end
end
