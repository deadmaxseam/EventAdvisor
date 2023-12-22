class Task < ApplicationRecord
  belongs_to :event
  belongs_to :responsible, class_name: "User", optional: true
  validates :name, presence: { message: "Название задачи должно быть заполнено" }, length: { maximum: 100 }
  validates :description, presence: { message: "Описание должно быть заполнено" }, length: { maximum: 300 }
  validates :status, presence: { message: "Статус задачи должен быть указан" }, inclusion: { in: %w(Новая В работе Завершена)}
  validates :event_id, presence: true
  validate :responsible_presence

  private

  def responsible_presence
    errors.add(:responsible, "Должен быть выбран ответственный") unless responsible.present?
  end
end
