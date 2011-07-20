class LecturesController < ApplicationController
  before_filter :require_fedora
  #before_filter :require_login, :except=>[:show, :index, :update]
  before_filter :require_solr, :only=>[:index, :update, :show]
  
  def index
    @course =  Course.new(:pid=>params[:course_id])
    @solr_result = @course.lectures(:response_format => :solr)
    render :action=>"index", :layout=>false
  end
  
  def new
    render :action=>"new", :layout=>false
  end
  
  def show
    @lecture = Lecture.load_instance(params[:id])
    if params[:layout] == "false"
      render :action=>"show_embedded", :layout=>false
    else
      render :action=>"show"
    end
  end
  
  def edit
    @lecture = Lecture.load_instance(params[:id])
    if params[:layout] == "false"
      render :action=>"edit", :layout=>false
    else
      render :action=>"edit"
    end
  end
  
  def update
    @lecture = Lecture.find(params[:id])
    attrs = unescape_keys(params[:lecture])
    logger.debug("attributes submitted: #{attrs.inspect}")
    @lecture.update_indexed_attributes(attrs)
    @lecture.save
    response = attrs.keys.map{|x| escape_keys({x=>attrs[x].values})}
    logger.debug("returning #{response.inspect}")
    respond_to do |want| 
      want.js {
        render :json=> response.pop
      }
    end

  end
  
end
