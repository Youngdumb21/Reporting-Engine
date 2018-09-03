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

#Function to get the authentication token, to be called only once

Function Get-AuthCode 
{
Add-Type -AssemblyName System.Windows.Forms
$form = New-Object -TypeName System.Windows.Forms.Form -Property @{Width=440;Height=640}
$web  = New-Object -TypeName System.Windows.Forms.WebBrowser -Property @{Width=420;Height=600;Url=($url -f ($Scope -join "%20")) }
$DocComp  = {
$Global:uri = $web.Url.AbsoluteUri        
if ($Global:uri -match "error=[^&]*|code=[^&]*") {$form.Close() }
}
$web.ScriptErrorsSuppressed = $true
$web.Add_DocumentCompleted($DocComp)
$form.Controls.Add($web)
$form.Add_Shown({$form.Activate()})
$form.ShowDialog() | Out-Null
$queryOutput = [System.Web.HttpUtility]::ParseQueryString($web.Url.Query)
$output = @{}
foreach($key in $queryOutput.Keys){
$output["$key"] = $queryOutput[$key]
}
$output
}
$url = "https://login.microsoftonline.com/common/oauth2/authorize?response_type=code&redirect_uri=$redirectUriEncoded&client_id=$clientID&resource=$resourceEncoded&prompt=admin_consent&scope=$scopeEncoded"
Get-AuthCode
$regex = '(?<=code=)(.*)(?=&)'
$Global:authCode  = ($uri | Select-string -pattern $regex).Matches[0].Value

Write-output "Received an authCode, $authCode"
$body = "grant_type=authorization_code&redirect_uri=$redirectUri&client_id=$clientId&client_secret=$clientSecretEncoded&code=$authCode&resource=$resource"
$Global:Authorization = Invoke-RestMethod https://login.microsoftonline.com/common/oauth2/token `
    -Method Post -ContentType "application/x-www-form-urlencoded" `
    -Body $body `
    -ErrorAction STOP
Write-output $Authorization.access_token
$Global:accesstoken = $Authorization.access_token
$Global:refreshtoken = $Authorization.refresh_token
$me = Invoke-RestMethod -Headers @{Authorization = "Bearer $accesstoken"} `
                        -Uri  https://graph.microsoft.com/v1.0/me `
                        -Method Get
$me 