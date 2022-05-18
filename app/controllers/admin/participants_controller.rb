class Admin::ParticipantsController < Admin::BaseController
  before_action :get_participant, except: [:index, :new, :create]

  def index
    @participants = Participant
      .apply_filters(params)
      .apply_sorts(params)
      .page(params[:page]).per(20)
    @formation = Formation.find(params[:by_formation]) if params[:by_formation].present?
    respond_to do |format|
      format.html
      format.csv do
        result = CsvExport::Participant.new(@participants).call
        send_data result, filename: "inscriptions_formation_#{ @formation.title.parameterize if @formation.present?}_#{I18n.l(Date.today, format: "%d-%m-%Y")}.csv", type: "text/csv; charset=utf-8; header=present"
      end
    end
  end

  def new
    @participant = Participant.new
  end

  def create
    @participant = Participant.new(participant_params)
    respond_to do |format|
      if @participant.save
        format.html { redirect_to formation_participant_path(@formation, @participant), notice: 'Supscription was successfully created.' }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @participant.update(participant_params)
      flash[:notice] = "Participant mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_participant_path(@participant) : admin_participants_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du participant"
      render :edit
    end
  end

  def confirm_participation
    @participant.participation_confirmed!
    flash[:notice] = "L'inscription a bien été confirmée"
    redirect_back fallback_location: admin_participants_path
  end

  def place_in_waiting_line
    @participant.in_waiting_line!
    flash[:notice] = "Le participant a bien été placé en fil d'attente"
    redirect_back fallback_location: admin_participants_path
  end

  def destroy
    @participant.destroy
    flash[:notice] = "L'inscription a été annulée avec succès"
    redirect_back fallback_location: admin_participants_path
  end

  private

  def get_participant
    @participant = Participant.find params[:id]
  end

  def participant_params
    params.require(:participant).permit(:organization, :firstname, :lastname, :email, :phone, :id, :_destroy)
  end

end