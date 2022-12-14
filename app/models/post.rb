class Post < ApplicationRecord
  belongs_to :user
  belongs_to :genre, optional: true
  belongs_to :place, optional: true
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image
  has_many :post_tags,dependent: :destroy
  has_many :tags,through: :post_tags
  validates :title, presence: true
  validates :text, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_tag(sent_tags)
    # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
   end
end

def get_image
  (image.attached?) ? image : 'no_image.jpg'
end

def self.search(search)
  if Place.where('name LIKE ?', "#{search}%").present?
    joins(:place).where('places.name LIKE ?', "#{search}%")
  elsif search != ""
    where(['text LIKE(?) OR title LIKE(?) OR place_id LIKE(?)',"%#{search}%","%#{search}%","%#{search}%"])
  else
    Post.all
  end
end

end
