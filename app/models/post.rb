class Post < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  belongs_to :place
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images
end
