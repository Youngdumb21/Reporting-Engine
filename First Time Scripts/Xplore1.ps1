#Script to fetch data from Microsoft Intune and store it into the respective CSV files.
#The directories specified in the script must be changed according to needs.
#Client ID and Client Secret are Application ID and a generated key for the Web API which is used to establish the connection

cd "C:\Users\INT_AKASHSD\Desktop"
$Global:resource = "https://graph.microsoft.com"
$Global:clientid = "e3ce846b-fd3b-45ee-b8a0-456346a18f63"
$Global:clientSecret = "orKxk0ka4JACZ9dQmmrTelA1lDkkY+p21IdnIrEZHYg="
$Global:redirectUri = "http://localhost:80"
Add-Type -AssemblyName System.Web 
$Global:clientIDEncoded = [System.Web.HttpUtility]::UrlEncode($clientid)
$Global:clientSecretEncoded = [System.Web.HttpUtility]::UrlEncode($clientSecret)
$Global:redirectUriEncoded =  [System.Web.HttpUtility]::UrlEncode($redirectUri)
$Global:resourceEncoded = [System.Web.HttpUtility]::UrlEncode($resource)
$Global:scopeEncoded = [System.Web.HttpUtility]::UrlEncode("https://outlook.office.com/user.readwrite.all")

#Getting the refresh token from the file if available
$refreshtoken=Get-Content -path .\refreshtoken.txt
if ($refreshtoken -eq $null) 
{
.\Xplore
$accesstoken>accesstoken.txt
$refreshtoken>refreshtoken.txt
}
#Refreshing the access token
$body = "grant_type=refresh_token&redirect_uri=$redirectUri&client_id=$clientId&client_secret=$clientSecretEncoded&refresh_token=$refreshtoken&scope=$scopeEncoded"
$Global:Authorization = Invoke-RestMethod https://login.microsoftonline.com/common/oauth2/token `
    -Method Post -ContentType "application/x-www-form-urlencoded" `
    -Body $body `
    -ErrorAction STOP
$Global:accesstoken = $Authorization.access_token
$Global:refreshtoken = $Authorization.refresh_token

#Feeding the updated accesstoken and refresh token back into the files
$accesstoken>accesstoken.txt
$refreshtoken>refreshtoken.txt 


$Flag=0
$Flag>Users.csv

#Fetching the data of all the Users in Active Directory and storing it into a file named Users.csv 
$RESTResponse = Invoke-RestMethod -Method Get -Headers @{"Authorization" = "Bearer $accesstoken"} -Uri https://graph.microsoft.com/beta/users
Clear-Content Users.csv
Add-content Users.csv -Value 'DisplayName,UserPrincipalName'
if (-not[string]::IsNullOrEmpty($RESTResponse.Value)) {
    foreach ($Application in $RESTResponse.Value) {
	"$($Application.DisplayName),$($Application.UserPrincipalName)"|Add-Content Users.csv -Verbose	    
}
}
$android=0
$iOS=0
$macos=0
$windows=0
$windows_mobile=0
$unknown=0
$jailed=0
$jailed_not=0
$jailed_un=0
$compliant=0
$noncompliant=0
$uncompliant=0
$unknown=0
$dev_enrol=0
$dev_enrol_fail=0
$Flag>OSBased.csv
$Flag>Devices.csv
$Flag>Jail.csv
$Flag>Compliance.csv
$Flag>DeviceEnrol.csv

#Fetching the data of all the Device in Active Directory and storing it into a file named Devices.csv, OSBased.csv, Jail.csv, Compliance.csv, DeviceEnrol.csv
$RESTResponse = Invoke-RestMethod -Method Get -Headers @{"Authorization" = "Bearer $accesstoken"} -Uri https://graph.microsoft.com/beta/deviceManagement/managedDevices
Clear-content OSBased.csv
Clear-content Devices.csv
Clear-content Jail.csv
Clear-content Compliance.csv
Clear-content DeviceEnrol.csv

#Adding data to Devices.csv
Add-content Devices.csv -Value 'DeviceId, UserId, DeviceName, ComplianceState, DeviceType, JailBrokenStatus, UserPrincipalName, Model, Manufacturer, OperatingSystem, DeviceEnrollmentType' -Verbose

