cd $PROJECTS/rails/hyper_mapper/examples
cd hyper_blog
bundle exec rake db:create_spaces
bundle exec rake db:populate
rails s
