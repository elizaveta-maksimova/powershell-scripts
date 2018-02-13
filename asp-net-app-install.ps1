<#
    .SYNOPSIS
        Downloads and configures ASP.NET application sample across IIS and Azure SQL DB.
#>

Param (
    [string]$sqlUserName,
    [string]$sqlUserPassword,
    [string]$sqlUserServer,
    [string]$storageName,
    [string]$storagePassword
)

# Firewall
netsh advfirewall firewall add rule name="http" dir=in action=allow protocol=TCP localport=80

# Folders
New-Item -ItemType Directory c:\temp
New-Item -ItemType Directory c:\azurestore

# Install iis and ASP.NET 4.5
Install-WindowsFeature web-server -IncludeManagementTools
Install-WindowsFeature NET-Framework-45-ASPNET

# Download app
Invoke-WebRequest  https://github.com/elizaveta-maksimova/powershell-scripts/blob/master/azure-store-app/archived/azure-store-app.zip -OutFile c:\temp\azurestore.zip

# Expand zip archive
Expand-Archive C:\temp\azurestore.zip c:\azurestore

$webConfig = 'C:\app\Web.config'
$webConfigXml = (Get-Content $webConfig) -as [Xml]

$storageConnection = $webConfigXml.configuration.appSettings.add | where {$_.Key -eq 'StorageConnectionString'}
$storageConnection.value = "DefaultEndpointsProtocol=https;AccountName=$storageName;AccountKey=$storagePassword"

$dbConnection = $webConfigXml.configuration.connectionStrings.add | where {$_.Name -eq 'ProductModel'}
$dbConnection.connectionString = "Server=$sqlUserServer;Database=MusicStore;Integrated Security=False;User Id=$sqlUserName;Password=$sqlUserPassword;MultipleActiveResultSets=True;Connect Timeout=30"

$webConfigXml.Save($webConfig)

# Configure iis
Remove-WebSite -Name "Default Web Site"
Set-ItemProperty IIS:\AppPools\DefaultAppPool\ managedRuntimeVersion ""
New-Website -Name "AzureStore" -Port 80 -PhysicalPath C:\azurestore\ -ApplicationPool DefaultAppPool
& iisreset