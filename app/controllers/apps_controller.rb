class AppsController < ApplicationController
  
  def index
    @directories = Dir.entries("#{ENV["HOME"]}/.pow").reject{|d| d == "." || d==".."}
  end
  
  def restart
    app = params[:app]
    Pow.restart_site(app)
    flash[:notice] = "A restart has been issued."
    redirect_to :action => :index
  end
  
  def restart_all
    app = params[:app]
    child_pid = Thread.new do
      sleep 2
      Pow.restart
    end
    flash[:notice] = "A restart has been issued."
    redirect_to :action => :index
  end

  def stop
    app = params[:app]
    child_pid = Thread.new do
      sleep 2
      Pow.stop_site(app)
    end
    flash[:notice] = "Pow will be restarting in 2 seconds. Your browser will auto refresh to list the status."
    redirect_to :action => :index
  end
  
  def start
    app = params[:app]
    child_pid = Thread.new do
      sleep 2
      Pow.start_site(app)
    end
    flash[:notice] = "Pow will be restarting in 2 seconds. Your browser will auto refresh to list the status."
    redirect_to :action => :index
  end
  
end
