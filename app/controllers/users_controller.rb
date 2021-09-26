class UsersController < ApplicationController

  def show
    # Userモデルの中からリクエストで送られてきたparamsのidに一致するレコードを取得
    # リクエストをしたuserのレコードを取得
    @user = User.find(params[:id])
    
    # includesメソッドの使い方は モデル名.includes(:紐付くモデル名)
    # モデル名：Prototype（Userモデルに紐づくprototypesテーブルなので、あくまで参照しているモデルはPrototypeモデルとなる）
    # 紐づくモデル名：user
    # リクエストを送ったuserのレコード情報（@user）に紐つくprototypesテーブルを参照し、userモデルに紐づける
    @prototypes = @user.prototypes.includes(:user)
  
      
  end
   # Commentモデルの新規オブジェクト（レコード）を作成。@commentに代入
  
   # URLのレコード情報に紐づくcommentsテーブルの全レコード情報を取得。@commentsに代入
   
 

end
