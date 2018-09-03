#Importing the Power BI CLI module
#If not available Install the module using the following command:- Install-Module PowerBIPS
Import-Module PowerBIPS

#Creating a PSCredential object to store username and password so that the prompt to login does not appear
$secpasswd = ConvertTo-SecureString "P@55w0rd" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("akashsd@mlgraph.onmicrosoft.com", $secpasswd)

#Getting the authentication token
$authToken = Get-PBIAuthToken -Credential $mycreds

#Checking if there is already a workspace with name "Intune Data"
#If the workspace is not available, then a new workspace is created with the name "Intune Data"
#The emailAddress assigned to workspace must be entered according to user's needs

if(!($group=Get-PBIGroup -authToken $authToken -name "Intune Data"))
{
$group=New-PBIGroup -authToken $authToken -name "Intune Data"
$group=Get-PBIGroup -authToken $authToken -name "Intune Data"
New-PBIGroupUser -authToken $authToken -groupId $group.id -emailAddress "akashsd@mlgraph.onmicrosoft.com"
}

#Setting the workspace "Intune Data" as the active one
Set-PBIGroup -authToken $authToken -id $group.id -name $group.name 

$name1="Users "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for Users dataset 
$dataSetSchema= @{name="Users";tables=@(@{name="Users";columns=@(@{name="DisplayName";dataType="String"},@{name="UserPrincipalName";dataType="String"})})}

#Checking if there is already a dataset with the name "Users"
#If not a new dataset will be created with name "Users", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "Users"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataset1=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "Users"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "Users"

#Entering data into both the datasets
Import-Csv "Users.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "Users" -batchsize 300 -verbose
Import-Csv "Users.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset1.Id -tableName "Users" -batchsize 300 -verbose

$name2="Devices "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for Devices dataset
$dataSetSchema= @{name="Devices";tables=@(@{name="Devices";columns=@(@{name="DeviceId";dataType="String"},@{name="UserId";dataType="String"},@{name="DeviceName";dataType="String"},@{name="ComplianceState";dataType="String"},@{name="DeviceType";dataType="String"},@{name="JailBrokenStatus";dataType="String"},@{name="UserPrincipalName";dataType="String"},@{name="Model";dataType="String"},@{name="Manufacturer";dataType="String"},@{name="OperatingSystem";dataType="String"},@{name="DeviceEnrollmentType";dataType="String"})})}

#Checking if there is already a dataset with the name "Devices"
#If not a new dataset will be created with name "Devices", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "Devices"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataSet2=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "Devices"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "Devices"

#Entering data into both the datasets
Import-Csv "Devices.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "Devices" -batchsize 300 -verbose
Import-Csv "Devices.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset2.Id -tableName "Devices" -batchsize 300 -verbose

$name3="OSBased "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for OSBased dataset
$dataSetSchema= @{name="OSBased";tables=@(@{name="OSBased";columns=@(@{name="Android";dataType="Int64"},@{name="MACOS";dataType="Int64"},@{name="iOS";dataType="Int64"},@{name="Windows";dataType="Int64"},@{name="WindowsMobile";dataType="Int64"},@{name="Unknown";dataType="Int64"})})}

#Checking if there is already a dataset with the name "OSBased"
#If not a new dataset will be created with name "OSBased", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "OSBased"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataset3=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "OSBased"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "OSBased"

#Entering data into both the datasets
Import-Csv "OSBased.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "OSBased" -batchsize 300 -verbose
Import-Csv "OSBased.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset3.Id -tableName "OSBased" -batchsize 300 -verbose
	
$name4="Jail "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for Jail dataset
$dataSetSchema= @{name="Jail";tables=@(@{name="Jail";columns=@(@{name="JailBroken";dataType="Int64"},@{name="NotJailBroken";dataType="Int64"},@{name="Unknown";dataType="Int64"})})}

#Checking if there is already a dataset with the name "Jail"
#If not a new dataset will be created with name "Jail", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "Jail"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataSet4=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "Jail"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "Jail"

#Entering data into both the datasets
Import-Csv "Jail.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "Jail" -batchsize 300 -verbose
Import-Csv "Jail.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset4.Id -tableName "Jail" -batchsize 300 -verbose

$name5="Compliance "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for Compliance dataset
$dataSetSchema= @{name="Compliance";tables=@(@{name="Compliance";columns=@(@{name="Compliant";dataType="Int64"},@{name="NotCompliant";dataType="Int64"},@{name="Unknown";dataType="Int64"})})}

#Checking if there is already a dataset with the name "Compliance"
#If not a new dataset will be created with name "Compliance", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "Compliance"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataSet5=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "Compliance"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "Compliance"

#Entering data into both the datasets
Import-Csv "Compliance.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "Compliance" -batchsize 300 -verbose
Import-Csv "Compliance.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset5.Id -tableName "Compliance" -batchsize 300 -verbose

$name6="DeviceEnrol "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for DeviceEnrol dataset
$dataSetSchema= @{name="DeviceEnrol";tables=@(@{name="DeviceEnrol";columns=@(@{name="DeviceEnrollmentSuccess";dataType="Int64"},@{name="DeviceEnrollmentFailure";dataType="Int64"})})}

#Checking if there is already a dataset with the name "DeviceEnrol"
#If not a new dataset will be created with name "DeviceEnrol", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "DeviceEnrol"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataSet6=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "DeviceEnrol"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "DeviceEnrol"

#Entering data into both the datasets
Import-Csv "DeviceEnrol.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "DeviceEnrol" -batchsize 300 -verbose
Import-Csv "DeviceEnrol.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset6.Id -tableName "DeviceEnrol" -batchsize 300 -verbose

