#coding: utf-8
class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :recorder, :class_name => "User", :foreign_key => "created_by"
  belongs_to :examiner, :class_name => "User", :foreign_key => "approved_by"
  attr_accessible :approved_by, 
    :cate,
    :created_by,
    :end_at,
    :end_node,
    :remark,
    :start_at,
    :start_node,
    :user_id

  CATE_LIST = [["公假",1],["事假",2],["病假",3],["政策性公休",4],
    ["旷工",5],["旷课",6],["迟到",7],["早退",8],["其他",9]
  ]
end
