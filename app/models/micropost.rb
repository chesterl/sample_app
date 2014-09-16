class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope { order('created_at DESC') } #removed lamda to get tests to pass
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true
end
