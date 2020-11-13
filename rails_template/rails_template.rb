# template.rb
# frozen_string_literal: true

# writing and reading to files
require 'fileutils'

def add_gems
  gem 'devise'
  gem 'simple_form'
  gem 'pundit'
  gem 'rolify'

  gem_group :development, :test do
    gem 'awesome_print', '~> 1.8'
    gem 'factory_bot_rails', '~> 6.1'
    gem 'pry-rails', '~> 0.3.9'
    gem 'rspec-rails', '~> 4.0.1'
    gem 'rubocop', '~> 1.0'
    gem 'rubocop-rails', '~> 2.8', '>= 2.8.1'
    gem 'rubocop-rspec', '~> 2.0.0.pre'
  end

  gem_group :development do
    gem 'guard'
    gem 'guard-rspec', require: false
    gem 'spring-commands-rspec', '~> 1.0.4'
  end
end

def setup_factory_bot
  FileUtils.mkdir_p('spec/support')
  spec_support = 'spec/support/factory_bot.rb'
  FileUtils.touch(spec_support)
  content = <<~CODE
    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end
  CODE

  append_to_file spec_support do
    content
  end

  inject_into_file 'spec/rails_helper.rb', after: '__dir__)' do
    "\nDir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }\n"
  end
end

def setup_rspec
  generate 'rspec:install'
  run 'bundle exec spring binstub rspec'
end

def setup_simple_form
  generate 'simple_form:install --bootstrap'
end

def setup_pundit
  generate 'pundit:install'
end

def setup_rolify
  generate 'rolify Role User'
end

def setup_users
  generate 'devise:install'
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'test'
  generate :devise, 'User', 'username:string:uniq', 'admin:boolean'
  in_root do
    migration = Dir.glob('db/migrate/*').max_by { |f| File.mtime(f) }
    gsub_file migration, /:admin/, ':admin, default: false'
  end
  rails_command 'db:create'
  rails_command 'db:migrate'
  generate 'devise:views'
end

def find_and_replace_in_file(file_name, old_content, new_content)
  text = File.read(file_name)
  new_contents = text.gsub(old_content, new_content)
  File.open(file_name, 'w') { |file| file.write new_contents }
end

def source_paths
  [__dir__]
end

def add_bootstrap
  run 'yarn add bootstrap jquery popper.js'

  content = <<~CODE
    const webpack = require('webpack')
    environment.plugins.append('Provide',
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default']
      })
    )
  CODE

  inject_into_file 'config/webpack/environment.js', before: 'module.exports = environment' do
    content
  end

  inject_into_file 'app/javascript/packs/application.js', after: '// const imagePath = (name) => images(name, true)' do
    "\nimport 'bootstrap';
    import './stylesheets/application.scss';\n"
  end
  FileUtils.mkdir_p('app/javascript/packs/stylesheets')
  app_scss = 'app/javascript/packs/stylesheets/application.scss'
  FileUtils.touch(app_scss)
  append_to_file app_scss do
    "\n@import '~bootstrap/scss/bootstrap';\n"
  end
end

def add_bootstrap_navbar
  navbar = 'app/views/layouts/_navbar.html.erb'
  FileUtils.touch(navbar)
  inject_into_file 'app/views/layouts/application.html.erb', before: '<%= yield %>' do
    "\n<%= render 'layouts/navbar' %>\n"
  end
  content = <<~CODE
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <%= link_to Rails.application.class.parent_name, root_path, class:"navbar-brand"%>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item active">
            <%= link_to "Home", root_path, class:"nav-link" %>
          </li>
        </ul>
        <ul class="navbar-nav ml-auto">
          <% if current_user %>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <%= current_user.username %>
              </a>
              <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                <%= link_to "Account Settings", edit_user_registration_path, class:"dropdown-item" %>
                <div class="dropdown-divider"></div>
                <%= link_to "Logout", destroy_user_session_path, method: :delete, class:"dropdown-item" %>
              </div>
            </li>
          <% else %>
            <li class="nav-item">
              <%= link_to "Create An Account", new_user_registration_path, class:"nav-link" %>
            </li>
            <li class="nav-item">
              <%= link_to "Login", new_user_session_path, class:"nav-link" %>
            </li>
          <% end %>
        </ul>
      </div>
    </nav>
  CODE

  append_to_file navbar do
    content
  end
end

source_paths

add_gems

run 'bundle install'

def demo_rails_commands
  generate(:controller, 'pages home')
  route "root to: 'pages#home'"
  rails_command 'db:migrate'
end

after_bundle do
  add_bootstrap
  puts 'Stopping Spring'
  run 'spring stop'
  setup_simple_form
  setup_rspec
  setup_factory_bot
  setup_users
  setup_pundit
  setup_rolify
  add_bootstrap_navbar
  demo_rails_commands
end
