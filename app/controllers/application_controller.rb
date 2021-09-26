class ApplicationController < ActionController::Base
  # 事前処理：もしdeviseに関するコントローラの処理であればconfigure_permitted_parametersメソッドを実行する
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  # 承認パラメータを構成するメソッド
  def configure_permitted_parameters
    # devise_parameter_sanitizerメソッド＝deviseにおけるparamsのようなメソッド
    # deviseのUserモデルにパラメーターを許可(許可のないパラメータをテーブルに保存しようとするとMysql2::Errorが起きる)
    # deviseの処理名:sign_up 、 許可するキー:name, :profile, :occupation, :position
    # UserモデルでもValidatesを追加して堰き止める
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :profile, :occupation, :position])
  end
end
