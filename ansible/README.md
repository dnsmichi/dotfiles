# Ansible Playbooks for maintenance

_Note:_ The Embedded DevSecOps environment Ansible playbooks are located in https://gitlab.com/gitlab-da/use-cases/embedded/embedded-devsecops/environments/dnsmichi-embedded-devsecops-environment

## Requirements

1. Install Ansible (managed via Homebrew)
2. Configure `.ssh/config` with server details (managed in [../.ssh/config](../.ssh/config)
3. Distribute SSH keys
4. Install Ansible requirements

```shell
ansible-galaxy install -r requirements.yml
```

## Use cases

### Base packages

```shell
ansible-playbook -i inventory.ini default-config.yml 
```

### Linux VMs Upgrades

The playbook will run apt update and upgrade, and also reboot the servers when a Kernel upgrade is required. The Ansible run waits for reboot completion.

Run the playbook

```shell
ansible-playbook -i inventory.ini upgrade_linux_vms.yml
```

Add more hosts

```shell
vim hosts
```

## Ansible inventory

- [michi.fyi](https://gitlab.com/dnsmichi/michi.fyi)

## Thanks

Linux upgrade playbook inspired by https://www.cyberciti.biz/faq/ansible-apt-update-all-packages-on-ubuntu-debian-linux/ 
