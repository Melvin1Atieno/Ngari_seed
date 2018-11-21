
before "puma:nginx_config", 'check:ssl'

before 'puma:config', 'puma:check_cpu_cores'
before 'deploy:updated', 'puma:config'
before 'deploy:starting', 'check:revision'
before 'deploy:starting', 'check:first_deploy'
after 'deploy:publishing', 'deploy:restart'
after "deploy:publishing", "sidekiq:restart"  
# after "deploy:symlink:release", "figaro:setup"
after "figaro:setup", "figaro:symlink"
before "deploy:migrate", "figaro:setup"

# cap [ENV] deploy:assets_compile
after 'deploy:assets_compile', 'deploy:restart'
after 'deploy:assets_compile', 'sidekiq:restart'

after 'puma:start', 'puma:showapplink'
after 'puma:restart', 'puma:showapplink'
after 'puma:phased-restart', 'puma:showapplink'

task :provision => "provision:install"
task :setup => "setup:install"


