class User < ApplicationRecord
  has_many :prototypes
  has_many :comments
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # email,PWに関してはデフォルトでバリデーションがかかっているため記述の必要はない
  # Userモデルのusersテーブルの各カラムに「空の状態で保存できない」設定を付与
  with_options presence: true do
    validates :name
    validates :profile
    validates :occupation
    validates :position
  end
end

