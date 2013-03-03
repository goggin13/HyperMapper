cd $PROJECTS/rails/hyper_mapper/examples
ruby create_user_space.rb
cd blog
bundle exec rake db:populate
rails s
