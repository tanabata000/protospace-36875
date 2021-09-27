class CommentsController < ApplicationController

  def create
    # Commentモデルの全レコード情報を取得（comment_paramsメソッド使用）
    comment = Comment.create(comment_params)
    if comment.save
    # 保存できた場合、
    redirect_to prototype_path(comment.prototype_id)
    # redirect_to "/prototypes/#{comment.prototype_id}"  # コメントと結びつく画像の詳細画面に遷移する
    else 
      # prototypesコントローラのshowアクションのリクエストによりparamsが送られてくる
      # リクエストにより送られてきたparamsのキー（:prototype_id）に紐づいた値を取得
      # Prototypeモデルからprototype_idの値が一致したレコードを検索し、@prototypeに代入
      @prototype = Prototype.find(params[:prototype_id])
      
      @comment = Comment.new
      # 画像（prototype）に紐づくcommentsのレコードを取得し、@commentsに代入
      @comments = @prototype.comments
      # prototypesのビューファイルのshowを表示
      render "prototypes/show"
    end
  end


  private
  # ストロングパラメータ設定
  def comment_params
    # ルーティングネストによりcommentsコントローラのcreateアクションにprototypesのURIに紐づいたcommentsのURIを生成できる（ /prototypes/:prototype_id/comments(.:format)  comments#create ）
    # パラメータ設定：対象モデル（comment）対象カラム（:image, :content）ハッシュ結合（user_id：ログイン中のユーザID, prototype_id: パラメータ[詳細画面からのリクエストのparamsに含まれた画像のid（prototype_id）]
    # comments#createのURIパターン（ /prototypes/:prototype_id/comments ）。この:prototype_idの中にprototype.idが入っている。
    # prototype_id: params[:prototype_id]という記述で詳細ページから取得したprototypeテーブルのid情報をcommentsテーブルのprototype_idに送っている（prototype.id = comments.prototype_idとなる）
    params.require(:comment).permit(:image, :content).merge(user_id: current_user.id, prototype_id: params[:prototype_id] ) 
  end
end
