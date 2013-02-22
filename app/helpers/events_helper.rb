#coding: utf-8
module EventsHelper

  def event_cate_list
    return Event::CATE_LIST
  end

  def format_event_cate(cate)
    (Event::CATE_LIST.find{|s| s[1] == cate})[0]
  end
end
