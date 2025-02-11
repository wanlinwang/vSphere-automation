# Define Cloudbase-Init download URL and paths
$msiLocation = 'https://cloudbase.it/downloads'
$msiFileName = 'CloudbaseInitSetup_Stable_x64.msi'
$downloadPath = "C:\$msiFileName"
 
# Download Cloudbase-Init
Invoke-WebRequest -Uri "$msiLocation/$msiFileName" -OutFile $downloadPath
Unblock-File -Path $downloadPath
 
# Install silently, run as local system
Start-Process msiexec.exe -ArgumentList "/i $downloadPath /qn /norestart RUN_SERVICE_AS_LOCAL_SYSTEM=1" -Wait
 
# Define conf file
$confFile = 'cloudbase-init.conf'
$confPath = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\"
 
# Multiline string for Cloudbase-Init config
$confContent = @"
[DEFAULT]
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
auto_logs=true
logdir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
logfile=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
metadata_services=cloudbaseinit.metadata.services.ovfservice.OvfService
plugins=cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,cloudbaseinit.plugins.common.sshpublickeys.SetUserSSHPublicKeysPlugin,cloudbaseinit.plugins.windows.extendvolumes.ExtendVolumesPlugin,cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,cloudbaseinit.plugins.common.setuserpassword.SetUserPasswordPlugin,cloudbaseinit.plugins.common.networkconfig.NetworkConfigPlugin,cloudbaseinit.plugins.common.localscripts.LocalScriptsPlugin,cloudbaseinit.plugins.common.userdata.UserDataPlugin
"@
 
# Write the config file
New-Item -Path $confPath -Name $confFile -ItemType File -Force -Value $confContent | Out-Null
 
# Set Cloudbase-Init to delayed auto start
Start-Process sc.exe -ArgumentList "config cloudbase-init start= delayed-auto" -Wait | Out-Null
 
# Remove the default unattend file (but keep Unattend.xml)
Remove-Item ($confPath + "cloudbase-init-unattend.conf") -Confirm:$false
 
# Cleanup MSI
Remove-Item $downloadPath -Confirm:$false