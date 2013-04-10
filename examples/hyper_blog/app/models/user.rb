class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :bio, :username, :password

  validates :username, presence: true
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
    user = User.find_by_username(username)
    return nil unless user && user.has_password?(plain_text_password)
    user
  end
    
end