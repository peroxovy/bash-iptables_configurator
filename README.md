# Iptables configurator

Iptables configurator is a simple bash script written in Debian which easily can:

  - Configure filter, nat and mangle table in iptables,
  - Make network configuration faster,
  - Help you configure your own firewall,
  - Store iptables commands in one file.

# Version
        As of:  05.05.2020
        Current version: 0.2v

# Requirements

  - You need to know how iptables works,
  - Got installed Unix system to run *.sh script,
  - Just want to use it! :)

# Storing commands
Commands are stored in file command.txt, you can easily copy it to your terminal and execute it. After adding another command, script appends it to new row, so you can copy whole file.

# Development
There are some things that I want to create - build in progress:
- Add function that saves your commands in specific file by user,
- Execute it automatically after configure,
- Manage your "config storage", where you got specific commands on any occasion
- Many more...

