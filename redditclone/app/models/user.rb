class User < ApplicationRecord 
    attr_reader :password 
    validates :username, :password_digest, :session_token, presence: true 
    validates :password, length: {minimum: 6, allow_nil: true}
    before_validation :ensure_session_token

    def password=(password)
        @password = password 
        self.password_digest = BCrypt::Password.create(password)
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64(32)
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64(32)
        self.save
        self.session_token
    end

    def is_password?(password)
        bcrypt_object = BCrypt::Password.new(self.password_digest)
        bcrypt_object.is_password?(password)
    end

    def self.find_by_credentials(username, password)
        @user = User.find_by(username: username)
        if @user && @user.is_password?(password)
            @user 
        else
            nil 
        end 
    end


end 