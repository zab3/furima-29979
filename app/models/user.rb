class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :password, format: {with:/\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,}\z/i,message:"Include both letters and numbers."}      

  with_options presence: true do
    validates :nickname
    validates :birth_day
    validates :name_first, format: {with:/\A[ぁ-んァ-ン一-龥]/,message: "Full-width characters."}
    validates :name_last, format: {with:/\A[ぁ-んァ-ン一-龥]/,message: "Full-width characters."}
    validates :name_first_kana, format: {with:/\A[ァ-ヶー－]+\z/,message: "Full-width katakana characters."}
    validates :name_last_kana, format: {with:/\A[ァ-ヶー－]+\z/,message: "Full-width katakana characters."}
    
  end
end

  
  