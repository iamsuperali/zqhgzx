#coding: utf-8
class LoginLog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id,:ip
end