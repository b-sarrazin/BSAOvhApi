<#	
	.SYNOPSIS
		Get outgoing SMS from the OVH API.

	.DESCRIPTION
		This function retrieves outgoing SMS from the OVH API using the specified application key, application secret, consumer key, and service name.

	.PARAMETER ApplicationKey
		The application key required for authentication with the OVH API.

	.PARAMETER ApplicationSecret
		The application secret required for authentication with the OVH API.

	.PARAMETER ConsumerKey
		The consumer key required for authentication with the OVH API.

	.PARAMETER ServiceName
		The name of the service from which to retrieve outgoing SMS.

	.EXAMPLE
		Get-BSAOvhOutgoingSms -ApplicationKey 'your_application_key' -ApplicationSecret 'your_application_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name'

		This example demonstrates how to use the Get-BSAOvhOutgoingSms function to retrieve outgoing SMS from the OVH API.

	.NOTES
		Created on:   	31/05/2021
		Created by:   	Brice SARRAZIN
		Filename:     	Get-BSAOvhOutgoingSms.ps1
#>

function Get-BSAOvhOutgoingSms {
	[CmdletBinding()]
	param (
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
			Path              = "/sms/$ServiceName/outgoing"
			ErrorAction       = 'Stop'
		}
		
		Invoke-BSAOvhApiRequest @properties
	} catch {
		Write-Error $_
	}
}