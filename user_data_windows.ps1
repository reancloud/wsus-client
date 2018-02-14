<powershell>
write-output "Running User Data Script"

# Set TZ
write-output "Setting TZ"
cmd.exe /c tzutil /s "Eastern Standard Time"

write-output "Setting up Packer user"
cmd.exe /c net user /add packer ReAnCloud#2017
cmd.exe /c net localgroup administrators packer /add
cmd.exe /c wmic useraccount where "name='packer'" set PasswordExpires=FALSE

#setting execution policy
Set-ExecutionPolicy Unrestricted -Force

# WinRM
write-output "Setting up WinRM"
&winrm quickconfig `-q
&winrm set winrm/config '@{MaxTimeoutms="1800000"}'
&winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="4096"}'
&winrm set winrm/config/client/auth '@{Basic="true"}'
&winrm set winrm/config/service/auth '@{Basic="true"}'
&winrm set winrm/config/client '@{AllowUnencrypted="false"}'
&winrm set winrm/config/service '@{AllowUnencrypted="false"}'

# Firewall
write-output "Setting up Firewall"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Disable UAC
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force

</powershell>
