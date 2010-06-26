# Generated with 'brightbox' on Sat Jun 26 00:43:34 +0100 2010
load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :user, "rails"
set :application, "timezone"

server "titus.vm.caius.name", :app, :web

# Target directory for the application on the web and app servers.
set(:deploy_to) { File.join("", "home", user, "apps", application) }

# Copy it up by hand
set :repository, "."
set :scm, :none
set :deploy_via, :copy

namespace :deploy do
  desc "touch restart.txt to restart the app"
  task :restart do
    run "cd #{current_path} && touch tmp/restart.txt"
  end

  task :migrate do
  end

  task :start do
    restart
  end

  task :finalize_update do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/tmp &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log
    CMD
  end

  task :install_gems do
    ["sinatra", "activesupport", "nokogiri"].each do |gem_name|
      run <<-CMD
        gem spec #{gem_name} --version '>= 0' 2>/dev/null|egrep -q '^name:' ||
        sudo -p 'sudo password: ' gem install --no-user-install --no-ri --no-rdoc --version '>= 0' #{gem_name}
      CMD
    end
  end

  before "deploy", "deploy:install_gems"

end
