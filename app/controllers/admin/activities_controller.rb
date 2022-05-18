class Admin::ActivitiesController < Admin::BaseController

  include DestroyableUpload

  before_action :get_activity, except: %i[index new create]

  def index
    @activities = Activity.includes(:seo, :themes)
      .apply_filters(params)
      .apply_sorts(params)
      # .page(params[:page]).per(20)
  end

  def new
    @activity = Activity.new
    @activity.build_seo
    @activity.resources.new
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      flash[:notice] = "L'action a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_activity_path(@activity) : admin_activities_path
    else
      @activity.resources.new if @activity.resources.empty?
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'action"
      render :new
    end
  end

  def edit
    @activity.resources.new if @activity.resources.empty?
  end

  def update
    if @activity.update(activity_params)
      flash[:notice] = "Action mise à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_activity_path(@activity) : admin_activities_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'action"
      render :edit
    end
  end

  def edit_configuration
  end

  def update_configuration
    if @activity.update(activity_params)
      flash[:notice] = "Action mise à jour avec succès"
      redirect_to params[:continue].present? ? edit_configuration_admin_activity_path(@activity) : admin_activities_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'action"
      render :edit_configuration
    end
  end

  def destroy
    begin
      @activity.destroy!
      flash[:notice] = "L'action a été supprimée avec succès"
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Vous ne pouvez pas supprimer cette action car elle a des données dépendantes"
    end
    redirect_to admin_activities_path
  end

  private # =====================================================

  def activity_params
    params.require(:activity).permit(
      :title, :description, :short_description, :image, :enabled, :highlighted, :home_title,
      theme_ids: [], profile_ids: [], seo_attributes: seo_attributes,
      resources_attributes: resources_attributes
    )
  end

  def get_activity
    @activity = Activity.from_param params[:id]
  end

end
