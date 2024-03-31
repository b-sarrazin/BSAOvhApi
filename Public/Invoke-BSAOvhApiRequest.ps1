<#	
	.NOTES
	===========================================================================
	 Created on:   	31/05/2021 16:42
	 Created by:   	Brice SARRAZIN
	 Organization: 	
	 Filename:     	Invoke-BSAOvhApiRequest.ps1
	===========================================================================
	.DESCRIPTION
		Invoke an OVH API request.
#>

function Invoke-BSAOvhApiRequest {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$ApplicationKey,
		[Parameter(Mandatory = $true)]
		[string]$ApplicationSecret,
		[Parameter(Mandatory = $true)]
		[string]$ConsumerKey,
		[string]$Url = 'https://eu.api.ovh.com/1.0',
		[Parameter(Mandatory = $true)]
		[string]$Path,
		[ValidateSet('DELETE', 'GET', 'POST', 'PUT')]
		[Parameter(Mandatory = $true)]
		[string]$Method,
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