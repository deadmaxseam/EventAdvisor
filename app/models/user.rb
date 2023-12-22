class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable
         validates :email, presence: { message: "Email должен быть заполнен" }, uniqueness: { message: "Пользователь с такой почтой уже существует" }
         validates :password, presence: { message: "Пароль должен быть заполнен" }, confirmation: { message: "Пароль и его подтверждение не совпадают" }
         validates :name, presence: { message: "Имя должно быть заполнено" }
         
         
         has_many :roles
         has_many :events, through: :roles
         has_many :tasks, foreign_key: :responsible_id



         def change_password(user_params)
          current_password = user_params.delete(:current_password)
      
          if self.valid_password?(current_password)
            if self.update(user_params)
              true
            else
              self.valid?
              false
            end     
          else
            self.errors.add(:current_password, current_password.blank? ? :blank : :invalid, message: 'Текущий пароль другой')
            false
          end
         end
end
