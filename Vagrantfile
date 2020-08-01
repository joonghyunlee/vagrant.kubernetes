# -*- mode: ruby -*-
# vi: set ft=ruby :

['vagrant-hostmanager'].each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    raise "#{plugin} plugin not found. Please install it via 'vagrant plugin install #{plugin}'"
  end
end

NODES ||= {
  master: {
    cpus: 2,
    memory: 2048,
    ip: 10
  },
  worker: {
    count: 2,
    cpus: 1,
    memory: 1024,
    ip: 20
  }
}

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false

  config.vm.synced_folder ".", "/home/vagrant/sync"

  config.vm.define "master" do |master|
    # master.vm.box_download_insecure = true
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "100.0.1.#{NODES[:master][:ip]}"
    master.vm.provider "virtualbox" do |v|
      v.cpus = NODES[:master][:cpus]
      v.memory = NODES[:master][:memory]
    end

    master.vm.provision :shell, :path => "scripts/bootstrap.sh"
    master.vm.provision :shell, :path => "scripts/master.sh", :args => "100.0.1.#{NODES[:master][:ip]}", privileged: false
  end

  (1..NODES[:worker][:count]).each do |i|
    hostname = "%s-%02d" % ["worker", i]

    config.vm.define "#{hostname}" do |worker|
      worker.vm.hostname = "#{hostname}"
      # worker.vm.box_download_insecure = true
      worker.vm.network "private_network", ip: "100.0.1.#{NODES[:worker][:ip] + i}"
      worker.vm.provider "virtualbox" do |v|
        v.cpus = NODES[:worker][:cpus]
        v.memory = NODES[:worker][:memory]        
      end

      worker.vm.provision :shell, :path => "scripts/bootstrap.sh"
      worker.vm.provision :shell, :path => "scripts/worker.sh"
    end
  end

end
