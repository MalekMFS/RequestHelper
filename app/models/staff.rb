class Staff < ApplicationRecord
  has_many :places
  belongs_to :refer

  validates :f_name, presence: {message: "نام نمی تواند خالی باشد."}, length: { maximum: 50, message:"نام می تواند حداکثر ۵۰ نویسه باشدs" }
  validates :l_name, presence: {message: "نام نمی تواند خالی باشد."}, length: { maximum: 50, message:"نام می تواند حداکثر ۵۰ نویسه باشدs" }
  has_secure_password validation: false
  validates :password, length: { minimum: 6, message: "رمز عبور باید حداقل ۶ نویسه باشد." }



  #Returns the hash digest of the given string.
	#need for testing
	def User.digest(string)
		#https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
																									BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	#Returns a random token.
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	#use like @current_user.remember
	def remember
		#remember_token is virtual attribute
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	#Forgets a user
	def forget
		update_attribute(:remember_digest, nil)
	end

	#Returns true if  the given token matches the digest
	def authenticated?(remember_token)
		return false if remember_digest.nil? #Prevents error (bug fix)
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

end