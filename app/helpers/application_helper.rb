module ApplicationHelper
  
  def nl2br(str)
    str = h(str)
    str = str.gsub(/\r\n|\r|\n/, "<br />")
    raw str
  end

end
