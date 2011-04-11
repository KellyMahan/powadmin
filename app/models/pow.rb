class Pow
  
  POW_PATH = "#{ENV["HOME"]}/.pow"
  
  def self.symlinks
    Dir.entries("#{POW_PATH}").select do |d|
      File.symlink?("#{POW_PATH}/#{d}") ? d : nil
    end
  end
  
  def self.config_files
    Dir.entries("#{POW_PATH}").select do |d|
      d.match(/\.conf$/)
    end
  end
  
  def self.restart_site(app_path)
    if Pow.symlinks.include?(app_path)
      FileUtils.touch "#{ENV["HOME"]}/.pow/#{app_path}/tmp/restart.txt"
    end
  end
  
  def self.stop_site(app_path)
    if Pow.symlinks.include?(app_path)
      symlink_path = File.readlink("#{POW_PATH}/#{app_path}")
      File.open("#{POW_PATH}/#{app_path}.conf", 'w') do |f|
        f.puts "#{symlink_path}"
      end
      File.delete("#{POW_PATH}/#{app_path}")
    end
    Pow.restart
  end
  
  def self.start_site(app_path)
    if Pow.config_files.include?("#{app_path}")
      app_path.gsub!(/\.conf$/,'')
      symlink_path = File.read("#{POW_PATH}/#{app_path}.conf").strip
      puts "ln -s #{symlink_path} #{POW_PATH}/#{app_path}"
      File.symlink(symlink_path, "#{POW_PATH}/#{app_path}")
      File.delete("#{POW_PATH}/#{app_path}.conf")
    end
    Pow.restart
  end
  
  def self.restart
    pslist_string = `ps -eaf | grep -e 'P[o]w.*command.js'`
    pid = pslist_string.strip.split(" ")[1]
    system("kill #{pid}")
  end
  
end