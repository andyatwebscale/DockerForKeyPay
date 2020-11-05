# DockerForKeyPay
This repository contains the Dockerfile for setting up SQL 2019 and importing Common, Shard4 and Shard5

## Prerequisites:
***
- WSL2 Enabled and configured BEFORE Docker for Windows is installed (instructions below)

- Docker for Windows is installed and configured (instructions below)

- SQL backup files are downloaded and placed in C:\DbBackupFiles. If you require a different location then make sure you update the docker run command to ensure the volume path (-v) matches
<br></br>
## How to set up SQL Server 2019:
***
- Update the import.sh file to ensure you only restore the databases you have downloaded. Each backup has it's own section

- Open Powershell as an administrator, with the working directory the same as the location of the .Dockerfile file

- Run the following two commands

```sh
docker build -t database .

docker run -d --name "sql2019-ubuntu"  -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=SaPassword1" -p 1433:1433 -v ~/C/DbBackupFiles:/backups database
```

- Connect with SSMS / equivalent, to localhost, using Username: 'sa' Password 'SaPassword1'
<br></br>
## How to set up Redis
***
In PowerShell, type
```sh
docker run --name redis-container -d -p 6379:6379 redis
```
This will pull an image of Redis from Docker Hub and run it.
<br></br>
## Enabling WSL2
***
The Windows Subsystem for Linux lets developers run a GNU/Linux environment -- including most command-line tools, utilities, and applications -- directly on Windows, unmodified, without the overhead of a traditional virtual machine or dual-boot setup.

WSL 2 is a new version of the Windows Subsystem for Linux architecture that powers the Windows Subsystem for Linux to run ELF64 Linux binaries on Windows. Its primary goals are to increase file system performance, as well as adding full system call compatibility.

This new architecture changes how these Linux binaries interact with Windows and your computer's hardware.

The new Docker architecture works a lot like Visual Studio Code's WSL remote development support in that the Docker CLI running on the host machine executes commands within the Docker Integration Package, which runs on the remote WSL VM.

Docker runs directly within WSL so there's no need for the Hyper-V VM and all Linux containers run within the Linux userspace on Windows for improved performance and compatibility.
<br></br>
### Steps: (from: https://docs.microsoft.com/en-us/windows/wsl/install-win10)


1. Enable WSL2 - In PowerShell, run the command
```sh
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```
2. Update Windows
```sh
Requirement for x64 systems: Version 1903 or higher, with Build 18362 or higher
```
3. Enable virtual machine feature - In PowerShell, run the command
```sh
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
4. Download and run the Linux kernel update package
```sh
https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
```
5. Set WSL2 as the default version - In PowerShell, run the command
```sh
wsl --set-default-version 2
```
6. Install your chosen Linux distribution from:
```sh
https://aka.ms/wslstore
```
7. Check the WSL mode - In PowerShell, run the command
```sh
wsl.exe -l -v
```
8. If your distro isn’t version 2, update it
```sh
wsl.exe --set-version <distro name> 2
```
9. Configure resources
```sh
This site will describe the contents of the .wslconfig and where to place it:

https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig

An example of the content is:

[wsl2]
memory=12GB
processors=4
localhostForwarding=true
swap=150GB

```
<br></br>
## Installing Docker for Windows
***
Docker can be installed by navigating to https://hub.docker.com or by using this link: https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe

Once installed, go to Settings->Resources->WSL Integration and ensure the WSL2 distro you selected is enabled.