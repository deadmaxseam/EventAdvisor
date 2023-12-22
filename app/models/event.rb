class Event < ApplicationRecord
  has_many :users, through: :roles
  has_many :roles, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :name, presence: { message: "Название должно быть заполнено" }
  validates :description, presence: { message: "Описание должно быть заполнено" }
  validates :location, presence: { message: "Место должно быть заполнено" }
  validates :date, presence: { message: "Дата должна быть указана" }
  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, "Мероприятие не может начинаться сегодня или раньше")
    end
  end
end

