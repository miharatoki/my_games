module ErrorHandle
  extend ActiveSupport::Concern

  included do
    class Forbidden < ActionController::ActionControllerError; end
    class IpAddressRejected < ActionController::ActionControllerError; end

    # サーバー側のエラー、メンテナンス、コードのミスなど
    rescue_from Exception, with: :rescue500
    # ユーザーが権限のないページにアクセスしようとした場合
    rescue_from ApplicationController::Forbidden, with: :rescure403
    # ユーザーのIPアドレスからはアクセスできない場合
    rescue_from IpAddressRejected, with: :rescue403
    # 詳細ページのurlで未発行、削除済のidを入力した時
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
    # 無効なurlを入力した時
    rescue_from ActionController::RoutingError, with: :rescue404

    def rescue500(e)
        @exception = e
        render 'errors/500'
    end

    def rescue403(e)
        @exception = e
        render 'errors/403'
    end

    def rescue404(e)
        @exception = e
        render 'errors/404'
    end
  end
end