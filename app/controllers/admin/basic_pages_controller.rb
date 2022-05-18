# frozen_string_literal: true

class Admin::BasicPagesController < Admin::BaseController
  before_action :find_basic_page, except: %i[index new create]

  def index
    @basic_pages = BasicPage.includes(:seo, :themes)
      .apply_filters(params)
      .apply_sorts(params)
      .page(params[:page]).per(20)
  end

  def new
    @basic_page = BasicPage.new
    @basic_page.build_seo
    @basic_page.resources.new
  end

  def create
    @basic_page = BasicPage.new(basic_page_params)
    if @basic_page.save
      flash[:notice] = 'La page a été créée avec succès'
      redirect_to params[:continue].present? ? edit_admin_basic_page_path(@basic_page) : admin_basic_pages_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de la page"
      render :new
    end
  end

  def edit
    @basic_page.resources.new if @basic_page.resources.empty?
  end

  def update
    if @basic_page.update(basic_page_params)
      flash[:notice] = 'La page a été mise à jour avec succès'
      redirect_to params[:continue].present? ? edit_admin_basic_page_path(@basic_page) : admin_basic_pages_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la page"
      render :edit
    end
  end

  def edit_configuration
  end

  def update_configuration
    if @basic_page.update(basic_page_params)
      flash[:notice] = 'La page a été mise à jour avec succès'
      redirect_to params[:continue].present? ? edit_configuration_admin_basic_page_path(@basic_page) : admin_basic_pages_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la page"
      render :edit_configuration
    end
  end

  def position
    if params[:position].present?
      @basic_page.insert_at params[:position].to_i
      flash[:notice] = 'Les pages ont été réordonnées avec succès'
    end
    redirect_to admin_basic_pages_path
  end

  def destroy
    @basic_page.destroy
    flash[:notice] = 'La page a été supprimée avec succès'
    redirect_to admin_basic_pages_path
  end

  private

  def find_basic_page
    @basic_page = BasicPage.from_param params[:id]
  end

  # strong parameters
  def basic_page_params
    params.require(:basic_page).permit(
      :title, :description, :enabled,
      theme_ids: [],
      main_page_ids: [],
      seo_attributes: seo_attributes,
      resources_attributes: resources_attributes
    )
  end
end
