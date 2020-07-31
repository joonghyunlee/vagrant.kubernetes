# -*- mode: ruby -*-
# vi: set ft=ruby :

['vagrant-hostmanager'].each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    raise "#{plugin} plugin not found. Please install it via 'vagrant plugin install #{plugin}'"
  end
end

DISTRO ||= "centos"
NODE_SETTINGS ||= {
  master: {
    count: 1,
    cpus: 2,
    memory: 2048
  },
  worker: {
    count: 2
    cpus: 1,
    memory: 1024
  }
}

Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.box_download_insecure = true
    master.vm.box = "bento/centos-7"
    master.vm.network "private_network", ip: "100.0.0.10"
    master.vm.hostname = "master"
    master.vm.provider "virtualbox" do |v|
      v.name = "master"
      v.memory = 2048
      v.cpus = 2
    end
  end

  config.vm.define "worker" do |worker|
    worker.vm.box_download_insecure = true
    worker.vm.box = "bento/centos-7"
    worker.vm.network "private_network", ip: "100.0.0.20"
    worker.vm.hostname = "worker"
    worker.vm.provider "virtualbox" do |v|
      v.name = "worker"
      v.memory = 1024
      v.cpus = 1
    end
  end
end
