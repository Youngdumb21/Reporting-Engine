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


#Getting all the reports created after the datasets are updated
$report= Get-PBIReport -authToken $authToken

#Downloading all the reports in the local device at a certain location
foreach ($Application in $report) {
If($Application.name -eq "Users") 
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
}
If($Application.name -eq "Devices")
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
} 
If($Application.name -eq "OSBased")
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
}
If($Application.name -eq "Jail")
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
} 
If($Application.name -eq "Compliance")
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
}
If($Application.name -eq "DeviceEnrol")
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
}
If($Application.name -eq "FeaturedApp")
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
}
If($Application.name -eq "GlobalApp")
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
}
If($Application.name -eq "ManagedApps")
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
}
If($Application.name -eq "Dashboard")
{
Export-PBIReport -authToken $authToken -report $Application.id -destinationFolder ".\Reports\Current Reports" -group $group.id
}	    
}

#Folder name for the specific date and time
$folder=(get-date -uformat '%Y%m%d-%T').Replace(":","")

#Creating the new folder
New-Item -ItemType directory -Path .\Reports\$folder

#Copying all the current reports to the specific date and time folder
copy-item -path ".\Reports\Current Reports\Users.pbix" -destination ".\Reports\$folder" 	
copy-item -path ".\Reports\Current Reports\Devices.pbix" -destination ".\Reports\$folder"
copy-item -path ".\Reports\Current Reports\OSBased.pbix" -destination ".\Reports\$folder"
copy-item -path ".\Reports\Current Reports\Jail.pbix" -destination ".\Reports\$folder"
copy-item -path ".\Reports\Current Reports\Compliance.pbix" -destination ".\Reports\$folder"
copy-item -path ".\Reports\Current Reports\DeviceEnrol.pbix" -destination ".\Reports\$folder"
copy-item -path ".\Reports\Current Reports\FeaturedApp.pbix" -destination ".\Reports\$folder"
copy-item -path ".\Reports\Current Reports\GlobalApp.pbix" -destination ".\Reports\$folder"
copy-item -path ".\Reports\Current Reports\ManagedApps.pbix" -destination ".\Reports\$folder"
copy-item -path ".\Reports\Current Reports\Dashboard.pbix" -destination ".\Reports\$folder"

#Renaming all the current files with specific date and time file names
Rename-Item -Path ".\Reports\$folder\Users.pbix" -NewName $name1".pbix"
Rename-Item -Path ".\Reports\$folder\Devices.pbix" -NewName $name2".pbix"
Rename-Item -Path ".\Reports\$folder\OSBased.pbix" -NewName $name3".pbix" 
Rename-Item -Path ".\Reports\$folder\Jail.pbix" -NewName $name4".pbix"
Rename-Item -Path ".\Reports\$folder\Compliance.pbix" -NewName $name5".pbix"
Rename-Item -Path ".\Reports\$folder\DeviceEnrol.pbix" -NewName $name6".pbix"
Rename-Item -Path ".\Reports\$folder\FeaturedApp.pbix" -NewName $name7".pbix"
Rename-Item -Path ".\Reports\$folder\GlobalApp.pbix" -NewName $name8".pbix"
Rename-Item -Path ".\Reports\$folder\ManagedApps.pbix" -NewName $name9".pbix"
Rename-Item -Path ".\Reports\$folder\Dashboard.pbix" -NewName $name10".pbix"

#Uploading the renamed files to Power BI workspace
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name1.pbix" -groupId $group.id
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name2.pbix" -groupId $group.id
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name3.pbix" -groupId $group.id
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name4.pbix" -groupId $group.id
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name5.pbix" -groupId $group.id
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name6.pbix" -groupId $group.id
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name7.pbix" -groupId $group.id
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name8.pbix" -groupId $group.id
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name9.pbix" -groupId $group.id
Import-PBIFile -authToken $authToken -file "C:\Users\INT_AKASHSD\Desktop\Reports\$folder\$name10.pbix" -groupId $group.id

#Getting all the reports in the Power BI worskpace
#The duplicate reports are also now in the Power BI workspace but with a specific date and time name
$report=Get-PBIReport -authToken $authToken

