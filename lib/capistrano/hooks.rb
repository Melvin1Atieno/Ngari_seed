
before "puma:nginx_config", 'check:ssl'

before 'puma:config', 'puma:check_cpu_cores'
before 'puma:config', 'figaro:setup'
before 'deploy:updated', 'puma:config'
before 'deploy:starting', 'check:revision'
before 'deploy:starting', 'check:first_deploy'
after 'deploy:publishing', 'deploy:restart'
after "deploy:publishing", "sidekiq:restart"  
# after 'deploy:migrate', 'deploy:seed'
after "figaro:setup", "figaro:symlink"
after "deploy:symlink:release", "figaro:setup"

# cap [ENV] deploy:assets_compile
after 'deploy:assets_compile', 'deploy:restart'
after 'deploy:assets_compile', 'sidekiq:restart'

after 'puma:start', 'puma:showapplink'
after 'puma:restart', 'puma:showapplink'
after 'puma:phased-restart', 'puma:showapplink'

task :provision => "provision:install"
task :setup => "setup:install"


