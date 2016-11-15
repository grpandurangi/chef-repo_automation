name "mongodbrole_symphony"
description "An example Chef role Symphony"
run_list "recipe[split_mongodb_json]"
override_attributes({
})