$name7="FeaturedApp "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for FeaturedApp dataset
$dataSetSchema= @{name="FeaturedApp";tables=@(@{name="FeaturedApp";columns=@(@{name="Featured";dataType="Int64"},@{name="NotFeatured";dataType="Int64"},@{name="Unknown";dataType="Int64"})})}

#Checking if there is already a dataset with the name "FeaturedApp"
#If not a new dataset will be created with name "FeaturedApp", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "FeaturedApp"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataSet7=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "FeaturedApp"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "FeaturedApp"

#Entering data into both the datasets
Import-Csv "FeaturedApp.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "FeaturedApp" -batchsize 300 -verbose
Import-Csv "FeaturedApp.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset7.Id -tableName "FeaturedApp" -batchsize 300 -verbose

$name8="GlobalApp "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for GlobalApp dataset
$dataSetSchema= @{name="GlobalApp";tables=@(@{name="GlobalApp";columns=@(@{name="GlobalApps";dataType="Int64"},@{name="NotGlobalApps";dataType="Int64"})})}

#Checking if there is already a dataset with the name "GlobalApp"
#If not a new dataset will be created with name "GlobalApp", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "GlobalApp"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataSet8=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "GlobalApp"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "GlobalApp"

#Entering data into both the datasets
Import-Csv "GlobalApp.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "GlobalApp" -batchsize 300 -verbose
Import-Csv "GlobalApp.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset8.Id -tableName "GlobalApp" -batchsize 300 -verbose

$name9="ManagedApps "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for ManagedApps dataset
$dataSetSchema= @{name="ManagedApps";tables=@(@{name="ManagedApps";columns=@(@{name="NumberofManagedApps";dataType="Int64"})})}

#Checking if there is already a dataset with the name "ManagedApps"
#If not a new dataset will be created with name "ManagedApps", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "ManagedApps"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataSet9=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "ManagedApps"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "ManagedApps"

#Entering data into both the datasets
Import-Csv "ManagedApps.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "ManagedApps" -batchsize 300 -verbose
Import-Csv "ManagedApps.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset9.Id -tableName "ManagedApps" -batchsize 300 -verbose

$name10="Dashboard "+(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Dataset Schema for Dashboard dataset
$dataSetSchema= @{name="Dashboard";tables=@(@{name="OSBased";columns=@(@{name="Android";dataType="Int64"},@{name="MACOS";dataType="Int64"},@{name="iOS";dataType="Int64"},@{name="Windows";dataType="Int64"},@{name="WindowsMobile";dataType="Int64"},@{name="Unknown";dataType="Int64"})};@{name="Jail";columns=@(@{name="JailBroken";dataType="Int64"},@{name="NotJailBroken";dataType="Int64"},@{name="Unknown";dataType="Int64"})};@{name="Compliance";columns=@(@{name="Compliant";dataType="Int64"},@{name="NotCompliant";dataType="Int64"},@{name="Unknown";dataType="Int64"})};@{name="DeviceEnrol";columns=@(@{name="DeviceEnrollmentSuccess";dataType="Int64"},@{name="DeviceEnrollmentFailure";dataType="Int64"})};@{name="FeaturedApp";columns=@(@{name="Featured";dataType="Int64"},@{name="NotFeatured";dataType="Int64"},@{name="Unknown";dataType="Int64"})};@{name="GlobalApp";columns=@(@{name="GlobalApps";dataType="Int64"},@{name="NotGlobalApps";dataType="Int64"})};@{name="ManagedApps";columns=@(@{name="NumberofManagedApps";dataType="Int64"})})}

#Checking if there is already a dataset with the name "ManagedApps"
#If not a new dataset will be created with name "ManagedApps", this happens for the first time only
if(!($dataset=Get-PBIDataSet -authToken $authToken -name "Dashboard"))
{
$dataset=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
}

#Creating a duplicate dataset so that the previous data can be available in the future
$dataSet10=New-PBIDataSet -authToken $authToken -dataset $dataSetSchema -Verbose
$dataset=Get-PBIDataSet -authToken $authToken -name "Dashboard"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "OSBased"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "Jail"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "Compliance"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "DeviceEnrol"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "FeaturedApp"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "GlobalApp"
Clear-PBITableRows -authToken $authToken -datasetId $dataset.Id[0] -tableName "ManagedApps"

#Entering data into all tables of both the datasets
Import-Csv "OSBased.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "OSBased" -batchsize 300 -verbose
Import-Csv "Jail.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "Jail" -batchsize 300 -verbose
Import-Csv "Compliance.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "Compliance" -batchsize 300 -verbose
Import-Csv "DeviceEnrol.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "DeviceEnrol" -batchsize 300 -verbose
Import-Csv "FeaturedApp.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "FeaturedApp" -batchsize 300 -verbose
Import-Csv "GlobalApp.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "GlobalApp" -batchsize 300 -verbose
Import-Csv "ManagedApps.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset.Id[0] -tableName "ManagedApps" -batchsize 300 -verbose
Import-Csv "OSBased.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset10.Id -tableName "OSBased" -batchsize 300 -verbose
Import-Csv "Jail.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset10.Id -tableName "Jail" -batchsize 300 -verbose
Import-Csv "Compliance.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset10.Id -tableName "Compliance" -batchsize 300 -verbose
Import-Csv "DeviceEnrol.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset10.Id -tableName "DeviceEnrol" -batchsize 300 -verbose
Import-Csv "FeaturedApp.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset10.Id -tableName "FeaturedApp" -batchsize 300 -verbose
Import-Csv "GlobalApp.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset10.Id -tableName "GlobalApp" -batchsize 300 -verbose
Import-Csv "ManagedApps.csv"|Add-PBITableRows -authToken $authToken -dataSetId $dataset10.Id -tableName "ManagedApps" -batchsize 300 -verbose

#Please transfer the token files to the same directory as that of scripts