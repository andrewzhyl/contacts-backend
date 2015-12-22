class User < ActiveRecord::Base

  ## Associations
  # belongs_to :role

  ## Mixin
  include UserBase

  ## Scopes
  ## Callbacks
  before_save :gen_username

  #### Methods

  # ROLES = {
  #   REGULAR: 1,
  #   ADMIN: 2,
  #   MANAGER: 3
  # }

  # def is_regular
  #   self.id_role == ROLES[:REGULAR]
  # end

  # def is_admin
  #   self.id_role == ROLES[:ADMIN]
  # end

  # def is_manager
  #   self.id_role == ROLES[:MANAGER]
  # end

  private
  def gen_username
    if self.username.blank? && self.email.present?
      name = email.gsub(/\.|@\w+\.\w+/,'')
      rec_class = self.class
      if rec_class.exists?( username: name )
        self.username = "#{name}-#{rec_class.count}"
      else
        self.username = name
      end
    end
  end
end
