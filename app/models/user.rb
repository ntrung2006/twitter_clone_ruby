class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :following_relations, class_name: 'Following', foreign_key: 'follower_id', dependent: :destroy
  has_many :followees, through: :following_relations, source: :followee

  has_many :followed_relations, class_name: 'Following', foreign_key: 'followee_id', dependent: :destroy
  has_many :followers, through: :followed_relations, source: :follower

  has_many :posts, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  def follow(other)
    followees << other
  end

  def unfollow(other)
    followees.destroy(other)
  end

  def following?(other)
    User.joins(:following_relations).where('followings.followee_id = ? AND followings.follower_id = ?', other.id, id).any?
  end
end
