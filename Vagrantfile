# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
    # How many nodes (VM's) must we create,
    numNodes = 2
    r = numNodes..1
    (r.first).downto(r.last).each do |i|
        config.vm.define "node#{i}" do |node|
            node.vm.box = "ubuntu/focal64" # We are using Ubuntu 20.04 LTS, code named Focal Fossa
            node.vm.provider "virtualbox" do |vb| #VM settings for each node, we are creating a VM with 2 CPU cores and 8 GB of RAM
                vb.name = "node#{i}"
                vb.customize ["modifyvm", :id, "--groups", "/hadoop-cluster"]
                vb.memory = 8192
                vb.cpus = 2
            end
            node.vm.hostname = "node#{i}"
    
            # Place each VM on the same private network so that they can communicate with each other
            if i < 10
                node.vm.network :private_network, ip: "10.211.55.10#{i}" #, virtualbox__intnet: "vhdoop"
            else
                node.vm.network :private_network, ip: "10.211.55.1#{i}" #, virtualbox__intnet: "vhdoop"
            end

            node.vm.provision :shell, :path => "scripts/setup-hosts.sh", :args => "-t #{numNodes}"
            node.vm.provision :shell, :path => "scripts/setup-ssh.sh"
            node.vm.provision :shell, :path => "scripts/setup-java.sh"
            node.vm.provision :shell, :path => "scripts/setup-hadoop.sh"
            node.vm.provision :shell, :path => "scripts/setup-hadoop-workers.sh", :args => "-s 2 -t #{numNodes}"

            if i == 1
                node.vm.provision :shell, :path => "scripts/setup-spark.sh"
                node.vm.provision :shell, :path => "scripts/setup-namenode.sh", privileged: false
            end
        end
    end    
end
  