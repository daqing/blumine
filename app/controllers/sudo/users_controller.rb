class Sudo::UsersController < SuperuserController
  def index
    @users = User.order('created_at DESC').page(params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to sudo_users_path, :success => success_do(:delete_user) }
        format.js
      else
        format.html { redirect_to sudo_users_path, :notice => failed(:delete_user) }
        format.js { render :text => :error, :status => 500 }
      end
    end
  end
end
