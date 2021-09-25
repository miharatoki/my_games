module ErrorHandle

  extend ActiveSupport::Concern

  included do
    # サーバー側のエラー、メンテナンス、コードのミスなど
    rescue_from Exception, with: :rescue500
    # 詳細ページのurlで未発行、削除済のidを入力した時
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404

    def rescue500(e)
        render 'errors/500'
    end

    def rescue404(e)
        render 'errors/404'
    end
  end
end