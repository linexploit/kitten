# app/controllers/profile_pictures_controller.rb
class ProfilePicturesController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    if @user.update(profile_picture_params)
      redirect_to @user, notice: 'La photo de profil a été mise à jour avec succès.'
    else
      redirect_to @user, alert: 'Erreur lors de la mise à jour de la photo de profil.'
    end
  end

  private

  def profile_picture_params
    params.require(:user).permit(:profile_picture)
  end
end
