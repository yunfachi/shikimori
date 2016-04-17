class DailyCosplay
  include Sidekiq::Worker

  def perform
    galleries = CosplayGallery.without_topic.to_a

    1.times do
      topic = galleries.sample.generate_topics
      FayePublisher.new(User.first).publish topic, :created, []
    end
  end
end
