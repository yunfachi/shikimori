# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'draper/test/rspec_integration'
require 'factory_girl_rails'
require 'factory_girl-seeds'
require 'rails-controller-testing'
require 'paperclip/matchers'
require 'shoulda/matchers'
require 'sidekiq/testing'
require 'cancan/matchers'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Sidekiq::Testing.fake!

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.allow_http_connections_when_no_cassette = false
  c.default_cassette_options = {
    match_requests_on: [:method, :uri, :query, :body],
    record: (ENV['CIRCLE_CI'] ? :none : :new_episodes)
  }
  c.configure_rspec_metadata!
end
Capybara.ignore_hidden_elements = false

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

if ENV['APIPIE_RECORD']
  RSpec.configure do |config|
    config.before(:each) { Timecop.freeze '2017-01-10 15:00:00' }
    config.after(:each) { Timecop.return }
  end
else
  Apipie.record(nil)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.render_views

  #config.infer_base_class_for_anonymous_controllers = false

  # config.include self, type: :serializer, file_path: %r(spec/validators)

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include JsonResponse, type: :controller
  config.include ControllerResource, type: :controller
  config.include ActionView::TestCase::Behavior, type: :decorator
  config.include Paperclip::Shoulda::Matchers
  config.include Shoulda::Matchers::ActiveModel, type: :validator
  config.include FeatureHelpers, type: :feature
  config.include StateMachineRspec::Matchers, type: :model

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do
    if respond_to?(:controller) && controller
      allow(controller).to receive(:default_url_options)
        .and_return ApplicationController.default_url_options
    end

    Forum.instance_variable_set '@cached', nil

    #RSpec::Mocks.with_temporary_scope do
    allow_any_instance_of(FayePublisher).to receive :run_event_machine
    allow_any_instance_of(FayePublisher).to receive :publish_data
      #allow_any_instance_of(Faye::Client).to receive :publish
    #end
  end

  config.after :each do
    Repos::AnimeGenres.instance.reset
    Repos::MangaGenres.instance.reset
    Repos::Studios.instance.reset
    Repos::Publishers.instance.reset

    if respond_to?(:controller) && controller
      # в каких-то случаях params почему-то не очищается
      # словил падение view object спеки от того, что в params лежали данные от
      # предыдущего контроллера
      controller.params.delete_if { true }
    end
  end

  Rails.application.routes.default_url_options = ApplicationController.default_url_options

  Paperclip::Attachment.default_options[:path] =
    "#{Rails.root}/spec/test_files/:class/:id_partition/:style.:extension"

  config.after :suite do
    FileUtils.rm_rf Dir["#{Rails.root}/spec/test_files/"]
  end

  config.before :suite do
    FactoryGirl::SeedGenerator.create :user, id: 500_000, email: 'seed_1@gmail.com'
    FactoryGirl::SeedGenerator.create :cosplay_user, email: 'seed_2@gmail.com'

    FactoryGirl::SeedGenerator.create :reviews_forum
    FactoryGirl::SeedGenerator.create :animanga_forum
    FactoryGirl::SeedGenerator.create :contests_forum
    FactoryGirl::SeedGenerator.create :clubs_forum
    FactoryGirl::SeedGenerator.create :cosplay_forum
    FactoryGirl::SeedGenerator.create :collections_forum
    FactoryGirl::SeedGenerator.create :offtopic_forum

    FactoryGirl::SeedGenerator.create :offtopic_topic
    FactoryGirl::SeedGenerator.create :site_rules_topic
    FactoryGirl::SeedGenerator.create :description_of_genres_topic
    FactoryGirl::SeedGenerator.create :ideas_and_suggestions_topic
    FactoryGirl::SeedGenerator.create :site_problems_topic

    FactoryGirl::SeedGenerator.create :faq_club

    ActiveRecord::Base.connection.reset_pk_sequence! :users
    ActiveRecord::Base.connection.reset_pk_sequence! :forums
    ActiveRecord::Base.connection.reset_pk_sequence! :topics
  end
end
