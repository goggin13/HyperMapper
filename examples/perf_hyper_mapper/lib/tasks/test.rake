namespace :test do
  desc "run performance tests"
  task test: :environment do
  end
    
  single_insert = <<BASH
curl --data 'user[username]=%u&user[bio]=hello world" \
  localhost:3000/mongoid/single_insert
BASH

  single_update = <<BASH
curl -X PUT --data "user[username]=goggin13&user[bio]=hello world" \
  localhost:3000/mongoid/51852f3470b44585c2000002/single_update
BASH

  single_query = <<BASH
curl localhost:3000/mongoid/51852f3470b44585c2000002/single_query
BASH

  embedded_insert = <<BASH
curl --data "post[title]=goggin13&post[content]=hello world" \
  localhost:3000/mongoid/5185318470b44585c2000003/embedded_insert
BASH

  embedded_update = <<BASH
curl -X PUT --data "post[title]=goggin&post[content]=hello world2" \
  localhost:3000/mongoid/5185318470b44585c2000003/518532a870b44585c2000004/embedded_update
BASH

  embedded_query = <<BASH
curl localhost:3000/mongoid/5185318470b44585c2000003/518532a870b44585c2000004/embedded_query
BASH

  embedded_destroy = <<BASH
curl -X DELETE \
  localhost:3000/mongoid/5185318470b44585c2000003/518532a870b44585c2000004/embedded_destroy
BASH

  single_destroy = <<BASH
curl -X DELETE localhost:3000/mongoid/51852f3470b44585c2000002/single_destroy
BASH
end