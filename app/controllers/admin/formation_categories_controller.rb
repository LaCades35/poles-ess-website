class Admin::FormationCategoriesController < Admin::BaseController

  before_action :get_formation_category, only: [:edit, :update, :destroy]

  def index
    @formation_categories = FormationCategory.order(:position)
      # .page(params[:page]).per(20)
  end

  def new
    @formation_category = FormationCategory.new
    @formation_category.build_seo
  end

  def create
    @formation_category = FormationCategory.new(formation_category_params)
    if @formation_category.save
      flash[:notice] = "La catégorie a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_formation_category_path(@formation_category) : admin_formation_categories_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la catégorie"
      render :new
    end
  end

  def edit
  end

  def update
    if @formation_category.update(formation_category_params)
      flash[:notice] = "Catégorie mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_formation_category_path(@formation_category) : admin_formation_categories_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la catégorie"
      render :edit
    end
  end

  def destroy
    begin
      @formation_category.destroy!
      flash[:notice] = "La catégorie a été supprimé avec succès"
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Vous ne pouvez pas supprimer cette catégorie car elle a des données dépendantes"
    end
    redirect_to action: :index
  end

  private # =====================================================

  def formation_category_params
    params.require(:formation_category).permit(:title, :position, :enabled,
        seo_attributes: seo_attributes)
  end

  def get_formation_category
    @formation_category = FormationCategory.from_param params[:id]
  end

end
