name "mongodbrole_harmony"
description "An example Chef role for Harmony"
run_list "recipe[split_mongodb_json]"
override_attributes({
   "split_mongodb_json" => {
    "application"  => "harmony",
    "ip_address"   => "13.78.116.16",
    "database"     => "journaldev",
    "collection"   => "zips",
    "username"     => "devadmin",
    "password"     => "password",
    "max_size_in_mb"     => "2"
   }
})
