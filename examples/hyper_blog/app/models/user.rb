require 'hyper_mapper'

class User
  include HyperMapper::Document
  
  attr_accessor :password
  attr_accessible :username, :bio, :password

  autogenerate_id
  attribute :username
  attribute :bio  
  attribute :salt
  attribute :hashed_password
  attribute :session_id
  timestamps

  validates :username, presence: true,
                       format: /[a-zA-Z\s]+/
  validates :password, presence: true, if: "hashed_password.blank?"
  
  has_many :posts
  
  before_save :encrypt_password, if: "!password.nil?"
  
  def encrypt_password
    self.salt ||= Digest::SHA256.hexdigest("#{Time.now.to_s}-#{username}")
    self.hashed_password = encrypt(password)
  end

  def encrypt(raw_password)
    Digest::SHA256.hexdigest("-#{salt}-#{raw_password}")
  end
  
  def has_password?(raw_password)
    hashed_password == encrypt(raw_password)
  end

  def self.authenticate(username, plain_text_password)
    user = User.where(username: username)[0]
    return nil unless user && user.has_password?(plain_text_password)
    user
  end
    
  def avatar(size=150)
    "http://robohash.org/#{username}.png?size=#{size}x#{size}"
  end
end
