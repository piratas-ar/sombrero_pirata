set :application, 'sombrero_pirata'
set :repo_url, 'https://github.com/piratas-ar/sombrero_pirata'

set :linked_files, %w(sombrero.sqlite)

set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
