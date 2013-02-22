#coding: utf-8
module HomeHelper
  def generate_slider(posts)
    return_string = ""
    posts.each do |p|
      if p.uploads.length > 0
        first_photo = p.uploads.where("upload_content_type like 'image%'").limit(1)
        if first_photo
          return_string += "<li>"
          return_string += "<a href='posts/#{p.id}' title='#{p.title}'>"
          return_string += "<img src='#{first_photo[0].upload.url(:medium)}' title='#{p.title}' />"
          return_string += "</a></li>"
        end
      end
    end
    return return_string.html_safe
  end
  
end
