Rails.application.routes.draw do

  #deviseのusersルーティング設定（rails g deviseコマンドで自動作成）
  devise_for :users

  #ルート（基準Path)の設定。
  root to: "prototypes#index"
  
  #各コントローラへのルーティング設定
  # usersルーティング
  resources :users, only: [:edit, :update, :show]
  # prototypesルーティング設定。
  # コメントを投稿する際には、どのプロトタイプに対するコメントなのかをパスから判断できるようにしたい（ルーティングのネストを使用）
  # ネストを利用するとパスの:〇〇という部分に記述された値を、paramsとして送れる。もし、ネストを利用しなかった場合は、:〇〇のような、パスにパラメーターを含められる部分がない。
  # @prototype = Prototype.find(params[:id])
  resources :prototypes do
    resources :comments, only: [:index, :create]
  end
end
