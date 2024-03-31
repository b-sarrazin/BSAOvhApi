<#	
	.DESCRIPTION
		Measures the cost of sending an SMS from the OVH API.
	
	.PARAMETER ApplicationKey
		The application key required for authentication with the OVH API.
	
	.PARAMETER ApplicationSecret
		The application secret required for authentication with the OVH API.
	
	.PARAMETER ConsumerKey
		The consumer key required for authentication with the OVH API.
	
	.PARAMETER Message
		The message to be measured for cost estimation.

	.NOTES
		Created on:   	31/05/2021
	 	Created by:   	Brice SARRAZIN
	 	Filename:     	Invoke-BSAOvhApiRequest.ps1
#>

function Measure-BSAOvhSms {
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
		[Parameter(Mandatory = $true,
			HelpMessage = 'Message to measure.')]
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