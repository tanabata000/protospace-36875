class CommentsController < ApplicationController

  def create
    # Commentモデルの全レコード情報を取得
    comment = Comment.create(comment_params)
    if comment.save
    # 保存できた場合、
    redirect_to prototype_path(comment.prototype_id)
    # redirect_to "/prototypes/#{comment.prototype_id}"  # コメントと結びつく画像の詳細画面に遷移する
    else 
      #コントローラが異なるのでprototypesコントローラのshowアクションの＠変数の内容をcommentsコントローラに再定義
      @prototype = Prototype.find(params[:prototype_id])
      @comment = Comment.new
      # prototypesのビューファイルのshowを表示
      render "prototypes/show"
    end
  end


  private
  # ストロングパラメータ設定
  # prototypeモデルで定義したnameという名前でアクセスできるようになった画像ファイルの保存を許可する実装を行います。
  def comment_params
    # ルーティングネストによりcommentsコントローラのcreateアクションにprototypesのURIに紐づいたcommentsのURIを生成できる（　/prototypes/:prototype_id/comments(.:format)  comments#create　）
    # パラメータ設定：対象モデル（comment）対象カラム（:image, :content）ハッシュ結合（user_id：ログイン中のユーザID, prototype_id: パラメータ[現在リンクに表示されている画像（prototype）データid]
    params.require(:comment).permit(:image, :content).merge(user_id: current_user.id, prototype_id: params[:prototype_id] ) 
  end
end
