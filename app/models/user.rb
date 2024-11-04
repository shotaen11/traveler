class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  has_many :read_counts, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  attachment :profile_image
  validates :name, presence: true

   # ユーザーをフォローする
   def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end  

    # 自分が特定のユーザーにフォローされているか確認
  def followed_by?(user)
    follower_user.include?(user)
  end

  def avatar
    if profile_image.present? && profile_image_attacher.present? && profile_image_attacher.file.present?
      puts "Profile image URL: #{profile_image_attacher.url}"  # デバッグ用
      profile_image_attacher.url
    else
      puts "No profile image found, using default."  # デバッグ用
      "no_image.svg" # デフォルトの画像パスを指定
    end
  end
  
end
