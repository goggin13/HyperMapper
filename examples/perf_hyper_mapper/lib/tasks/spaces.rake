namespace :db do
  desc "Create spaces"
  task create_spaces: :environment do
    system User.destroy_space
    system User.create_space
  end
end