<#	
	.NOTES
	===========================================================================
	 Created on:   	31/05/2021 16:44
	 Created by:   	Brice SARRAZIN
	 Organization: 	
	 Filename:     	Get-BSAOvhOutgoingSms.ps1
	===========================================================================
	.DESCRIPTION
		Get outgoing SMS from the OVH API.
#>

function Get-BSAOvhOutgoingSms {
	[CmdletBinding()]
	param (
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
			Path              = "/sms/$ServiceName/outgoing"
			ErrorAction       = 'Stop'
		}
		
		Invoke-BSAOvhApiRequest @properties
	} catch {
		Write-Error $_
	}
}