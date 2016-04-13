# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')

Vagrant.configure(2) do |config|

    #
    # Begin creating defined VMs to host docker external clusters.
    # Right now just Consul and Elasticsearch clusters hosted here
    #
    servers['cluster-servers'].each do |server|

        config.vm.define server["name"] do |srv|
            srv.vm.provider :virtualbox do |vb|
                vb.name = server["name"]
                vb.memory = server["ram"]
            end
            
            srv.vm.box = "ubuntu/trusty64"
            srv.vm.hostname = server["name"]
            srv.vm.network "private_network", ip: server["private_ip"]
            
            srv.vm.provision "shell" do |s|
                s.path = "provision-scripts/redis.sh"
            end
            
            srv.vm.provision "shell" do |s|
                s.path = "provision-scripts/consul_server_only.sh"
                s.args   = ["/vagrant/consul/server-" + server["name"] + ".json"]
            end
            
            srv.vm.provision "shell" do |s|
                s.path = "provision-scripts/elasticsearch_master.sh"
                s.args   = [server["name"]]
            end
        end
    end
    
    #
    # Begin creating defined docker host VMs
    #
    servers['docker-host-servers'].each do |server|
        config.vm.define server["name"] do |srv|
            srv.vm.provider :virtualbox do |vb|
                vb.name = server["name"]
                vb.memory = server["ram"]
            end
            
            srv.vm.box = "ubuntu/trusty64"

            srv.vm.hostname = server["name"]
            srv.vm.network "private_network", ip: server["private_ip"]

            # Single line would just install docker on the machine, nothing else
            # srv.vm.provision "docker"
            
            # Install docker on the machine and build a tagged docker image that can
            # be used to start docker containers later on
            srv.vm.provision "docker" do |d|
                d.build_image "/vagrant/dotnet", args: "-t jvandevelde/aspnetcoredemo"
            end
            
            # As explained in https://www.hashicorp.com/blog/feature-preview-vagrant-1-6-docker-dev-environments.html
            # video 3. Kills all open ssh connections which forces Vagrant to re-open it, allowing it to access the 
            # docker daemon
            srv.vm.provision "shell", inline:
                "ps aux | grep 'sshd:' | awk '{print $2}' | xargs kill"

            # Setup automatic docker container based service registry via Consul.
            # On startup, containers will automatically be registered in the service registry
            srv.vm.provision "shell" do |s|
                s.path = "provision-scripts/docker_registry_setup.sh"
                s.args = [server["private_ip"]]
            end
            
            # install tools like logstash that can be used by other containers
            # === Current ===
            #   1. Logstash -> Used to forward logs from containers/host to elasticsearch
            srv.vm.provision "shell" do |s|
                s.path = "provision-scripts/docker_infrastructure.sh"
            end

            # Install multiple instances of a demo service to demostrate the various tools/concepts
            srv.vm.provision "shell" do |s|
                s.path = "provision-scripts/docker_demo_svcs.sh"
                s.args = [server["container_prefix"]]
            end  
        end
    end 
    #
    # End docker hosts
    #
    
    #
    # Machine with Consul.io agent set up in client-only mode. Clients don't participate in
    # cluster setup and is not eligible to become a cluster leader. 
    # The client also has the optional web UI front-end installed and available at
    #    http://172.28.128.30:8500/ui/
    config.vm.define "consulclient" do |client|
        client.vm.provision "shell" do |s|
            s.path = "provision-scripts/consul_with_web_ui.sh"
            s.args   = ["/vagrant/consul/client-1.json"]
        end
        
        client.vm.box = "ubuntu/trusty64"
        client.vm.hostname = "consulclient"
        client.vm.network "private_network", ip: "172.28.128.30"
    end
    
    #
    # Machine with Fabio HTTP router installed and configured with Consul.io backed
    # service discovery.
    # Web UI available at:
    #   http://172.28.128.31:9998
    # Configured to route requests to 
    #   http://172.28.128.31:9999
    # to services hosted in docker and registered in Consul
    config.vm.define "httprouter" do |router|
        router.vm.provider "virtualbox" do |v|
            v.name = "httprouter"
            v.memory = 512
            v.cpus = 1
        end
        
        router.vm.box = "ubuntu/trusty64"
        router.vm.hostname = "httprouter"
        
        #router.vm.network "forwarded_port", guest: 443, host: 8443
        router.vm.network "private_network", ip: "172.28.128.31"
        router.vm.provision "shell", 
            privileged: false, 
            path: "provision-scripts/golang.sh"

        router.vm.provision "shell", path: "provision-scripts/fabio.sh"
    end
    
    # Vagrant machine that is actually just launching a Docker container inside a
    # previously defined machine. Allows you to control containers as if they were 
    # regular Vagrant machines (status, up, destroy, halt, etc.)
    config.vm.define "docker-kibana" do |m|
        m.vm.provider :docker do |d|
            d.vagrant_machine = "docker-1"
            d.vagrant_vagrantfile = "./Vagrantfile"
            d.name = 'kibana-dashboard'
            d.image = "kibana:4.4"     #latest requires newest ES 2.3 juest released March 30, 2016
            d.remains_running = true
            d.create_args = ["-e", "ELASTICSEARCH_URL=http://172.28.128.10:9200"]
            d.ports = ["5601:5601"]
        end
    end
    
    # A sample of a deploying a Vagrant machine that uses the Docker provider
    # but first builds a local Docker image from source prior to deploying the container.
    # This is good for things like dev environments backed by Docker
    # or developing Dockerfiles
    #  - Requires a docker host vagrant machine to be available/defined
    #  - Will build a Dockerfile at the location of build_dir
    #  - Will create a Vagrant machine that can be controlled via vagrant up/destroy/etc
    #  - Does not create an image on the docker host?
    config.vm.define "dotnetcore-container" do |m|
 
        m.vm.provider :docker do |d|
            d.name = 'aspnetcore-test1'
            d.build_dir = "./dotnet"
            d.remains_running = true
            d.vagrant_machine = "docker-1"
            d.vagrant_vagrantfile = "./Vagrantfile"
        end
    end
    
end