name "mongodbrole_symphony"
description "An example Chef role Symphony"
run_list "recipe[split_mongodb_json]"
override_attributes({
   "split_mongodb_json" => {
    "application"  => "symphony",
    "ip_address"   => "13.71.151.57",
    "database"     => "journaldev",
    "collection"   => "dataset",
    "username"     => "qaadmin",
    "password"     => "password",
    "max_size_in_mb"     => "4"
   }

})
