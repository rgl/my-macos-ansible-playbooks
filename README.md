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

Run the `information.yml` playbook against the `vm` machine:

```bash
./ansible-playbook.sh --limit=vm information.yml -v
```

Lint the `development.yml` playbook:

```bash
./ansible-lint.sh --offline --parseable development.yml
```

Run the `development.yml` playbook against the `vm` machine:

```bash
./ansible-playbook.sh --limit=vm development.yml
```

Follow the [macOS Automation section](#macos-automation) to manually grant the
required permissions at the macOS desktop.

List this repository dependencies (and which have newer versions):

```bash
export GITHUB_COM_TOKEN='YOUR_GITHUB_PERSONAL_TOKEN'
./renovate.sh
```

# Initial Preparation

Create an account named `admin` with administrative privileges.

Login as the `admin` user in the macOS desktop.

Open the `System Settings` application, select `General`, select `Sharing`,
select `Remote Login`, and enable it.

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

Configure ssh to accept the ansible controller user ssh public key:

```bash
install -d -m 700 .ssh
install -m 600 /dev/null .ssh/authorized_keys
vim .ssh/authorized_keys
```

Exit the Terminal application:

```bash
exit
```

# macOS Automation

Automation is severely restricted by the following macOS security features:

* [Application permissions](https://support.apple.com/guide/mac-help/change-privacy-security-settings-on-mac-mchl211c911f/13.0/mac/13.0): Prevents controlling other applications and macOS itself.
* [Gatekeeper](https://en.wikipedia.org/wiki/Gatekeeper_(macOS)): Prevents non-signed and non-allowed applications from running.

You must manually allow the following applications to have the following permissions:

* `sshd-keygen-wrapper`
  * `Files and Folders` > `Full Disk Access`
  * `Full Disk Access`
  * `Automation` > `System Events`
  * `Accessability`

For requesting those permissions, you have to keep executing the playbook, until it reports no changes.

While executing the playbook, you have to manually grant the asked permissions at the macOS desktop.
