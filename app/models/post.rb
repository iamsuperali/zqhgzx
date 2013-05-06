#coding: utf-8
class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  attr_accessible :order,
    :status,
    :category_id,
    :comment_status,
    :content,
    :org_id,
    :title,
    :user_id,
    :attachment,
    :grade,
    :subject,
    :author,
    :approved,
    :random_mark
  has_attached_file :attachment
  before_create :auto_approve_when_admin
  has_many :uploads,:dependent => :destroy
  default_scope order('created_at DESC')
  scope :approved,where("approved = 1")
  
  GRADE_LIST = [["七年级",7],["八年级",8],["九年级",9],["后勤",13]]
  ORG_LIST = [["音乐美术部",1],["体育俱乐部",2],["科普小组",3]]
  SUBJECT_LIST = [["语文",1],["数学",2],["英语",3],["物理",4],["化学",5],["生物",6],["地理",7],["政治",8],["历史",9],["教辅",10],["信息技术",11],["体育",12],["美术",13],["音乐",14]]
  PERMIT_LIST=[["公开",1],["会员可见",2],["同级可见",3]]
  COMMENT_STATUS_LIST = [["允许评论",1],["不允许评论",0]]
  BOOLEAN_LIST = [["否",false],["是",true]]
  
  #  def parent_id
  #    self.category.parent ? self.category.parent_id : self.category.id
  #  end
  #
  #  def parent_id=(value)
  #    self.category_id ||= value
  #  end
  
  def thumb_id
    regex_url = /pictures[\/][\d]+[\/]/  
    string_url = self.content.scan(regex_url).to_s  
    regex_id = /[\d]+/  
    picture_id = string_url.scan(regex_id)[0]
    return picture_id
  end
  
  def self.get_salt
    salt = ""
    8.times { salt << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    salt
  end
  
  
  private
  
  def auto_approve_when_admin
    if self.user
      self.approved = true if self.user.is? :超级管理员
    end
  end
  
end