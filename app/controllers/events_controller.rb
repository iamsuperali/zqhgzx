#coding: utf-8
class EventsController < ApplicationController
  load_and_authorize_resource
  layout "admin"
  # GET /events
  # GET /events.json
  def index
    
    if params[:event]
      event_queries = {}
      user_queries = {}
      if !params[:event][:start_at].blank? && !params[:event][:end_at].blank?
        start_time = params[:event][:start_at] + " 00:00:00"
        end_time = params[:event][:end_at] + " 23:59:59"
        event_queries.merge!(:created_at=>start_time..end_time)
      end
      user_queries.merge!({:real_name=>params[:event][:real_name]}) if !params[:event][:real_name].blank?
      user_queries.merge!({:subject=>params[:event][:subject]}) if !params[:event][:subject].blank?
      user_queries.merge!({:grade=>params[:event][:grade]}) if !params[:event][:grade].blank?
    
      @events = Event.includes(:user).where(
        :users=>user_queries,
        :events=>event_queries
      ).paginate(
        :page => params[:page],
        :per_page =>20
      )
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.includes(:user).new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_url, notice: '考勤记录创建成功。' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
