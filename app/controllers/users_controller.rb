#coding: utf-8
class UsersController < ApplicationController
  load_and_authorize_resource
  layout "admin"
  def index
    if params[:approved] == "false"
      @users = User.find_all_by_approved(false)
      @edit_name = "审批"
    else
      @users = User.all
      @edit_name = "修改"
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find(params[:id])
    @login_logs = @user.login_logs.paginate(
      :page => params[:page], :per_page =>10)
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: '新账号添加成功.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    #In your `UsersController`, you will also need to remove the password key
    #of the params hash if it’s blank. If not, Devise will fail to validate.
    # Add something like this to your update method:
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_url, notice: '用户资料修改成功.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  #  签到
  def sign
    @login_log = LoginLog.new(:user_id => current_user.id,:ip=>current_user.current_sign_in_ip)
    
    respond_to do |format|
      if @login_log.save
        format.html { redirect_to posts_url, notice: '签到成功.' }
        format.json { render json: @login_log, status: :created, location: @login_log }
      else
        format.html { redirect_to posts_url, notice: @login_log.errors }
        format.json { render json: @login_log.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
end
