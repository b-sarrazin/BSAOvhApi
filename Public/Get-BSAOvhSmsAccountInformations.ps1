<#	
	.DESCRIPTION
		Get SMS account information from the OVH API.
	
	.PARAMETER ApplicationKey
		The application key required for authentication with the OVH API.
	
	.PARAMETER ApplicationSecret
		The application secret required for authentication with the OVH API.
	
	.PARAMETER ConsumerKey
		The consumer key required for authentication with the OVH API.
	
	.PARAMETER ServiceName
		The name of the service for which to retrieve SMS account information.
	
	.EXAMPLE
		Get-BSAOvhSmsAccountInformations -ApplicationKey 'your_app_key' -ApplicationSecret 'your_app_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name'
		Retrieves the SMS account information for the specified service.

	.NOTES
		Created on:   	31/05/2021
		Created by:   	Brice SARRAZIN
		Filename:     	Get-BSAOvhSmsAccountInformations.ps1
#>

function Get-BSAOvhSmsAccountInformations {
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
			HelpMessage = 'Service name.')]
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