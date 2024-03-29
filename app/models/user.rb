require 'Houston'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  attr_accessible :provider, :uid

  attr_accessor :facebook_user

  has_many :devices, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_many :access_grants, :dependent => :destroy, :class_name => "Doorkeeper::AccessGrant", :foreign_key => "resource_owner_id"
  has_many :access_tokens, :dependent => :destroy, :class_name => "Doorkeeper::AccessToken", :foreign_key => "resource_owner_id"

  # validates_presence_of   :email, :if => :email_required?
  # validates_uniqueness_of :email, :allow_blank => true, :if => :email_changed?
  # validates_format_of     :email, :with  => email_regexp, :allow_blank => true, :if => :email_changed?

  # validates_presence_of     :password, :if => :password_required?
  # validates_confirmation_of :password, :if => :password_required?
  # validates_length_of       :password, :within => password_length, :allow_blank => true

  def self.send_notify_ios(text, data = nil)
    certificate = File.read(ENV['APPLE_CERTIFICATE'])
    passphrase = ENV['APN_CERTIFICATE_PASSPHRASE']
    connection = Houston::Connection.new(Houston::APPLE_DEVELOPMENT_GATEWAY_URI, certificate, passphrase)
    connection.open

    #apn = Houston::Client.development
    #apn.certificate = File.read(ENV['APPLE_CERTIFICATE']) # certificate from prerequisites
    Device.where(platform: 'ios').each do |device|
      notification = Houston::Notification.new(device: device.uuid)
      notification.alert = text
      notification.badge = 1
      notification.content_available = true
      notification.mutable_content = true
      #notification.sound = 'sound.aiff'
      #notification.category = 'INVITE_CATEGORY'
      #notification.custom_data = { foo: 'bar', alice: 'bob' }
      notification.custom_data = data unless data.nil?
      connection.write(notification.message)
      connection.close
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
      user = User.create(
        # name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20]
      )
    end

    if user.valid?
      user.facebook_token = auth.credentials.token
      user.facebook_expires_at = Time.at(auth.credentials.expires_at)
      user.save
    end

    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def facebook
    if !@facebook && facebook_token && facebook_expires_at > Time.now
      @facebook = Koala::Facebook::API.new(facebook_token)
    end
    @facebook
  end
end
