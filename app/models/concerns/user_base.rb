module UserBase
  extend ActiveSupport::Concern

  included do
    ## Mixin
    # include Shared::Common
    # include Redis::Objects
    include ActiveModel::ForbiddenAttributesProtection
    include ActiveModel::SecurePassword
    extend Enumerize
    # include Ransackable
    # include Optionsable
    # include Trashable

    belongs_to :op, class_name: 'User', foreign_key: 'op_id'

    ## Validations
    validates :username, uniqueness: { case_sensitive: false }, format: { with: /\A(?!_|-)([a-zA-Z0-9]|[\-_](?!_|-|$)){3,16}\z/, message: I18n.t('errors.messages.space_name') }, length: {:in => 3..16}, allow_blank: true
    validates :username, exclusion: { in: %w(admin superuser guanliyuan administrator root andrew super) }
    validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/}
    validates_uniqueness_of :email, case_sensitive: false#, conditions: -> { not_trashed }
    validates :password, length: { minimum: 6 }, on: :create
    validates_length_of :password, :minimum => 6, :if => :in_password_reset
    validates :phone_number, length: { minimum: 11 }, if: :phone_number?
    # validates :realname, presence: true, format: { with: /\p{Han}+/u }, length: { :minimum => 2 }
    # validates :agreement, acceptance: true
    # validate_harmonious_of :realname, :note

    ## Others
    has_secure_password
    enumerize :role, in: { user: 0, admin: 1 }, default: :user, predicates: true
    enumerize :status, in: { pending: 0, activated: 1, banned: 2, trashed: 3 }, default: :pending
    # choice_ransack :id, :username, :email, :role, :status, :created_at, :updated_at # ransack 排序
    # add_options_field_methods(%w{email_bk username_bk})
    attr_accessor :agreement, :login, :in_password_reset, :in_regist_info
    alias_attribute :login, :username
    alias_attribute :name, :email

    ## Redis
    # value :tmp_email, expiration: 1.hour

    ## Callbacks
    after_destroy :handle_on_after_destroy
  end

  module ClassMethods

    def find_by_username_or_email(login)
      if login.include?('@')
        User.where(email: login.downcase ).first
      else
        User.where(username: login.downcase).first
      end
    end

    def find_by_remember_token(token)
      user = where(id: token.split('$').first).first
      (user && user.remember_token == token) ? user : nil
    end

    def activate(id)
      if id.is_a?(Array)
        id.map { |one_id| activate(one_id) }
      else
        unscoped.find(id).activate!
      end
    end

    def find_by_confirmation_token(token)
      user_id, email, timestamp = verifier_for('confirmation').verify(token)
      User.find_by(id: user_id, email: email) if timestamp > 1.hour.ago
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      nil
    end

    def find_by_password_reset_token(token)
      user_id, timestamp = verifier_for('password-reset').verify(token)
      User.find_by(id: user_id) if timestamp > 1.hour.ago
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      nil
    end
  end

  def send_rename_mail(mail)
    self.check_email(mail)
    if self.errors.blank?
      self.tmp_email = mail
      UserMailer.rename_mail(self.id).deliver_later if Rails.env == 'production'
    else
      self.tmp_email.delete
    end
  end

  def check_email(mail)
    if /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/ =~ mail
      self.errors.add :email, "email 已经存在" if User.exists?( email: mail)
    else
      self.errors.add :email, "email 不是一个合法的邮件地址"
    end
  end

  def activated?
    self.status.activated?
  end

  def remember_token
    [id, Digest::SHA512.hexdigest(password_digest)].join('$')
  end

  def password_reset_token
    self.class.verifier_for('password-reset').generate([id, Time.now])
  end

  def confirmation_token
    self.class.verifier_for('confirmation').generate([id, email, Time.now])
  end

  def unlock_token
    self.class.verifier_for('unlock').generate([id, email, Time.now])
  end

  # 激活帐号
  def activate!
    raise ReadOnlyRecord if readonly?
    raise '不能重复激活' if self.activated?
    raise '已封禁，不能激活' if self.status.banned?
    self.confirmed_at = Time.now
    self.status = :activated
    self.save!
  end

  def remail!
    raise ReadOnlyRecord if readonly?
    raise '失败，请重新修改' if self.tmp_email.nil?
    self.email = self.tmp_email.value
    self.tmp_email.delete
    self.confirmed_at = Time.now
    self.save!
  end

  private
  def handle_on_after_destroy
    self.email_bk = self.email
    self.username_bk = self.username
    self.email = "trashed_#{self.id}@yeneibao.com"
    self.username = "trashed_#{self.id}"
    self.save
  end

end
