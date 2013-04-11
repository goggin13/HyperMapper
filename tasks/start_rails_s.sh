cd $PROJECTS/rails/hyper_mapper/examples
ruby create_user_space.rb
cd hyper_blog
bundle exec rake db:populate
rails s
