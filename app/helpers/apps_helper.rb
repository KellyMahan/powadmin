module AppsHelper
  
  def flash_helper

      f_names = [:notice, :warning, :message]
      fl = ''

      for name in f_names
        if flash[name]
          fl = fl + "<div class=\"#{name}\">#{flash[name]}</div>"
        end
      flash[name] = nil;
    end
    return fl
  end
  
end
