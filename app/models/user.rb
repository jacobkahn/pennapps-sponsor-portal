class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  before_save :downcase_email
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  # Non-user-infrastructure-related fields: sponsor data
  TIER_OPTIONS = %w(Title Tera Giga Mega Kilo Custom)
  validates :tier, inclusion: { in: TIER_OPTIONS }

  PLACEHOLDER_IMAGE = 'data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=='
  has_attached_file :logo, default_url: PLACEHOLDER_IMAGE
  do_not_validate_attachment_file_type :logo
  # validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  validate :payment_received
  validate :invoice_link

  validate :primary_contact_name
  validate :primary_contact_email

  def tier_enum
    [['Kilo'], ['Mega'], ['Giga'], ['Tera'], ['Title'], ['Custom']]
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Provided for Rails Admin to allow the password to be reset
  def put_password
    nil
  end

  def put_password=(value)
    return nil if value.blank?
    self.password = value
    self.password_confirmation = value
  end

  private

  def valid_user
    redirect_to root_url unless @user && @user.activated? &&
                                @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_url
  end

  def downcase_email
    self.email = email.downcase
  end

  def default_logo_valid
    self.logo_valid = false
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
