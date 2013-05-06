#coding: utf-8
require "open-uri"
class PostsController < ApplicationController
  load_and_authorize_resource
  before_filter :deal_with_parent_id,:only=>[:create,:update]
  layout "admin"
  # GET /posts
  # GET /posts.json
  def index
    @posts_grid = initialize_grid(Post,
      :include => [:category,:user],
      :per_page => 10)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    
    if (@post.status == 2 && !current_user)
      respond_to do |format|
        format.html {redirect_to "/my/users/sign_in", notice: "您没有权限阅读此文章，请先登陆。"}
      end
    elsif (@post.status == 3 && !current_user) 
      respond_to do |format|
        format.html {redirect_to "/my/users/sign_in", notice: "您没有权限阅读此文章，请先登陆。"}
      end
    elsif (@post.status == 3 && !current_user.can_read(@post))
      respond_to do |format|
        format.html {redirect_to "/", notice: "您的用户级别不能阅读此文章。"}
      end
    else
    
      @post.hit +=1
      @post.save
    
      @next_post = Post.where("category_id = ? and id > ?",@post.category_id,@post.id).limit(1).first
      @pre_post = Post.order("id desc").where("category_id = ? and id < ?",@post.category_id,@post.id).limit(1).first
      #面包屑导航的数据
      @posts_breadcrumb_items = [
        {:key => :main, :name => 'Main',:url => '/main',:items => [
            {:key => :sub1, :name => 'Submenu 1', :url => '/sub1'},
            {:key => :sub2, :name => 'Submenu 2', :url => '/sub2'}
          ]}
      ]
      @uploads = Upload.find_all_by_post_id(params[:id])

      respond_to do |format|
        format.html { render :layout=>"application"}# show.html.erb
        format.json { render json: @post }
      end
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @post.random_mark = Post.get_salt

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @post.random_mark  = Post.get_salt unless  @post.random_mark
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        Upload.update_all({:post_id=>@post.id},["random_mark == ?",@post.random_mark])
        format.html { redirect_to posts_url, notice: '文章创建成功.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        Upload.update_all({:post_id=>@post.id},["random_mark == ?",@post.random_mark])
        format.html { redirect_to posts_url, notice: '文章修改成功。' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def approve
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(:approved=>true)
        format.html { redirect_to posts_url, notice: '文章审批成功。' }
        format.json { head :no_content }
      else
        format.html { render action: "approve" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def sta
    @times = [["本周",Time.now.end_of_week - 6.day,Time.now.end_of_week],
      ["本月","#{Time.now.year}-#{Time.now.strftime("%m")}-01","#{Time.now.year}-#{Time.now.strftime("%m")}-31"],
      ["本学年","#{Time.now.year}-01-01","#{Time.now.year}-12-31"]
    ]
  end

  def period
    if params[:post] && !params[:post][:start].blank? && !params[:post][:end].blank? && !params[:condition].blank?
      @start_time = params[:post][:start] + " 00:00:00"
      @end_time = params[:post][:end] + " 23:59:59"
      @times = [[@start_time],[@end_time]]
      
      @result = []
      
      case params[:condition]
      when "org"
        @result << ["科组","统计"]
        Post::ORG_LIST.each do |cur_org|
          count = Post.where(:created_at =>@times[0]..@times[1],:org_id=>cur_org[1]).count()
          @result << [cur_org[0],count]
        end 
      when "grade"
        @result << ["公会小组","统计"]
        Post::GRADE_LIST.each do |cur_grade|
          count = Post.where(:created_at =>@times[0]..@times[1],:grade=>cur_grade[1]).count()
          @result << [cur_grade[0],count]
        end 
      when "account"
        @result << ["账号","统计"]
        User.staff.each do |cur_u|
          count = Post.where(:created_at =>@times[0]..@times[1],:user_id => cur_u.id).count()
          @result << [cur_u.user_name,count]
        end 
      when "author"
        @result << ["作者","统计"]
        Post.select("author,count(id) as 'count'").where(:created_at =>@times[0]..@times[1]).group("author").each do |r|
          @result << [r.author,r.count]
        end 
      end
    end
  end

  def wait_for_be_approved
    @posts = Post.includes([:user,:category]).where(:approved=>false)
  end
  
  def upload_xml
    
  end
  
  def import
    if params[:xml_file]
      uploaded_io = params[:xml_file]
      counter = 0
      img_counter = 0
      doc = Nokogiri::XML(uploaded_io)
      doc.xpath('//item').each do |item|
        @post = Post.new
        @post.title = item.at_xpath('title').text
        @post.created_at =item.at_xpath('wp:post_date').text

        original_content = item.at_xpath('content:encoded').text.gsub(/<!--more-->/, '')
        content = original_content.gsub(/<img[^>]*>/,'')
        content = content.gsub(/\[caption.*caption\]/,"")

        @post.content = content
        @post.approved = 1
        @post.author = item.at_xpath('dc:creator').text
        @post.status = 1
        @post.category_id = params[:category_id]
        @post.user_id = current_user.id
        if @post.save
          counter += 1
          doc_html = Nokogiri::HTML(original_content)
          doc_html.xpath("//img").each do |img|
            img_counter +=1

            extname = File.extname(img['src'])
            basename = File.basename(img['src'], extname)

            file = Tempfile.new([basename, extname])
            file.binmode

            open(URI.parse(URI.encode(img['src'].gsub(
                    'hz.bosskids.org','www.zqhzgx.com').strip))) do |data|
              file.write data.read
            end

            file.rewind

            @upload = @post.uploads.new
            @upload.upload = file
            @upload.save
          end        
        end
      end

      respond_to do |format|
        if counter > 0
          format.html { redirect_to posts_url, notice: "#{counter}篇文章创建成功,新增#{img_counter}图片." }
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "upload_xml" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { render action: "upload_xml" }
      end
    end

  end
  
  def subject
    @posts = Post.approved.where("subject = ?",params[:subject]).paginate(
      :page => params[:page], 
      :per_page =>20)
    
    render :template=>"/home/search",:layout=>"application"
  end
  
  def org
    @posts = Post.approved.where("org_id = ?",params[:org_id]).paginate(
      :page => params[:page], 
      :per_page =>20)
    
    render :template=>"/home/search",:layout=>"application"
  end
  
  def grade
    @posts = Post.approved.where("grade = ?",params[:grade]).paginate(
      :page => params[:page], 
      :per_page =>20)
    
    render :template=>"/home/search",:layout=>"application"
  end
  
  
  protected
  
  def deal_with_parent_id
    params[:post][:category_id] =params[:parent_id] unless params[:post][:category_id]
  end

end
