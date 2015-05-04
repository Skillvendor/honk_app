class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  before_create {
    set_register_fields
  }
  has_many :tweets, dependent: :destroy
  has_many :suggesteds, dependent: :destroy
  has_many :bans, dependent: :destroy
  has_many :active_followers, class_name:  "Follower",
                              foreign_key: "follower_id",
                              dependent:   :destroy

  has_many :passive_followers, class_name:  "Follower",
                               foreign_key: "followed_id",
                               dependent:   :destroy

  has_many :followers, through: :passive_followers
  has_many :following, through: :active_followers, source: :followed
  has_many :groups, through: :grouprel, dependent: :destroy
  has_many :grouprel, dependent: :destroy


  valid_email = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: {maximum: 50},
                              format: { with: valid_email },
                              uniqueness: { case_sensitive: false }

  validates :name, presence: true, length: {maximum: 25},
                              uniqueness: { case_sensitive: false }


  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    @tweets = Tweet.where("user_id in (?) OR user_id = ? ", following_ids, id)
    @tweets = @tweets.where(group: nil)
  end

  def group_feed(gid)
    Tweet.where(group: gid)
  end

  def follow(other_user)
    active_followers.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_followers.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def candidates(user)
    @following = user.following
  end

  def confirmed?
    self.activated == true
  end

  private

     def set_register_fields
      self.confirmation_code = SecureRandom.urlsafe_base64
      # for the time being, we don't want the link to expire
      # self.confirmation_expire = 10.hours.from_now
      #if Rails.env.development?
      #  self.confirmed = true
      #end
      true # if you remove this instruction I will kill you (Ionut)
    end
end
