class Admin::FormationsController < Admin::BaseController
  include DestroyableUpload

  before_action :get_formation, except: %i[index new create]

  def index
    @formations = Formation
      .apply_filters(params)
      .page(params[:page]).per(25)
  end

  def new
    @formation = Formation.default
  end

  def create
    @formation = Formation.new(formation_params)
    if @formation.save
      flash[:notice] = "La formation a été créée avec succès"
      redirect_to params[:continue].present? ? edit_admin_formation_path(@formation) : admin_formations_path
    else
      @formation.schedules.new  if @formation.schedules.empty?
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la formation"
      render :new
    end
  end

  def edit
  end

  def update
    # weird bug preventing schedules modifications to be saved otherwise
    @formation.assign_attributes(formation_params)
    if formation_params[:schedules_attributes].present?
      formation_params[:schedules_attributes].each do |idx, schedule_params|
        if schedule_params.fetch(:id).present?
          schedule = @formation.schedules.find(schedule_params.fetch(:id))
          schedule.assign_attributes(schedule_params.except(:_destroy))
          schedule.save
        end
      end
    end

    if @formation.save
      flash[:notice] = "Formation mise à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_formation_path(@formation) : admin_formations_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la formation"
      render :edit
    end
  end

  def edit_configuration
  end

  def update_configuration
    if @formation.update(formation_params)
      flash[:notice] = "Formation mise à jour avec succès"
      redirect_to params[:continue].present? ? edit_configuration_admin_formation_path(@formation) : admin_formations_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la formation"
      render :edit_configuration
    end
  end

  def destroy
    begin
      @formation.destroy!
      flash[:notice] = "La formation a été supprimée avec succès"
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Vous ne pouvez pas supprimer cette formation car elle a des données dépendantes"
    end
    redirect_to action: :index
  end

  private # =====================================================

  def formation_params
    params.require(:formation).permit(:title, :description, :formation_category_id,
      :speaker, :tickets_count, :cost, :address ,:zipcode, :city, :id, :image, :enabled,
      schedules_attributes: [:date, :start_at, :end_at, :id, :_destroy],
      seo_attributes: seo_attributes
    )
  end

  def get_formation
    @formation = Formation.from_param params[:id]
  end
end
