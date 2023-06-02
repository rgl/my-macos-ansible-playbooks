# About

[![Build status](https://github.com/rgl/my-macos-ansible-playbooks/workflows/build/badge.svg)](https://github.com/rgl/my-macos-ansible-playbooks/actions?query=workflow%3Abuild)

This is My macOS Ansible Playbooks Playground.

# Disclaimer

* These playbooks might work only when you start from scratch, in a machine that only has a minimal installation.
  * They might seem to work in other scenarios, but that is by pure luck.
  * There is no support for upgrades, downgrades, or un-installations.

# Usage

Add your machines into the Ansible [`inventory.yml` file](inventory.yml).

For each machine, do their [initial preparation](#initial-preparation).

Review the [`development.yml` playbook](development.yml).

See the facts about the `vm` machine:

```bash
./ansible.sh vm -m ansible.builtin.setup
```

Run an ad-hoc command in the `vm` machine:

```bash
./ansible.sh vm -a 'id'
```

Lint the `development.yml` playbook:

```bash
./ansible-lint.sh --offline --parseable development.yml
```

Run the `development.yml` playbook against the `vm` machine:

```bash
./ansible-playbook.sh --limit=vm development.yml
```

List this repository dependencies (and which have newer versions):

```bash
export GITHUB_COM_TOKEN='YOUR_GITHUB_PERSONAL_TOKEN'
./renovate.sh
```

# Initial Preparation

Create an account named `admin` with administrative privileges.

Login as the `admin` user in the macOS desktop.

Open the System Settings application, search for `Remote Login`, and enable it.

Click the `i` icon besides the `Remote Login` toggle, and enable
`Allow full disk access for remote users`.

Open the Terminal application and execute the following commands.

Install the Xcode command line developer tools:

```bash
xcode-select --install
```

Configure sudo for not asking for the user password when the user belongs to the `admin` group:

```bash
sudo -i
chmod +w /etc/sudoers
sed -i.orig -E 's,^%admin.+,%admin ALL=(ALL) NOPASSWD:ALL,g' /etc/sudoers
diff -u /etc/sudoers{.orig,}
rm -f /etc/sudoers.orig
chmod -w /etc/sudoers
exit
```

Exit the Terminal application:

```bash
exit
```
