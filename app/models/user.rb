#coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  has_many :login_logs,:dependent => :destroy
#  has_many :events,:dependent => :destroy
  has_many :records,:class_name => "Event", :foreign_key => "created_by",:dependent => :destroy
  has_many :authorize,:class_name => "Event", :foreign_key => "approved_by",:dependent => :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email,
    :password,
    :password_confirmation,
    :remember_me,
    :user_name,
    :roles,
    :approved,
    :real_name,
    :id_card,
    :tel,
    :company,
    :grade,
    :org_id,
    :subject
  validates_uniqueness_of   :user_name, :case_sensitive => false
  # attr_accessible :title, :body
  
  #范围教职员
  scope :staff,where("approved == 1 and roles_mask < 64")
  
  scope :administrative,where("approved == 1 and (roles_mask & 7) > 0")

  #权限必须由高到低
  ROLES = %w[超级管理员 校长 主任 级组长 科组长 会员 访客]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end
  
  def can_read(post)
    if self.roles.length > 0
      cur_roles = ROLES[(ROLES.index(self.roles[0]))..7]
      return cur_roles.include?(post.user.roles[0])
    else
      return false
    end
  end
  
  def sign?
    self.login_logs.exists?(['created_at > ?',(DateTime.now).strftime("%Y-%m-%d")])
  end
  
  def is_administrative?
    roles_mask & 7 != 0 && approved == 1
  end
  
  def is_staff?
    roles_mask < 64 && approved == 1
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end
 
end
