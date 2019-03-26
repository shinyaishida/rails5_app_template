#== Ask options
run_options = []
run_options << 'tagging' if yes?("Enable Tagging?")
run_options << 'multi_tenant' if yes?("Enable Multi Tenant?")
run_options << 'aws' if yes?("Enable AWS?")
run_options << 'azure' if yes?("Enable Azure?")
run_options << 'sqlserver' if yes?("Enable SQLServer?")
run_options << 'mysql' if yes?("Enable mysql?")
run_options << 'omniauth' if yes?("Enable omniauith?")
run_options << 'admin-lte' if yes?('AdminLTE?')
run_options << 'dashboard_layout' if yes?('Dashboard Layout?')
run_options << 'devise_authenticate' if yes?("Devise Authentication?")
run_options << 'generate_demo' if yes?('Generate Demo?')
run_options << 'generate_secrets' if yes?('Generate secret.yml?')

#== See https://qiita.com/Kta-M/items/254a1ba141827a989cb7
gsub_file 'Gemfile', /^gem 'sqlite3'$/, "gem 'sqlite3', '~> 1.3.6'"

#== Popular gems
gem 'acts-as-taggable-on' if run_options.include?('tagging')

gem 'activerecord-session_store'

gem 'apartment' if run_options.include?('multi_tenant')

gem 'aws-sdk', '~> 3' if run_options.include?('aws')
gem 'aws-sdk-s3' if run_options.include?('aws')

gem 'azure' if run_options.include?('azure')
gem 'azure-storage' if run_options.include?('azure')

gem 'will_paginate-bootstrap4'
gem 'counter_culture'
gem 'devise'
gem 'devise-bootstrap-views'
gem 'devise-i18n'
gem 'devise-i18n-views'

gem 'activerecord-sqlserver-adapter', git: 'https://github.com/matthewdunbar/activerecord-sqlserver-adapter.git' if run_options.include?('sqlserver')

gem 'meta-tags'

gem 'mysql2', '~> 0.5' if run_options.include?('mysql')

if run_options.include?('omniauth')
  gem 'omniauth'
  gem 'omniauth-facebook'
  gem 'omniauth-twitter'
end

gem 'ransack'
gem 'sitemap_generator'
gem 'unicorn'
gem 'will_paginate'

gem_group :development, :test do
  gem 'active-record-query-trace'
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

if run_options.include?('admin-lte')
  run "yarn add admin-lte@3.0.0-alpha.2"
end

#-- application.js / application.css
if run_options.include?('admin-lte')
  gsub_file 'app/assets/javascripts/application.js', /\/\/= require_tree \./, "//= require jquery/dist/jquery.js\n//= require feather-icons/dist/feather.js\n//= require bootstrap/dist/js/bootstrap.min\n//= require admin-lte/dist/js/adminlte.min\n//= require_tree ."
  gsub_file 'app/assets/stylesheets/application.css', /\*= require_tree \./, "*= require bootstrap/dist/css/bootstrap.min\n*= require admin-lte/dist/css/adminlte.min\n*= require admin-lte/plugins/iCheck/all\n*= require font-awesome/css/font-awesome.min\n*= require_tree ."
else
  gsub_file 'app/assets/javascripts/application.js', /\/\/= require_tree \./, "//= require jquery/dist/jquery.js\n//= require bootstrap/dist/js/bootstrap.min\n//= require feather-icons/dist/feather.js\n//= require_tree ."
  gsub_file 'app/assets/stylesheets/application.css', /\*= require_tree \./, "*= require bootstrap/dist/css/bootstrap.min\n *= require_tree ."
end

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

#-- config/secrets.yml
if run_options.include?('generate_secrets')
  require 'securerandom'
  body = File.open(__dir__ + "/config/secrets.yml").read
  body.gsub!(/REPLACE_HERE/, SecureRandom.alphanumeric(64))
  file 'config/secrets.yml', body
  run 'rm config/master.key'
  run 'rm config/credentials.yml.enc'
  inject_into_file 'config/application.rb', after: "config.i18n.default_locale = :ja\n" do <<-'RUBY'
    config.require_master_key = false
    config.x.secrets = ActiveSupport::InheritableOptions.new(config_for(:secrets))
    config.secret_token = config.x.secrets.secret_key_base
RUBY
  end
end

remove_file 'app/views/layouts/application.html.erb'
if run_options.include?('admin-lte')
  file 'app/views/layouts/application.html.erb', File.open(__dir__ + "/app/views/layouts/application_adminlte.html.erb").read
  file 'app/assets/images/AdminLTELogo.png', File.open(__dir__ + "/app/assets/images/AdminLTELogo.png").read
elsif run_options.include?('dashboard_layout')
  file 'app/views/layouts/application.html.erb', File.open(__dir__ + "/app/views/layouts/application_dashboard.html.erb").read
  file 'app/assets/stylesheets/dashboard.css', File.open(__dir__ + "/app/assets/stylesheets/dashboard.css").read
else
  file 'app/views/layouts/application.html.erb', File.open(__dir__ + "/app/views/layouts/application.html.erb").read
end

if run_options.include?('devise_authenticate')
  # See https://github.com/rails/rails/pull/34980
  #     https://github.com/plataformatec/devise/issues/4992
  generate('devise:install')
  generate('devise', 'User')
  rails_command "db:migrate"
  generate('devise:views:bootstrap_templates')
  append_to_file 'db/seeds.rb',%(
  if User.count.zero?
    user = User.new(
      email: 'admin@example.com',
      password: 'passw0rd',
      password_confirmation: 'passw0rd'
    )
    user.save(validate: false)
  end
)
  rails_command "db:seed"
end

if run_options.include?('generate_demo')
  generate(:scaffold, "person", "name:string", "address:text", "age:integer")
  rails_command "db:migrate"
  if run_options.include?('devise_authenticate')
    gsub_file 'app/controllers/people_controller.rb', /ApplicationController$/, "ApplicationController\n  before_action :authenticate_user!"
  end
end

#--- Enable ActiveRecord Query Trace
file 'config/initializers/active_record_query_trace.rb', File.open(__dir__ + "/config/initializers/active_record_query_trace.rb").read
