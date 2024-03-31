<#	
	.NOTES
	===========================================================================
	 Created on:   	31/05/2021 16:45
	 Created by:   	Brice SARRAZIN
	 Organization: 	
	 Filename:     	Get-BSAOvhSmsAccountInformations.ps1
	===========================================================================
	.DESCRIPTION
		Get SMS account information from the OVH API.
#>

function Get-BSAOvhSmsAccountInformations {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$ApplicationKey,
		[Parameter(Mandatory = $true)]
		[string]$ApplicationSecret,
		[Parameter(Mandatory = $true)]
		[string]$ConsumerKey,
		[Parameter(Mandatory = $true)]
		[string]$ServiceName
	)
	
	try {
		$properties = @{
			ApplicationKey    = $ApplicationKey
			ApplicationSecret = $ApplicationSecret
			ConsumerKey       = $ConsumerKey
			Method            = 'GET'
			Path              = "/sms/$ServiceName"
			ErrorAction       = 'Stop'
		}
		
		Invoke-BSAOvhApiRequest @properties
	} catch {
		Write-Error $_
	}
}