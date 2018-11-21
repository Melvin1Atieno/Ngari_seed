namespace :figaro do
  desc "SCP transfer figaro configuration to the shared folder"
  task :setup do
    on roles(:app) do
      upload! "config/master.key", "#{shared_path}/config/master.key", via: :scp
    end
  end

  desc "Symlink master.key to the release path"
  task :symlink do
    on roles(:app) do
      execute "ln -sf #{shared_path}/config/master.key #{release_path}/config/master.key"
    end
  end
end

