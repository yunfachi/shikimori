FactoryGirl.define do
  factory :user_image do
    image { File.new(Rails.root.join('spec', 'images', 'anime.jpg')) }
  end
end
