require 'hyperclient'

h = HyperClient.new '127.0.0.1', 1982

create = <<-BASH
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
BASH

h.rm_space "users"
h.add_space create

puts "created users space"

h.put "users", "42044a69b0364e730e931718f9bd4511", [
	["username", "goggin13"], 
	["bio", "test bio"],
	["updated_at", 1365627069], 
	["salt", "a19bd389dd9cc2cc6a9835f8f34cf806e2b7bc5abc77e0782cdbe0e762fa7348"], 
	["hashed_password", "f6fe9410cea13eae6fcfe0ac336ab798c72c6c62d374df993c424b9cdf747422"], 
	["created_at", 1365627069]
]

h.put "users", "687eba9f6fae10d89367707ed3aa13a1", [
	["username", "goggin13"], 
	["updated_at", 1365627624], 
	["salt", "d35800cc8a64fe20c573a81bb6766d5a2d4256b6fbb66c3a4bd16e5978205dd8"], 
	["hashed_password", "2899d44f262a7810adb292290b7c1386d37416189b766574546bfa5d0f5bde2b"], 
	["created_at", 1365627624]
]


h.put "users", "e939a93ef8f1988fd26599c3ed736a69", [
	["username", "lyda"], 
	["bio", "Aut quis ab quia. Rerum nobis est sint. Aut perspiciatis impedit corporis velit natus. Culpa hic velit."], 
	["updated_at", 1365627624], 
	["salt", "123a4fe8b7cbd826506e0a42c3ee19f20a495fc8ff72b3d67806765e77faac00"], 
	["hashed_password", "bc95967b18cfc9995eceb983e5459fe22f74cbfc4cdb5f66aa2efd49f2b3f68d"], 
	["created_at", 1365627624]
]