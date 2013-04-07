#coding: utf-8
module ApplicationHelper
  STATUS_LIST = [["可见",1],["屏蔽",0]]
  
  def status_list
    return STATUS_LIST
  end

  def parent_cate_list(category_id)
    return_array = ""
    Category.where("parent_id is null").each do |c|
      return_array += "<option value='#{c.id}'"
      return_array += " selected='selected' " if category_id == c.id
      return_array += ">#{c.name}</option>"
    end

    return return_array.html_safe
  end

  def sub_cate_list(category_id)
    return_array = "<option value=0>--</option>"
    Category.where("parent_id is not null").each do |c|
      return_array += "<option value=#{c.id} class='#{c.parent_id}'"
      return_array += " selected='selected' " if category_id == c.id
      return_array += ">#{c.name}</option>"
    end

    return return_array.html_safe
  end

  def cate_list(category_id)
    return_array = "<option value=0>--</option>"
    Category.all.each do |c|
      return_array += "<option value=#{c.id} class='#{c.parent_id}'"
      return_array += " selected='selected' " if category_id == c.id
      return_array += ">#{c.name}</option>"
    end

    return return_array.html_safe
  end

  def format_status(rule_type)
    (STATUS_LIST .find{|s| s[1] == rule_type})[0]
  end
  
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def org_list
    return Post::ORG_LIST
  end
  def subject_list
    return Post::SUBJECT_LIST
  end

  def grade_list
    return Post::GRADE_LIST
  end

  def permit_list
    return Post::PERMIT_LIST
  end

  def format_org(org_id)
    result = (Post::ORG_LIST.find{|s| s[1] == org_id})
    result ? result[0] : "无"
  end

  def format_boolean(status)
    result = (Post::BOOLEAN_LIST.find{|s| s[1] == status})
    result ? result[0] : "无"
  end
  
  def hot_posts
    return Post.find(:all,:limit=>5,:order=>"hit desc")
  end

  def get_posts(category_id = nil)
    return Post.find_by_category_id(category_id,:limit=>5)
  end
  
  def islock(post)
    if post.status != 1 && !current_user
      return true
    elsif post.status == 3 && !current_user.can_read(post)
      return true
    else
      return false
    end
  end
end