#Checking the conditions for all device properties in a single loop
if (-not[string]::IsNullOrEmpty($RESTResponse.Value)) {
foreach ($Application in $RESTResponse.Value) {
if($Application.operatingSystem -ieq "Android")
{ $android++}	
if($Application.operatingSystem -ieq "MACOS")
{ $macos++}	
if($Application.operatingSystem -ieq "iOS")
{ $iOS++}
if($Application.operatingSystem -ieq "Windows")
{ $windows++}
if($Application.operatingSystem -ieq "Windows Mobile")
{ $windows_mobile++}
if($Application.operatingSystem -ieq "Unknown")
{ $unknown++}
if($Application.jailBroken -ieq "True")
{ $jailed++}
if($Application.jailBroken -ieq "False")
{ $jailed_not++}
if($Application.jailBroken -ieq "Unknown")
{ $jailed_un++}	
if($Application.ComplianceState -ieq "compliant")
{ $compliant++}
if($Application.ComplianceState -ieq "noncompliant")
{ $noncompliant++}
if($Application.ComplianceState -ieq "unknown")
{ $uncompliant++} 
if($Application.deviceEnrollmentType -ieq "UserEnrollment")
{ $dev_enrol++}
else
{ $dev_enrol_fail++}
	"$($Application.id),$($Application.userid),$($Application.DeviceName),$($Application.ComplianceState),$($Application.deviceType),$($Application.jailBroken),$($Application.userPrincipalName),$($Application.model),$($Application.manufacturer),$($Application.operatingSystem),$($Application.deviceEnrollmentType)"|Add-Content Devices.csv -Verbose
}
}

#Adding content in OSBased.csv which categorizes devices on the basis of Operating Systems
Add-content OSBased.csv -Value 'Android, MACOS, iOS, Windows, WindowsMobile, Unknown'
"$($android),$($macos),$($iOS),$($windows),$($windows_mobile),$($unknown)"|Add-Content OSBased.csv -Verbose	

#Adding content in Jail.csv to check for Jail Broken Devices			
Add-content Jail.csv -Value 'JailBroken, NotJailBroken, Unknown'
"$($jailed),$($jailed_not),$($jailed_un)"|Add-content Jail.csv -Verbose

#Adding content in Compliance.csv to determine compliant devices
Add-content Compliance.csv -Value 'Compliant, NotCompliant, Unknown'
"$($compliant),$($noncompliant),$($uncompliant)"|Add-content Compliance.csv -Verbose

#Adding content in DeviceEnrol.csv to get Enrollment Status
Add-content DeviceEnrol.csv -Value 'DeviceEnrollmentSuccess, DeviceEnrollmentFailure'
"$($dev_enrol),$($dev_enrol_fail)"|Add-Content DeviceEnrol.csv -Verbose

$featured=0
$featured_not=0
$featured_un=0
$global=0
$global_not=0
$flag>FeaturedApp.csv
$flag>GlobalApp.csv

#Fetching the data of all the apps in the Azure Tenant
$RESTResponse = Invoke-RestMethod -Method Get -Headers @{"Authorization" = "Bearer $accesstoken"} -Uri https://graph.microsoft.com/beta/deviceAppmanagement/mobileapps
Clear-content FeaturedApp.csv
Clear-content GlobalApp.csv

#Checking for the different properties of applications
if (-not[string]::IsNullOrEmpty($RESTResponse.Value)) {
foreach ($Application in $RESTResponse.Value) {
if($Application.isFeatured -ieq "True")
{ $featured++}
if($Application.isFeatured -ieq "False")
{ $featured_not++}
if($Application.isFeatured -ieq "Unknown")
{ $featured_un++}
if($Application.appAvailability -ieq "global")
{ $global++} 
else
{ $global_not++}
}
}

#Adding content in FeaturedApp.csv to get number of Featured Apps
Add-content FeaturedApp.csv -Value 'Featured, NotFeatured, Unknown'
"$($featured),$($featured_not),$($featured_un)"|Add-Content FeaturedApp.csv -Verbose

#Adding content in GlobalApp.csv to get number of Global Apps
Add-content GlobalApp.csv -Value 'GlobalApps, NotGlobalApps'
"$($global),$($global_not)"|Add-content GlobalApp.csv -Verbose
$managedapps=0
$flag>ManagedApps.csv

#Fetching data of all the managed applications in Active Directory
$RESTResponse = Invoke-RestMethod -Method Get -Headers @{"Authorization" = "Bearer $accesstoken"} -Uri https://graph.microsoft.com/beta/applications
Clear-content ManagedApps.csv
if (-not[string]::IsNullOrEmpty($RESTResponse.Value)) {
foreach ($Application in $RESTResponse.Value) {
$managedapps++ }
}

#Adding content in ManagedApps.csv
Add-content ManagedApps.csv -Value 'NumberofManagedApps'
"$($managedapps)"|Add-content ManagedApps.csv -Verbose

#Calling the next script to carry  out the functions of Power BI
.\powerbi