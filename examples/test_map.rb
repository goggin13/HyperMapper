$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib")) 
require '/home/goggin/projects/rails/hyper_mapper/lib/hyper_mapper'

path = "/home/goggin/projects/rails/hyper_mapper/examples/config.yml"
HyperMapper::Config.load_from_file path

create = <<-BASH
 /home/goggin/projects/install/bin/hyperdex add-space <<EOF
 space spaces
 key username
 attributes map(string, string) posts
 subspace posts
 tolerate 2 failures
 EOF
 BASH

system create

