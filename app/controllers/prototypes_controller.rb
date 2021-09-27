class PrototypesController < ApplicationController
  
  # 【おまけ】ログインしていないUserは最初indexアクションに飛ばされる。例外はindexアクションとshowアクション
  # before_action :move_to_index, except: [:index, :show ]
  
  # authenticate_user!（deviseメソッド）によりログインしていないUserの遷移できるページを制限
  # indexアクションにアクセスした場合、indexアクションへのリダイレクト
  # 無限ループ対策として、except: :indexを付け加えている。
  # ログインしていなくても、詳細ページに遷移できる仕様にするためにexcept: [:index, :show]としている。
  before_action :authenticate_user!, except: [:index, :show, :destroy]

  def index
    # インスタンス変数@prototypesを定義し、すべてのPrototypeモデルの情報を代入
    # 記述方法には2種類ある。下記の記述でも同じ
    # @prototypes  = Prototype.includes(:user).order("created_at DESC")
    # SQL(RDBの操作を行うための言語)を使用。
    # DBからprototypesテーブルを選択。ORDER BY句でcreated_atを参照して降順に並べ替え
    query = "SELECT * FROM prototypes ORDER BY created_at DESC"

    # find_by_sqlメソッドでSQL文を使用し、Prototypeモデルのデータを検索し取得
    @prototypes = Prototype.find_by_sql(query)
  end


  def new
    # newアクションにインスタンス変数@prototypeを定義
    # Prototypeモデルの新規オブジェクト(レコード)を代入
    @prototype = Prototype.new
  end

  def create
    # Prototypeモデルの全レコード情報を取得
    @prototype = Prototype.create(prototype_params)
    if @prototype.save

      # 保存できた場合はトップページ（prototypes#index）
      redirect_to root_path
    else
      # 保存できなかった場合：newアクションに直接戻る（ページ再読み込みなし）
      render :new
      
    end
  end
  
  def show
    # findメソッドはモデル検索機能。DBのテーブルからレコードを1つ取り出す
    # params[:id]で「_prototype.html.erb」によりURLに紐づいたid情報（:id = prototype.id）を取得 
    # PrototypeモデルからURIのidのレコード（パラメータ）を検索し、@prototypeに代入
    @prototype = Prototype.find(params[:id])

    # Commentモデルの新規オブジェクト（レコード）を作成。@commentに代入
    @comment = Comment.new
    # URLのレコード情報に紐づくcommentsテーブルの全レコード情報を取得。@commentsに代入
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    
    @prototype = Prototype.find(params[:id])
    # もし、ログイン中のユーザーidがprototypeテーブルのuser_idと一致しない場合、トップページ（indexアクション）に遷移する
    unless current_user.id == @prototype.user_id
      redirect_to action: :index
    end
  end

  def update
    # 詳細ページのレコード情報を取得
    @prototype = Prototype.find(params[:id])
    # レコード（params）情報を更新できた場合トップページへ遷移
    if @prototype.update(prototype_params)
      redirect_to prototype_path

      # できなかった場合は編集ページに戻る
    else
      # redirect_toは入力情報が消えるが、renderは入力情報が消えない
      render :edit
    end
  end
  
  
  def destroy
    # 詳細ページのレコード情報を取得して削除し、トップページに遷移
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private

  # prototypeモデルで定義したnameという名前でアクセスできるようになった画像ファイルの保存を許可する実装を行います。
  def prototype_params
    # パラメータ設定：対象モデル（Prototype）対象カラム（:title, :catch_copy, :concept, :image）ハッシュ結合（user_idに現在ログイン中のユーザIDを紐付け）
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  # 【おまけ】Userがログインしていない場合はindexアクションを強制起動
  # befor_actionに指定する
  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end