# frozen_string_literal: true

class Admin::PostsController < Admin::BaseController
  before_action :get_post, except: %i[index new create]

  def index
    params[:sort] ||= "sort_by_published_at desc"
    @posts = Post
      .includes(:seo, :themes, :post_category)
      .apply_filters(params).apply_sorts(params)
    # @pagy, @posts = pagy(Post.apply_filters(params))
  end

  def new
    @post = Post.new(published_at: Time.current)
    @post.build_seo
    @post.resources.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "L'actualité a été créée avec succès"
      redirect_to params[:continue].present? ? edit_admin_post_path(@post) : admin_posts_path
    else
      @post.resources.new if @post.resources.empty?
      flash[:error] = "Une erreur s'est produite lors de la création de l'actualité"
      render :new
    end
  end

  def edit
    @post.resources.new if @post.resources.empty?
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "L'actualité a été mise à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_post_path(@post) : admin_posts_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'actualité"
      render :edit
    end
  end

  def edit_configuration
  end

  def update_configuration
    if @post.update(post_params)
      flash[:notice] = "L'actualité a été mise à jour avec succès"
      redirect_to params[:continue].present? ? edit_configuration_admin_post_path(@post) : admin_posts_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'actualité"
      render :edit_configuration
    end
  end

  def destroy
    begin
      flash[:notice] = "L'actualité a bien été supprimée" if @post.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Cette actualité ne peut être supprimée car des éléments lui sont dépendants"
    end
    redirect_to admin_posts_path
  end

  private

  def get_post
    @post = Post.from_param params[:id]
  end

  def post_params
    params
      .require(:post)
      .permit(
        :post_category_id,
        :title,
        :description,
        :image,
        :published_at,
        :expired_at,
        :enabled,
        theme_ids: [],
        profile_ids: [],
        seo_attributes: seo_attributes,
        resources_attributes: resources_attributes
      )
  end
end
