class Post < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :user
  has_many :post_comments, dependent: :destroy
  has_many :post_accesses, dependent: :destroy

  validates :title, presence: true #, length: {maximum: 30}
  validates :post_image, presence: true

  # 投稿にあるタグを更新＋新規タグを保存
  def get_tag(sent_tags)
    current_tags = tags.pluck(:name)
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
    # 古いタグを消す
    old_tags.each do |old|
      tags.delete Tag.find_by(name: old)
    end
    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      tags << new_post_tag
    end
  end

  # post_image画像サイズ変更用
  def get_image(width, height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end

  # 特定のpostのbookmarkをしているかどうか
  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end
end
