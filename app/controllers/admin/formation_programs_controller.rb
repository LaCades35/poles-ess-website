class Admin::FormationProgramsController < Admin::BaseController

  before_action :get_formation_program, only: [:edit, :update, :destroy]

  def index
    @formation_programs = FormationProgram.order(:position)
      # .page(params[:page]).per(20)
  end

  def new
    @formation_program = FormationProgram.new
  end

  def create
    @formation_program = FormationProgram.new(formation_program_params)
    if @formation_program.save
      flash[:notice] = "Le programme a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_formation_program_path(@formation_program) : admin_formation_programs_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du programme"
      render :new
    end
  end

  def edit
  end

  def update
    if @formation_program.update(formation_program_params)
      flash[:notice] = "Programme mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_formation_program_path(@formation_program) : admin_formation_programs_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du programme"
      render :edit
    end
  end

  def destroy
    begin
      @formation_program.destroy!
      flash[:notice] = "Le programme a été supprimé avec succès"
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Vous ne pouvez pas supprimer ce programme car elle a des données dépendantes"
    end
    redirect_to action: :index
  end

  private # =====================================================

  def formation_program_params
    params.require(:formation_program).permit(:title, :position, :enabled, :document)
  end

  def get_formation_program
    @formation_program = FormationProgram.find params[:id]
  end

end
