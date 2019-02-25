#== See https://qiita.com/Kta-M/items/254a1ba141827a989cb7
gsub_file 'Gemfile', /^gem 'sqlite3'$/, "gem 'sqlite3', '~> 1.3.6'"

#== Popular gems
if yes?("Enable Tagging?")
  gem 'acts-as-taggable-on'
end
gem 'activerecord-session_store'
if yes?("Enable Multi Tenant?")
  gem 'apartment'
end
if yes?("Enable AWS?")
  gem 'aws-sdk', '~> 3'
  gem 'aws-sdk-s3'
end
if yes?("Enable Azure?")
  gem 'azure'
  gem 'azure-storage'
end
gem 'will_paginate-bootstrap4'
gem 'counter_culture'
gem 'devise'
gem 'devise-bootstrap-views'
gem 'devise-i18n'
gem 'devise-i18n-views'
if yes?("Enable SQLServer?")
  gem 'activerecord-sqlserver-adapter', git: 'https://github.com/matthewdunbar/activerecord-sqlserver-adapter.git'
end
gem 'meta-tags'
if yes?("Enable mysql?")
  gem 'mysql2', '~> 0.5'
end
if yes?("Enable omniauith?")
  gem 'omniauth'
  gem 'omniauth-facebook'
  gem 'omniauth-twitter'
end
gem 'ransack'
gem 'sitemap_generator'
gem 'unicorn'
gem 'will_paginate'

gem_group :development, :test do
  gem 'byebug'
  gem 'debase'
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rails-flog', require: 'flog'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'ruby-debug-ide'
  gem 'shoulda-matchers', require: false
  gem 'simplecov'
end

gem_group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'guard'
  gem 'guard-rubocop'
  gem 'hirb'
  gem 'i18n_generators'
  gem 'meta_request'
  gem 'rack-dev-mark'
  gem 'rails_best_practices'
  gem 'rails-erd'
  gem 'reek'
  gem 'rubocop', '~> 0.63'
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'view_source_map'
  gem 'web-console'
end

gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'webmock'
end

gem_group :doc do
  gem 'sdoc', require: false
end

#-- config/applicattion.rb
application  do
  %q{
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja

    config.generators do |g|
      g.orm :active_record
      g.template_engine :erb
      g.test_framework  :rspec, :fixture => true
      g.fixture_replacement :factory_bot, :dir => "spec/factories"
      g.view_specs false
      g.controller_specs true
      g.routing_specs false
      g.helper_specs false
      g.request_specs false
      g.assets false
      g.helper false
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  }
end

run "bundle"

run "yarn add feather-icons"
run "yarn add jquery"
run "yarn add bootstrap@4"

gsub_file 'app/assets/javascripts/application.js', /\/\/= require_tree \./, "//= require jquery/dist/jquery.js\n//= require feather-icons/dist/feather.js\n//= require_tree ."
gsub_file 'app/assets/stylesheets/application.css', /\*= require_tree \./, "*= require bootstrap/dist/css/bootstrap.min\n *= require_tree ."

#--- Scaffold
file 'lib/templates/erb/scaffold/_form.html.erb.tt', File.open(__dir__ + "/lib/templates/erb/scaffold/_form.html.erb.tt").read

#--- Scaffold
file 'lib/templates/erb/scaffold/edit.html.erb.tt', File.open(__dir__ + "/lib/templates/erb/scaffold/edit.html.erb.tt").read

#--- Scaffold
file 'lib/templates/erb/scaffold/index.html.erb.tt', File.open(__dir__ + "/lib/templates/erb/scaffold/index.html.erb.tt").read

#--- Scaffold
file 'lib/templates/erb/scaffold/new.html.erb.tt', File.open(__dir__ + "/lib/templates/erb/scaffold/new.html.erb.tt").read

#--- Scaffold
file 'lib/templates/erb/scaffold/show.html.erb.tt', File.open(__dir__ + "/lib/templates/erb/scaffold/show.html.erb.tt").read

#--- Scaffold
file 'lib/templates/rails/scaffold_controller/controller.rb.tt', File.open(__dir__ + "/lib/templates/rails/scaffold_controller/controller.rb.tt").read

#--- Scaffold
file 'app/controllers/application_controller.rb', File.open(__dir__ + "/app/controllers/application_controller.rb").read

remove_file 'app/views/layouts/application.html.erb'
if yes?('Dashboard Layout?')
  file 'app/views/layouts/application.html.erb', File.open(__dir__ + "/app/views/layouts/application_dashboard.html.erb").read
  file 'app/assets/stylesheets/dashboard.css', File.open(__dir__ + "/app/assets/stylesheets/dashboard.css").read
else
  file 'app/views/layouts/application.html.erb', File.open(__dir__ + "/app/views/layouts/application.html.erb").read
end

if yes?('Generate Demo?')
  generate(:scaffold, "person", "name:string", "address:text", "age:integer")
  rails_command "db:migrate"
end
