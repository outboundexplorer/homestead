class Homestead
  def Homestead.configure(config, settings)
    # Configure The Box
    config.vm.box = "laravel/homestead"
    config.vm.hostname = "homestead"

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Configure Port Forwarding To The Box
    config.vm.network "forwarded_port", guest: 80, host: 8000
    config.vm.network "forwarded_port", guest: 3306, host: 33060
    config.vm.network "forwarded_port", guest: 5432, host: 54320

    # Configure Port Forwarding for Elasticsearch (optional)
    config.vm.network "forwarded_port", guest:9200, host: 62000

    # Configure The Public Key For SSH Access
    config.vm.provision "shell" do |s|
      s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
      s.args = [File.read(File.expand_path(settings["authorize"]))]
    end

    # Copy The SSH Private Keys To The Box
    settings["keys"].each do |key|
      config.vm.provision "shell" do |s|
        s.privileged = false
        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
        s.args = [File.read(File.expand_path(key)), key.split('/').last]
      end
    end

    # Copy The Bash Aliases
    config.vm.provision "shell" do |s|
      s.inline = "cp /vagrant/aliases /home/vagrant/.bash_aliases"
    end


    # Create project databases with sites (optional)
    settings["sites"].each do |site|
       config.vm.provision "shell" do |s|
           if (site.has_key?("database"))
               s.path = "./scripts/create-database.sh"
               s.args = [site["map"],site["database"]]
           end
       end
    end

    # run project migrations
    if settings.has_key?("migrations")
        settings["migrations"].each do |migration|
            config.vm.provision "shell" do |s|
                s.path = "./scripts/migrate.sh"
                s.args = [migration["migrate"]]
             end
        end
    end

    # composer require developer packages
    if settings.has_key?("developer")
        settings["developer"].each do |install|
           config.vm.provision "shell" do |s|
               s.path = "./scripts/developer.sh"
               s.args = [install["project"]]
           end
        end
    end


    # Install packages
        if settings.has_key?("elasticsearch")
            config.vm.provision "shell" do |s|
                s.path = "./scripts/elasticsearch.sh"
            end
        end


    # run project seeds
    if settings.has_key?("seeds")
         settings["seeds"].each do |seed|
            config.vm.provision "shell" do |s|
                s.path = "./scripts/seed.sh"
                s.args = [seed["seed"]]
            end
         end
    end


    # Register All Of The Configured Shared Folders
    settings["folders"].each do |folder|
      config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil
    end

    # Install All The Configured Nginx Sites
            settings["sites"].each do |site|
             config.vm.provision "shell" do |s|
                 if (site.has_key?("hhvm") && site["hhvm"])
                   s.inline = "bash /vagrant/scripts/serve-hhvm.sh $1 $2"
                   s.args = [site["map"], site["to"]]
                 else
                   s.inline = "bash /vagrant/scripts/serve.sh $1 $2"
                   s.args = [site["map"], site["to"]]
                 end
             end
           end

    # Configure All Of The Server Environment Variables
    if settings.has_key?("variables")
      settings["variables"].each do |var|
        config.vm.provision "shell" do |s|
            s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf && service php5-fpm restart"
            s.args = [var["key"], var["value"]]
        end
      end
    end
  end
end

