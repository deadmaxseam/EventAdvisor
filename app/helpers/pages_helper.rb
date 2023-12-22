module PagesHelper
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
end