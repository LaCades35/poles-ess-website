class Admin::ThemesController < Admin::BaseController
  include DestroyableUpload

  before_action :get_theme, except: %i[index new create]

  def index
    @themes = Theme.includes(:seo).order(:position)
  end

  def new
    @theme = Theme.new
    @theme.build_seo
    @theme.resources.new
  end

  def create
    @theme = Theme.new(theme_params)
    if @theme.save
      flash[:notice] = "Le thème a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_theme_path(@theme) : admin_themes_path
    else
      @theme.resources.new if @theme.resources.empty?
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du thème"
      render :new
    end
  end

  def edit
    @theme.resources.new if @theme.resources.empty?
  end

  def update
    if @theme.update(theme_params)
      flash[:notice] = "Thème mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_theme_path(@theme) : admin_themes_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du thème"
      render :edit
    end
  end

  def edit_configuration
    2.times { @theme.menu_blocks.new } if @theme.menu_blocks.empty?
  end

  def update_configuration
    if @theme.update(theme_params)
      flash[:notice] = "Thème mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_configuration_admin_theme_path(@theme) : admin_themes_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du thème"
      render :edit_configuration
    end
  end

  def destroy
    begin
      @theme.destroy!
      flash[:notice] = "Le thème a été supprimé avec succès"
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Vous ne pouvez pas supprimer ce thème car il a des données dépendantes"
    end
    redirect_to action: :index
  end

  private # =====================================================

  def theme_params
    params.require(:theme).permit(
      :title, :description, :short_description, :baseline, :image, :position, :enabled,
      seo_attributes: seo_attributes, resources_attributes: resources_attributes, menu_blocks_attributes: menu_blocks_attributes
    )
  end

  def get_theme
    @theme = Theme.from_param params[:id]
  end

end