#Getting all the datasets in the Power BI workspace
#The duplicate datasets are also in the workspace
$data=Get-PBIDataset -authToken $authToken

#Rebinding all the duplicate reports with duplicate datasets so that these duplicate reports and datasets might not get updated in future
#These reports can be used later on for analysis
foreach($App in $report)
{
if($App.name -eq $name1)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset1.id 
}
if($App.name -eq $name2)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset2.id 
}
if($App.name -eq $name3)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset3.id 
}
if($App.name -eq $name4)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset4.id 
}
if($App.name -eq $name5)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset5.id 
}
if($App.name -eq $name6)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset6.id 
}
if($App.name -eq $name7)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset7.id 
}
if($App.name -eq $name8)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset8.id 
}
if($App.name -eq $name9)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset9.id 
}
if($App.name -eq $name10)
{
Set-PBIReportsDataset -authToken $authToken -report $App.id -targetDatasetId $dataset10.id 
}
}

#Importing the OneDrive Module for PowerShell
#If not available, install it using the following command:- Install-Module OneDrive
Import-Module OneDrive

#Getting Refresh Token from file for OneDrive Authentication
$refreshtoken=Get-Content -path .\refreshtoken2.txt

#Refreshing the access token
$Authen=Get-ODAuthentication -ClientID "11f3c9d9-3f13-4f40-93f0-e2388a68b267" -AppKey "xOKSA57![*kcaizgALM889:" -RedirectURI http://localhost:80 -refreshtoken $refreshtoken

#Feeding the updated access token and refresh token to respective files
$Authen.access_token>accesstoken2.txt
$Authen.refresh_token>refreshtoken2.txt

#Getting the access token
$AuthT=Get-Content accesstoken2.txt

#Searching for a folder with name "Power BI Reports"
#If a folder is not available, then, a new folder is created with name "Power BI Reports"
if(!(Search-ODItems -AccessToken $AuthT -SearchText "Power BI Reports"))
{
New-ODFolder -AccessToken $AuthT -FolderName "Power BI Reports"
}

#Searching for a folder with name "Current Reports" inside "Power BI Reports"
#If a folder is not available, then, a new folder is created with name "Current Reports" inside "Power BI Reports"
if(!(Search-ODItems -AccessToken $AuthT -SearchText "Current Reports" -Path "/Power BI Reports"))
{
New-ODFolder -AccessToken $AuthT -Path "/Power BI Reports" -FolderName "Current Reports"
}

#Creating a new folder with a specific date and time name 
New-ODFolder -AccessToken $AuthT -Path "/Power BI Reports" -FolderName $folder

#Navigating to the specific folder on local device to access reports
#Adding the reports to OneDrive folder with specific date and time name
cd "./Reports/$folder"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name1.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name2.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name3.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name4.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name5.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name6.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name7.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name8.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name9.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/$folder" -Localfile "$name10.pbix"
cd..
cd..

#Navigating to the "Current Reports" folder on local device to access current reports
#Adding the current reports to OneDrive folder with name "Current Reports" inside "Power BI Reports"
cd "./Reports/Current Reports"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "Users.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "Devices.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "OSBased.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "Jail.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "Compliance.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "DeviceEnrol.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "FeaturedApp.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "GlobalApp.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "ManagedApps.pbix"
Add-ODItem -AccessToken $AuthT -Path "/Power BI Reports/Current Reports" -Localfile "Dashboard.pbix"
cd..
cd..

#Removing the files from local device so that no dependency is left on local machine
Remove-Item -path .\Reports -force -recurse
Remove-Item -path .\Users.csv -force -recurse
Remove-Item -path .\Devices.csv -force -recurse
Remove-Item -path .\OSBased.csv -force -recurse
Remove-Item -path .\Jail.csv -force -recurse
Remove-Item -path .\Compliance.csv -force -recurse
Remove-Item -path .\DeviceEnrol.csv -force -recurse
Remove-Item -path .\FeaturedApp.csv -force -recurse
Remove-Item -path .\GlobalApp.csv -force -recurse
Remove-Item -path .\ManagedApps.csv -force -recurse