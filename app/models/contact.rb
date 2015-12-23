class Contact < ActiveRecord::Base

  ## Validations
  validates :username, uniqueness: true, length: {:in => 3..16}, allow_blank: true
  validates :username, exclusion: { in: %w(admin superuser guanliyuan administrator root andrew super) }
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/}
  validates_uniqueness_of :email, case_sensitive: false
  validates :phone_number, uniqueness: true, length: { minimum: 11 } #, if: :phone_number?

  ## Scopes
  default_scope { order('Id DESC') }
end
