<#	
	.DESCRIPTION
		Invoke an OVH API request.

	.PARAMETER ApplicationKey
		The application key required for authentication.

	.PARAMETER ApplicationSecret
		The application secret required for authentication.

	.PARAMETER ConsumerKey
		The consumer key required for authentication.

	.PARAMETER Url
		The URL of the OVH API. Default value is 'https://eu.api.ovh.com/1.0'.

	.PARAMETER Path
		The path of the OVH API. Example: '/sms/ServiceName/batches'.

	.PARAMETER Method
		The HTTP method to be used. Valid values are 'DELETE', 'GET', 'POST', 'PUT'.

	.PARAMETER Body
		The body of the request.

	.EXAMPLE
		Invoke-BSAOvhApiRequest -ApplicationKey 'your_app_key' -ApplicationSecret 'your_app_secret' -ConsumerKey 'your_consumer_key' -Path '/sms/$ServiceName/batches' -Method 'GET'

		This example demonstrates how to invoke an OVH API request using the 'GET' method.

	.NOTES
		Created on:   	31/05/2021
		Created by:   	Brice SARRAZIN
		Filename:     	Invoke-BSAOvhApiRequest.ps1

		For more information about the OVH API, refer to the official documentation at https://docs.ovh.com/.
#>

function Invoke-BSAOvhApiRequest {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
			HelpMessage = 'Application key.')]
		[string]$ApplicationKey,
		[Parameter(Mandatory = $true,
			HelpMessage = 'Application secret.')]
		[string]$ApplicationSecret,
		[Parameter(Mandatory = $true,
			HelpMessage = 'Consumer key.')]
		[string]$ConsumerKey,
		[Parameter(Mandatory = $false,
			HelpMessage = 'URL of the OVH API. Default: https://eu.api.ovh.com/1.0')]
		[string]$Url = 'https://eu.api.ovh.com/1.0',
		[Parameter(Mandatory = $true,
			HelpMessage = 'Path of the OVH API. Example: /sms/$ServiceName/batches')]
		[string]$Path,
		[Parameter(Mandatory = $true,
			HelpMessage = 'HTTP method.')]
		[ValidateSet('DELETE', 'GET', 'POST', 'PUT')]
		[string]$Method,
		[Parameter(Mandatory = $false,
			HelpMessage = 'Body of the request.')]
		[hashtable]$Body
	)
	
	try {
		$Url = $Url.TrimEnd('/')
		$Path = $Path.TrimStart('/')
		
		$properties = @{
			ContentType = 'application/json;charset=utf-8'
			Headers     = @{
				'X-Ovh-Application' = $ApplicationKey
				'X-Ovh-Consumer'    = $ConsumerKey
				'X-Ovh-Timestamp'   = (Invoke-WebRequest "$Url/auth/time").Content
			}
			Method      = $Method
			Uri         = "$Url/$Path"
			ErrorAction = 'Stop'
		}
		
		$timeStamp = (Invoke-WebRequest "$Url/auth/time").Content
		if ($PSBoundParameters['Body']) {
			$jsonBody = $Body | ConvertTo-Json -Compress
			$properties.Body = $jsonBody
			$preHash = "$ApplicationSecret+$ConsumerKey+$Method+$Url/$Path+$jsonBody+$timeStamp"
		}
		else {
			$properties.Body = $null
			$preHash = "$ApplicationSecret+$ConsumerKey+$Method+$Url/$Path++$timeStamp"
		}
		
		$sha1 = [Security.Cryptography.SHA1CryptoServiceProvider]::new()
		$bytes = [Text.Encoding]::UTF8.GetBytes($preHash)
		$hash = [BitConverter]::ToString($sha1.ComputeHash($bytes)).Replace('-', '').ToLower()
		$properties.Headers.'X-Ovh-Signature' = "`$1`$$hash"
		
		if ('UseBasicParsing' -in (Get-Command Invoke-RestMethod).Parameters.Keys) {
			$properties.UseBasicParsing = $true
		}
		
		$response = Invoke-RestMethod @properties
		return $response
	}
	catch {
		Write-Error $_
	}
}