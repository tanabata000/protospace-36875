class Prototype < ApplicationRecord

  belongs_to :user
  
  # 外部キー制約：外部キーがないとDBに保存できないようにする仕組み。idカラムが空のまま保存されたり、意図しない値が保存されたりといったことを防ぐ。
  # 一方で外部キー制約のかかっている親（主キー）を削除しようとすると子（外部キー）の外部キー制約が発動し、エラーで削除できなくなる
  # 外部キー制約によりプロトタイプ（親）を削除しようとするとコメント（子）のデータがそのまま残ってしまう
  # dependent: :destroyによりプロトタイプ（親）が削除された時に紐づくコメント（子）も一緒に削除される
  has_many :comments, dependent: :destroy
  
  # PrototypeテーブルとActive Storageテーブルのアソシエーションを定義
  # 画像ファイルをPrototypeテーブルのレコードに添付できる。
  has_one_attached :image

  with_options presence: true do
    validates :title
    validates :catch_copy
    validates :concept
    validates :image
  end
end
