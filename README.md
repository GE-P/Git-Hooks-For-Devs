#
```
   __ __          __          ____           ___             
  / // /__  ___  / /__ ___   / __/__  ____  / _ \___ _  _____
 / _  / _ \/ _ \/  '_/(_-<  / _// _ \/ __/ / // / -_) |/ (_-<
/_//_/\___/\___/_/\_\/___/ /_/  \___/_/   /____/\__/|___/___/

```
#

## - Before proceding to the installation (Windows) :

First you need to have the right to execute powershell script. To do that you need to open a powershell terminal as administrator and execute the following command :
 #### - ``` Set-ExecutionPolicy Unrestricted ```

To verify the good behavior of the command execute the command :
#### - ``` Get-ExecutionPolicy ```

After executing the scripts provided you'll need to put the execution policy back to restricted to avoid any security breach comming from scripts execution. Simply execute :
#### - ``` Set-ExecutionPolicy Restricted ``` 

#
## - How to install the hooks :
#

There is two types of installation, one for Linux Operating Systems and one for Windows Operating Systems.

Simply clone the project. All the necessary files are already present.

### Linux :
#

Execute the < hooks_installer.sh > as root user and as follow : 
#### - ``` ./hooks_installer.sh ```

After the install it will prompt you if you want to update all your exusting projects, say yes and it will ask for the path where your projects are. The update is automatic.

If needed, you can say no and execute < hooks_updater.sh > alone as follow : 
#### - ``` ./hooks_updater.sh ```

### Windows :
#

Open a powershell terminal as administrator and enter inside the folder containing the scripts, then simply execute as follow : 
#### - ``` .\hooks_installer.ps1 ```

Same behavior as with the linux script. The updater will take in account two paths automatically : " C:\Users" and "D:\". 

If needed you can execute separatly the hooks_updater as follow : 
#### - ``` .\hooks_updater.ps1 ```