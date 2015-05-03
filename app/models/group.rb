class Group < ActiveRecord::Base
	has_many :users, through: :grouprel
	has_many :grouprel, dependent: :destroy
	has_many :bans, dependent: :destroy
	validates :name, presence: true, length: {maximum: 25},
                              uniqueness: { case_sensitive: false }
	validates :description, presence: true , length: {maximum: 140}

end
