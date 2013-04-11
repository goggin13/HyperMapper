
system "/home/goggin/projects/install/bin/hyperdex rm-space users"
system "/home/goggin/projects/install/bin/hyperdex rm-space posts"
system "/home/goggin/projects/install/bin/hyperdex rm-space tags"
system "/home/goggin/projects/install/bin/hyperdex rm-space post_tags"

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space users 
key id 
attributes 
  username,
  bio,
  salt,
  hashed_password,
  session_id, 
  int created_at,
  int updated_at
subspace username, bio, salt, hashed_password, session_id, created_at, updated_at
tolerate 2 failures
EOF
BASH

system create

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space posts 
key id 
attributes 
  title,
  content,
  user_id,
  int created_at,
  int updated_at,
  map(string, string) comments
subspace title, content
tolerate 2 failures
EOF
BASH

system create

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space tags 
key id 
attributes name
subspace name
tolerate 2 failures
EOF
BASH

system create

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space post_tags 
key id 
attributes 
  post_id,
  tag_id
subspace post_id, tag_id
tolerate 2 failures
EOF
BASH

system create


