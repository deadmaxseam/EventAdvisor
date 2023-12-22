class PagesController < ApplicationController
  def index
  end

  def destroy_event
    @event = Event.find_by(id: params[:id])
    @event.destroy
    redirect_to show_all_path
  end

  def show_all
    @events = Event.all
  end

  def toogle_activities
    @status = params[:status]
    @event = params[:event]
    @data = Event.find_by(id: @event).date
    @creator = User.joins(roles: :event).find_by(events: { id: @event }, roles: { role_name: 'администратор' })
    @activities = Activity.where(event_id: @event)
    if @status == 'no_show'
      render turbo_stream: turbo_stream.update('activity', partial: 'activities')
    else
      render turbo_stream: turbo_stream.update('activity', "<a href=\"/pages/toogle_activities/no_show/#{@event}\" class=\"form-submit-button\" previewlistener=\"true\">Показать активности</a>")
    end
  end

  def show_activities
    @activities = @event.activities
    @new_activity = Activity.new
  end
  
  def create_activity
    @event = Event.find(params[:event_id])
    @activity = @event.activities.new(activity_params)
    if @activity.save
      redirect_to event_path(@event)
    else
      @errors = @activity.errors.full_messages
      render turbo_stream: turbo_stream.replace('errors', partial: 'error_messages', locals: { errors: @errors })
    end
  end

  def remove_activity
    activity = Activity.find_by(id: params[:id], event_id: params[:event_id])
    activity.destroy
    redirect_to event_path(params[:event_id])
  end


  def password_update
    @user = User.find(params[:id])
    unless @user.change_password(get_change_password_parameters)
      @errors = @user.errors.map(&:message)
      render turbo_stream: turbo_stream.update('errors', partial: 'error_messages')
    else
      redirect_to "/pages/profile/#{@user.id}"
    end
  end

  def add_guest
    Role.create(user_id: params[:user_id], event_id: params[:event_id], role_name: 'гость')
    redirect_to event_path(params[:event_id])
  end  

  def remove_guest
    role = Role.find_by(user_id:params[:user_id], event_id: params[:event_id], role_name: 'гость')
    role.destroy
    redirect_to event_path(params[:event_id])
  end

  def add_organizer
    role = Role.find_by(user_id:params[:user_id], event_id: params[:event_id], role_name: 'гость')
    role.destroy
    Role.create(user_id: params[:user_id], event_id: params[:event_id], role_name: 'организатор')
    redirect_to event_path(params[:event_id])
  end  

  def remove_organizer
    role = Role.find_by(user_id:params[:user_id], event_id: params[:event_id], role_name: 'организатор')
    role.destroy
    Role.create(user_id: params[:user_id], event_id: params[:event_id], role_name: 'гость')
    redirect_to event_path(params[:event_id])
  end



  def show_tasks
    @event = Event.find(params[:event_id])
    @tasks = @event.tasks
    @new_task = Task.new
  end
  
  def create_task
    @event = Event.find(params[:event_id])
    @task = @event.tasks.new(task_params)
    if @task.save
      redirect_to event_path(@event)
    else
      @errors = @task.errors.full_messages
      render turbo_stream: turbo_stream.replace('errors', partial: 'error_messages', locals: { errors: @errors })
    end
  end
  
  def remove_task
    task = Task.find_by(id: params[:id], event_id: params[:event_id])
    task.destroy
    redirect_to event_path(params[:event_id])
  end  

  def toggle_tasks
    @status = params[:status]
    @event = Event.find(params[:event])
    @data = Event.find_by(id: @event).date
    @organizers = User.joins(roles: :event).where(events: { id: @event }, roles: { role_name: 'организатор' })
    @creator = User.joins(roles: :event).find_by(events: { id: @event }, roles: { role_name: 'администратор' })
    @tasks = Task.where(event_id: @event)
    if @status == 'no_show'
      render turbo_stream: turbo_stream.update('task', partial: 'tasks')
    else
      render turbo_stream: turbo_stream.update('task', "<a href=\"/pages/toogle_tasks/no_show/#{@event.id}\" class=\"form-submit-button\" previewlistener=\"true\">Показать задачи</a>")
    end
  end
  

  def toogle_guests
    @status = params[:status]
    @event = Event.find(params[:event])
    @creator = User.joins(roles: :event).find_by(events: { id: @event }, roles: { role_name: 'администратор' })
    @organizers = User.joins(:roles).where(roles: { event_id: @event, role_name: 'организатор' })
    @guests = User.joins(:roles).where(roles: { event_id: @event, role_name: 'гость' })  
    if @status == 'no_show'
      render turbo_stream: turbo_stream.update('guests', partial: 'guests')
    else
      render turbo_stream: turbo_stream.update('guests', "<a href=\"/pages/toogle_guests/no_show/#{@event.id}\" class=\"form-submit-button\" previewlistener=\"true\">Показать гостей</a>")
    end
  end

  def my_tasks
    @my_tasks = current_user.events.joins(:tasks).where("events.date >= ?", Date.today)
  end  

  def edit_profile
    @user = User.find(params[:id])
  end  

  def update
    parameters = get_update_params
    case parameters[:field]
    when 'name'
      @user.update_column(:name, parameters[:name])
      if @user.save
        render partial: 'name_link'
      else
        @errors = @user.errors.full_messages
        render turbo_stream: turbo_stream.replace('errors', partial: 'error_messages', locals: { errors: @errors })
      end
    when 'email'
      @user.update_column(:email, parameters[:email])
      if @user.save
        render partial: 'email_link'
      else
        @errors = @user.errors.full_messages
        render turbo_stream: turbo_stream.replace('errors', partial: 'error_messages', locals: { errors: @errors })
      end
    end
  end
  

  def change
    @user_id = params[:id]
    render partial: 'field'
  end

  def edit_event
    @event = Event.find(params[:id])
  end  

  def change_ev
    @event_id = params[:id]
    render partial: 'field_ev'
  end

  def update_ev
    parameters = get_update_ev_params
    case parameters[:field]
    when 'name'
      @event.update_column(:name, parameters[:name])
      if @event.save
        render partial: 'name_ev_link'
      else
        @errors = @event.errors.map(&:message)
        render turbo_stream: turbo_stream.update('errors', partial: 'error_messages')
      end
    when 'description'
      @event.update_column(:description, parameters[:description])
      if @event.save
        render partial: 'description_ev_link'
      else
        @errors = @event.errors.map(&:message)
        render turbo_stream: turbo_stream.update('errors', partial: 'error_messages')
      end
    when 'date'
      @event.update_column(:date, parameters[:date])
      if @event.save
        render partial: 'date_ev_link'
      else
        @errors = @event.errors.map(&:message)
        render turbo_stream: turbo_stream.update('errors', partial: 'error_messages')
      end
    when 'location'
      @event.update_column(:location, parameters[:location])
      if @event.save
        render partial: 'location_ev_link'
      else
        @errors = @event.errors.map(&:message)
        render turbo_stream: turbo_stream.update('errors', partial: 'error_messages')
      end
    end
  end
  
  
 
  def profile
    @user = User.find(params[:id])
  end

  def show_event
    @event = Event.find(params[:id])
    @current_user = current_user
    @creator = User.joins(roles: :event).find_by(events: { id: @event }, roles: { role_name: 'администратор' })
    @organizers = User.joins(:roles).where(roles: { event_id: @event, role_name: 'организатор' })
    @activities = Activity.where(event_id: @event)
    @ev_status = calculate_status(@event.date)
  end

  def new_event
    @event = Event.new
  end


  def create_event
    @event = Event.new(event_params)
    if @event.save
      @role = Role.new(user_id: current_user.id, event_id: @event.id, role_name: 'администратор')
      @role.save
      redirect_to event_path(@event)
    else
      @errors = @event.errors.map(&:message)
      render turbo_stream: turbo_stream.update('errors', partial: 'error_messages')
    end

  end

  def change_password
    @user_id = params[:id]
  end
  
  def calculate_status(event_date)
    current_time = Time.now
    if event_date < current_time
      return 'Прошло'
    elsif event_date > current_time
      return 'Будет'
    else
      return 'В процессе'
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :date, :location)
  end

  def activity_params
    params.permit(:name, :start_time, :end_time)
  end
  
  def task_params
    params.permit(:name, :description, :status, :responsible_id, :event_id)
  end

  def get_update_ev_params
    @event = Event.find(params[:id])
    params.permit(:field, :name, :description, :date, :location)
  end

  def get_update_params
    @user = User.find(params[:id])
    params.permit(:field, :name, :email)
  end

  def get_change_password_parameters
    params.permit(:current_password, :password, :password_confirmation)
  end


end

