#
# Cookbook Name:: split_mongodb_json
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

cookbook_file "/etc/yum.repos.d/mongodb-org-3.2.repo" do
  source "mongodb-org-3.2.repo"
end

package "mongodb-org-tools" do
  action :install
end

time =  Time.new.strftime("%Y_%m_%d")

directory "/tmp/mongodb_#{node['split_mongodb_json']['application']}_#{time}" do
  action :create
end

SIZE = #{node['split_mongodb_json']['max_size_in_mb']}

bash "export_MongoDB_JSON" do
user "root"
code <<-EOH 

application="#{node['split_mongodb_json']['application']}"

/usr/bin/mongoexport --host #{node['split_mongodb_json']['ip_address']} --port #{node['split_mongodb_json']['port']} -d #{node['split_mongodb_json']['database']} -c #{node['split_mongodb_json']['collection']} -u #{node['split_mongodb_json']['username']} -p #{node['split_mongodb_json']['password']} -o "/tmp/mongodb_#{node['split_mongodb_json']['application']}_#{time}/mongo_#{node['split_mongodb_json']['application']}.json"

JSON_FILE="/tmp/mongodb_#{node['split_mongodb_json']['application']}_#{time}/mongo_#{node['split_mongodb_json']['application']}.json"
JSON_FOLDER="/tmp/mongodb_#{node['split_mongodb_json']['application']}_#{time}"
SIZE="#{node['split_mongodb_json']['max_size_in_mb']}"

find $JSON_FOLDER -type f -name $JSON_FILE  -size "+${SIZE}M" > /dev/null
if [[ "$?" -eq "0" ]]; then

FIRST_CHUNK="$JSON_FOLDER/FIRST_FILE"
dd if=$JSON_FILE count=${SIZE} bs=1M > $FIRST_CHUNK

SPLIT_LINES=$(cat $FIRST_CHUNK|wc -l)

cd $JSON_FOLDER
/usr/bin/split  -d -l ${SPLIT_LINES} ${JSON_FILE} ${application}
rm -rf $FIRST_CHUNK
ls ${application}* | xargs -i mv {} {}.json

else
echo "$FOLDER/$JSON_FILE is not bigger than $SIZE"
du -sh "$FOLDER/$JSON_FILE"
fi


EOH

end
