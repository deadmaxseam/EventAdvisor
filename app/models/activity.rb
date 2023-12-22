class Activity < ApplicationRecord
  belongs_to :event
  validates :name, presence: { message: "Название должно быть заполнено" }
  validates :start_time, presence: { message: "Время начала должно быть заполнено" }
  validates :end_time, presence: { message: "Время окончания должно быть заполнено" }
  validate :end_time_after_start_time
  validate :start_time_on_or_after_event_date

  private

  def end_time_after_start_time
    if start_time && end_time && start_time >= end_time
      errors.add(:end_time, "Время окончания должно быть позже времени начала")
    end
  end

  def start_time_on_or_after_event_date
    if start_time && event && start_time.to_date < event.date
      errors.add(:start_time, "Время начала должно быть в тот же день или позже, чем дата мероприятия")
    end
  end
end
