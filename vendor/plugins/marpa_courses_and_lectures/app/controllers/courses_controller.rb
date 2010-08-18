class CoursesController < ApplicationController
  # before_filter :require_login, :only =>[:new, :create, :update, :destroy]
  before_filter :require_fedora
  before_filter :require_solr, :only=>[:search, :show, :new, :index, :update, :create]
      
  def index
    parse_search_params
    @solr_result = Course.find_by_solr(:all, @search_params)
  end
  
  def new
  end
  
  def create
    @course = Course.new()
    if params.has_key?(:course)
      attrs = unescape_keys(params[:course])
      logger.debug("attributes submitted: #{attrs.inspect}")
      @course.update_indexed_attributes(attrs)
    end
    @course.datastreams_in_memory["properties"].contributed_by_values = session[:user]
    @course.save
    params[:id] = @course.pid
    params[:action] = "show"
    params[:controller] = "courses"
    @course_solr_result = Course.find_by_solr(params[:id]).hits.first
    
    redirect_to course_path(@course)
  end
  
  def show
    @course = Course.find(params[:id]) #.hits.first
    @course_solr_result = Course.find_by_solr(params[:id]).hits.first
  end
  
  def update
    @course = Course.find(params[:id])
    attrs = unescape_keys(params[:course])
    logger.debug("attributes submitted: #{attrs.inspect}")
    @course.update_indexed_attributes(attrs)
    @course.save
    response = attrs.keys.map{|x| escape_keys({x=>attrs[x].values})}
    logger.debug("returning #{response.inspect}")
    respond_to do |want| 
      want.js {
        render :json=> response.pop
      }
    end

  end
  
  def destroy
    Course.new(:pid => params[:id]).delete
    render :nothing => true
  end
  
  def search
    search_params = {}
    terms = params[:terms]
    if !params[:start].nil?
      search_params[:start] = params[:start].to_i
    end
    if params[:results_per_page].to_i > 0
      search_params[:rows] = params[:results_per_page].to_i
    end
    begin
      @solr_result = Course.solr_search(terms, search_params)
    rescue Net::HTTPServerException=>x
      if x.response.code.to_i == 400
        flash.now[:error]=x.response.message
        render :action=>'new_search' and return
      end
    end
  end
  
end