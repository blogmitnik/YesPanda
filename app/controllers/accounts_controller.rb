class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def checkpass
  	if current_user && current_user.valid_password?(params[:password])
  	  current_user.destroy
  	  Devise.sign_out_all_scopes ? sign_out : sign_out(current_user)

  	  respond_to do |format|
  	    format.js { head :ok }
  	  end
  	end
  end
end
