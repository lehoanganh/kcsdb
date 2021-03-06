# ====================================== #
# @author: lha | me(at)lehoanganh(dot)de #
# ====================================== #

# the recipe is used to install YCSB on each Cassandra's node
# many YCSB clients cooperate with each other via ZooKeeper to generate
# a load together on the SUT (in this case: Cassandra cluster)

# step 1: download the tar ball
execute "curl --location https://s3.amazonaws.com/kcsdb-init/ycsb-unique.tar.gz --output /home/ubuntu/ycsb.tar.gz --silent"

# step 2: create an empty folder for ZooKeeper
execute "mkdir -p #{node[:ycsb][:ycsb_home]}"

# step 3: extract the YCSB tar ball into the folder
execute "tar -xf /home/ubuntu/ycsb.tar.gz --strip-components=1 -C #{node[:ycsb][:ycsb_home]}"

# step 4: update properties file
#
# overwrite the hosts parameter in workload properties file
# first, read the hosts.txt which is passed by KCSDB Server to this node
# second, update hosts parameter in workload properties file
#
# update barrier-size
ruby_block "update_properties_file" do
  block do
    # waiting for the ZooKeeper Servers are ready on all YCSB nodes
    #sleep 10
    
    # read hosts from hosts.txt
    hosts = ""
    File.open("/home/ubuntu/hosts.txt","r").each do |line| 
      hosts = line.to_s.strip
    end
    
    # read barrier_size from barrier_size.txt
    barrier_size = ""
    File.open("/home/ubuntu/barrier_size.txt","r").each do |line|
      barrier_size = line.to_s.strip
    end
    
    # properties file for loading phase
    workload_properties_file_name =  node[:ycsb][:ycsb_home] + "/workloads/workload_unique"
    workload_properties_file = File.read workload_properties_file_name
    workload_properties_file.gsub!(/hosts=.*/, "hosts=#{hosts}")
    workload_properties_file.gsub!(/barrier-size=dummy/, "barrier-size=#{barrier_size}")
    File.open(workload_properties_file_name,'w'){|f| f.write workload_properties_file}
    
    # properties file for transaction phase
    workload_properties_file_name =  node[:ycsb][:ycsb_home] + "/workloads/workload_unique"
    workload_properties_file = File.read workload_properties_file_name
    workload_properties_file.gsub!(/hosts=.*/, "hosts=#{hosts}")
    workload_properties_file.gsub!(/barrier-size=dummy/, "barrier-size=#{barrier_size}")
    File.open(workload_properties_file_name,'w'){|f| f.write workload_properties_file}
  end
  action :create
end

# step 5: loading phase
=begin
ruby_block "loading_phase" do
  block do
    #puts "Sleeping..."
    #sleep Random.rand(10) # sleep in random x seconds
    # 
    # -s: status report on stderr
    # -p timeseries.granularity=2000
    system "sudo #{node[:ycsb][:ycsb_home]}/bin/ycsb load cassandra-10 -P #{node[:ycsb][:ycsb_home]}/workloads/workload_multiple_load -s -p timeseries.granularity=10000"
  end
  action :create
end
=end