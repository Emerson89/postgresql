# -*- mode: ruby -*-
# vi: set ft=ruby :

vms = {
'postgresql1' => {'memory' => '1024', 'cpus' => '1', 'ip' => '14', 'box' => 'ubuntu/focal64'},
#'postgresql2' => {'memory' => '1024', 'cpus' => '1', 'ip' => '13', 'box' => 'almalinux/8'},
}

Vagrant.require_version ">= 1.8.0"

Vagrant.configure('2') do |config|
  vms.each do |name, conf|
     config.vm.define "#{name}" do |my|
       my.vm.box = conf['box']
       my.vm.hostname = "#{name}"
       #my.disksize.size = '30GB'
       my.vm.network 'private_network', ip: "172.16.3.#{conf['ip']}"
       #my.vm.network 'public_network', ip: "192.168.3.#{conf['ip']}", bridge: "wlp0s20f3"
       #my.vm.provision 'shell', path: "script.sh"
       my.vm.provision "ansible" do |ansible|
          ansible.playbook = "playbook.yml"
          ansible.extra_vars = {
            install_postgresql: true
          }
       end
       my.vm.provider 'virtualbox' do |vb|
          vb.memory = conf['memory']
          vb.cpus = conf['cpus']
       end
     end
  end
end

