class Hashtag < ActiveRecord::Base
	has_many :hashrelations, dependent: :destroy
	has_many :tweets, through: :hashrelations
	validates :name, presence: true, uniqueness: { case_sensitive: false }
end
