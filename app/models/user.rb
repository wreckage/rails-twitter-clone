class User < ApplicationRecord
    has_many :microposts, dependent: :destroy
    # virtual attribute w/ both getter & setter
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    validates :name, presence: true, length: { maximum: 50 }
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i 
    validates :email, presence: true, 
        length: { maximum: 255 }, 
        format: { with: VALID_EMAIL_REGEX },
        uniqueness: { case_sensitive: false }
    has_secure_password

    # Returns the hash digest of the given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token
    def User.new_token
        SecureRandom.urlsafe_base64 # part of Ruby std lib
    end

    # Remembers a user in the database for use in persistent sessions
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if the given token matches the digest
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest") # same as self.send()
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    # Forgets a user
    def forget
        update_attribute(:remember_digest, nil)
    end

    # Activates an account
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    # Sends activation email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token), 
                       reset_sent_at: Time.zone.now)

    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    # Returns true if a password reset has expired
    # Note it's not 'self.reset_sent_at', because for reads Ruby will check
    # local variables, and if finds none matching will go up a level and
    # check there (in this case, goes up to the user instance). See:
    # http://stackoverflow.com/a/20738162
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    # Defines a proto-feed
    def feed
        Micropost.where("user_id = ?", id)
        # microposts
    end

    private
        # Converts email to all lower-case
        def downcase_email
            email.downcase!
        end

        # Creates and assigns the activation token and digest
        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
