#coding: utf-8
class HomeController < ApplicationController
  def index
    @cate1_posts = Post.find(:all,
      :joins => :category,
      :conditions => ["categories.id = ? or categories.parent_id = ? ",1,1],
      :limit => 7
    )
    
    @cate9_posts = Post.find(:all,
      :joins => :category,
      :conditions => ["categories.id = ? or categories.parent_id = ? ",9,9],
      :limit => 7
    )
    #党团工作
    @cate15_posts = Post.find(:all,
      :joins => :category,
      :conditions => ["categories.id = ? or categories.parent_id = ? ",15,15],
      :limit => 7
    )
    #教学教研
    @cate20_posts = Post.find(:all,
      :joins => :category,
      :conditions => ["categories.id = ? or categories.parent_id = ? ",20,20],
      :limit => 7
    )
    #学校文化
    @cate27_posts = Post.find(:all,
      :joins => :category,
      :conditions => ["categories.id = ? or categories.parent_id = ? ",27,27],
      :limit => 7
    )
    #第二课堂
    @cate31_posts = Post.find(:all,
      :joins => :category,
      :conditions => ["categories.id = ? or categories.parent_id = ? ",31,31],
      :limit => 7
    )
  end
  
  def search
    q = "%#{params[:keyword]}%"
    @posts = Post.where("title like ?",q).paginate(:page => params[:page], :per_page =>10)
  end
  
  def posts
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
  
  def register
    @user = User.new
  end
  
  def create_user
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_url, notice: '新账号添加成功,请耐心等待管理员审批。' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "register" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  
  def tips
    flash[:notice] = "新账号添加成功,请耐心等待管理员审批。"
  end
  
end
