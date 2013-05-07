namespace :db do
  desc "Create spaces"
  task create_spaces: :environment do
    system HyperUser.destroy_space
    system HyperUser.create_space
  end
end