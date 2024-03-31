<#
	.DESCRIPTION
		Remove sent SMS from the OVH API.

	.PARAMETER ApplicationKey
		The application key for accessing the OVH API.

	.PARAMETER ApplicationSecret
		The application secret for accessing the OVH API.

	.PARAMETER ConsumerKey
		The consumer key for accessing the OVH API.

	.PARAMETER ServiceName
		The name of the service associated with the SMS.

	.PARAMETER SmsId
		Optional. An array of SMS identifiers to remove. Leave empty to remove all SMS.

	.EXAMPLE
		Remove-BSAOvhSms -ApplicationKey 'your_app_key' -ApplicationSecret 'your_app_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name' -SmsId 1234

	.EXAMPLE
		Remove-BSAOvhSms -ApplicationKey 'your_app_key' -ApplicationSecret 'your_app_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name'

	.NOTES
		Created on:   	31/05/2021
	 	Created by:   	Brice SARRAZIN
	 	Filename:     	Remove-BSAOvhSms.ps1		
#>

function Remove-BSAOvhSms {
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
		[string]$ServiceName,
		[Parameter(Mandatory = $false,
			HelpMessage = 'SMS identifiers to remove. Leave empty to remove all SMS.')]
		[int[]]$SmsId
	)

	$properties = @{
		ApplicationKey    = $ApplicationKey
		ApplicationSecret = $ApplicationSecret
		ConsumerKey       = $ConsumerKey
		Method            = 'DELETE'
		ErrorAction       = 'SilentlyContinue'
	}
	
	try {
		if ($PSBoundParameters['SmsId']) {
			# SmsId provided as parameter
			Write-Verbose -Message "SmsId: $(if ($SmsId.Count) { $SmsId -join ',' } else { 'null' })"
		}
		else {
			# Get all SMS identifiers
			Write-Verbose -Message 'SmsId: not provided'
			Write-Verbose -Message 'Get all SMS identifiers :'
			$SmsId = Get-BSAOvhOutgoingSms -ServiceName $ServiceName -ApplicationKey $ApplicationKey -ApplicationSecret $ApplicationSecret -ConsumerKey $ConsumerKey -ErrorAction Stop
			Write-Verbose -Message "$(if ($SmsId.Count) { $SmsId -join ',' } else { 'null' })"
		}
		
		foreach ($Id in $SmsId) {
			Write-Verbose -Message "Processing SMS $Id"
			$properties.Path = "/sms/$ServiceName/outgoing/$Id"
			$retry = 5
			do {
				$response = Invoke-BSAOvhApiRequest @properties
				if ($null -eq $response) {
					Write-Verbose "SMS id $Id deleted"
					Continue
				}
				Write-Verbose -Message "response: $response"
				$retry--
			} until ($response.Class -ne 'Client::BadRequest' -and $retry -gt 0)
		}

		return $true
	}
	catch {
		Write-Error $_
	}
}