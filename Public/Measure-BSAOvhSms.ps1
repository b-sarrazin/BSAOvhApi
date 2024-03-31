<#	
	.NOTES
	===========================================================================
	 Created on:   	31/05/2021 16:42
	 Created by:   	Brice SARRAZIN
	 Organization: 	
	 Filename:     	Invoke-BSAOvhApiRequest.ps1
	===========================================================================
	.DESCRIPTION
		Measures the cost of sending an SMS from the OVH API.
#>

function Measure-BSAOvhSms {
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
		[string]$Message
	)
	
	try {
		$properties = @{
			ApplicationKey    = $ApplicationKey
			ApplicationSecret = $ApplicationSecret
			ConsumerKey       = $ConsumerKey
			Method            = 'POST'
			Path              = '/sms/estimate'
			Body              = @{
				message      = $Message
				noStopClause = $true
				senderType   = 'alpha'
			}
			ErrorAction       = 'Stop'
		}
		
		Invoke-BSAOvhApiRequest @properties
	} catch {
		Write-Error $_
	}
}