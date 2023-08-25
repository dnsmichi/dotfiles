# Ansible Playbooks for maintenance

## Requirements

1. Install Ansible (managed via Homebrew)
2. Configure `.ssh/config` with server details (managed in [../.ssh/config](../.ssh/config)
3. Distribute SSH keys

## Use cases

### Linux VMs Upgrades

The playbook will run apt update and upgrade, and also reboot the servers when a Kernel upgrade is required. The Ansible run waits for reboot completion.

Run the playbook

```
ansible-playbook -i hosts upgrade_linux_vms.yml
```

Add more hosts

```
vim hosts
```


## Thanks

Linux upgrade playbook inspired by https://www.cyberciti.biz/faq/ansible-apt-update-all-packages-on-ubuntu-debian-linux/ 
