# frozen_string_literal: true

class Post < ApplicationRecord
  include Themable
  include Profilable
  include Seoable
  include Resourceable
  include Enablable
  include RichDescription

  include PgSearch::Model
  multisearchable against: [:title, :search_description]

  # Configurations =============================================================
  PUBLICATION_STATES = {
    draft: "Brouillon",
    published: "Publiée",
    expired: "Expirée"
  }.freeze

  has_one_attached :image

  # Associations ===============================================================
  belongs_to :post_category, inverse_of: :posts, optional: true

  # Callbacks ==================================================================
  validates :title, presence: true
  validates :published_at, presence: true
  validates :image, content_type: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']

  # Scopes =====================================================================
  scope :by_title, ->(val) {
    val.downcase!
    where(Post.arel_table[:title].matches("%#{val}%"))
  }
  scope :by_post_category, ->(val) { where(post_category_id: val) }

  scope :sort_by_post_category_title, ->(order) { joins(:post_category).order(Category.arel_table[:title].public_send(order.downcase)) }
  scope :draft, -> { where(Post.arel_table[:published_at].gt(Time.current)) }
  scope :expired, -> { where(Post.arel_table[:expired_at].lt(Time.current)) }
  scope :published, -> {
    where(Post.arel_table[:published_at].lt(Time.current))
      .where(Post.arel_table[:expired_at].eq(nil).or(Post.arel_table[:expired_at].gt(Time.current)))
  }
  # Class Methods ==============================================================

  def self.apply_filters(params)
    klass = self

    if params[:by_state].present?
      klass = case params[:by_state]
              when "draft"
                klass.draft
              when "published"
                klass.published
              when "expired"
                klass.expired
              else
                klass
              end
    end
    klass = klass.by_title(params[:by_title]) if params[:by_title].present?
    klass = klass.by_post_category(params[:by_post_category]) if params[:by_post_category].present?
    klass = klass.by_theme(params[:by_theme]) if params[:by_theme].present?
    klass = klass.by_profile(params[:by_profile]) if params[:by_profile].present?
    klass.distinct
  end

  def self.apply_sorts(params)
    self.order(published_at: :desc)
  end

  # Instance methods ====================================================

  def relationships
    relationships = []
    relationships << self.themes.enabled
    relationships << self.profiles.enabled
    relationships << self.post_category
    relationships.compact.flatten
  end

  def publication_state
    if published_at > Time.current
      :draft
    elsif expired_at && expired_at < Time.current
      :expired
    else
      :published
    end
  end

  def cover_picture
    @cover_picture ||= pictures.first.presence
  end

  def publication_state_humanized
    PUBLICATION_STATES[publication_state]
  end

  private #=====================================================================
end
