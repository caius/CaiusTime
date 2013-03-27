# Generated with 'brightbox' on Sat Jun 26 00:43:34 +0100 2010
load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :user, "caius"
set :application, "caiustime"
set :use_sudo, false

server "nonus.vm.caius.name", :app, :web

# Target directory for the application on the web and app servers.
set(:deploy_to) { File.join("", "home", user, "apps", application) }

# Copy it up by hand
set :repository, "."
set :scm, :none
set :deploy_via, :copy

default_run_options[:pty] = true

after "deploy:create_symlink", "deploy:bundle_install", "deploy:link_cache_dir"

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

  task :bundle_install do
    bundle_gemfile = File.join(latest_release, "Gemfile")
    bundle_dir = File.join(shared_path, "bundle")
    vendor_dir = File.join(latest_release, "vendor")

    install_cmd = %{( bundle install --gemfile #{bundle_gemfile} --path #{bundle_dir} --deployment --without development test && ln -sf #{bundle_dir} #{vendor_dir})}
    run "if [ -e #{bundle_gemfile} ] ; then #{install_cmd} ; else true ; fi"
  end

  task :link_cache_dir do
    run <<-CMD
      mkdir -p #{shared_path}/cache &&
      ln -sf #{shared_path}/cache #{latest_release}/cache
    CMD
  end
end
