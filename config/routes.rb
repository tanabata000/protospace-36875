Rails.application.routes.draw do

  #deviseのusersルーティング設定（rails g deviseコマンドで自動作成）
  devise_for :users

  #ルート（基準Path)の設定。
  root to: "prototypes#index"
  
  #各コントローラへのルーティング設定
  # usersルーティング
  resources :users, only: [:edit, :update, :show]
  # prototypesルーティング
  resources :prototypes do
    resources :comments, only: [:index, :create]
  end
end
