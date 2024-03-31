<#
	.SYNOPSIS
		Sends an SMS with the OVH API.

	.DESCRIPTION
		The Send-BSAOvhSms function sends an SMS using the OVH API. It requires the application key, application secret, consumer key, service name, recipient numbers, message, and optional parameters such as sender name, priority, and history removal.

	.PARAMETER ApplicationKey
		Specifies the application key required for authentication with the OVH API.

	.PARAMETER ApplicationSecret
		Specifies the application secret required for authentication with the OVH API.

	.PARAMETER ConsumerKey
		Specifies the consumer key required for authentication with the OVH API.

	.PARAMETER ServiceName
		Specifies the name of the service associated with the SMS.

	.PARAMETER From
		Specifies the name of the sender. The default value is 'OVH'.

	.PARAMETER To
		Specifies an array of recipient numbers in international format. Example: @("+33600000001", "+33600000002")

	.PARAMETER Message
		Specifies the message to send.

	.PARAMETER Priority
		Specifies the priority of the SMS. Valid values are 'veryLow', 'low', 'medium', and 'high'. The default value is 'high'.

	.PARAMETER KeepHistory
		Specifies whether to remove the SMS from the OVH history. By default, the SMS is not removed.

	.EXAMPLE
		Send-BSAOvhSms -ApplicationKey 'your_app_key' -ApplicationSecret 'your_app_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name' -To @("+33600000001", "+33600000002") -Message 'Hello, World!' -Priority 'high' -KeepHistory

		This example sends an SMS using the specified application key, application secret, consumer key, service name, recipient numbers, message, priority, and keeps the SMS in the OVH history.

	.OUTPUTS
		The function returns the response from the OVH API, which includes information such as the SMS IDs, total credits removed, invalid receivers, and valid receivers.

	.NOTES
		Created by: Brice SARRAZIN
		Created on: 31/05/2021
		Filename: Remove-BSAOvhSms.ps1
#>

function Send-BSAOvhSms {
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
		[string]$ServiceName,
		[Parameter(Mandatory = $false,
			HelpMessage = 'Name of the sender. Example: OVH')]
		[string]$From = 'OVH',
		[Parameter(Mandatory = $true,
			HelpMessage = 'Numbers of the recipients in international format. Example: @("+33600000001", "+33600000002")')]
		[ValidatePattern('^\+(?:[0-9]\x20?){6,14}[0-9]$')]
		[array]$To,
		[Parameter(Mandatory = $true,
			HelpMessage = 'Message to send.')]
		[string]$Message,
		[Parameter(Mandatory = $false,
			HelpMessage = 'Priority of the SMS. Default: high')]
		[ValidateSet('veryLow', 'low', 'medium', 'high')]
		[string]$Priority = 'high',
		[Parameter(Mandatory = $false,
			HelpMessage = 'Remove the SMS from the OVH history. Default: $false')]
		[switch]$KeepHistory
	)
	
	Write-Verbose -Message 'Send-BSAOvhSms'

	try {
		$properties = @{
			ApplicationKey    = $ApplicationKey
			ApplicationSecret = $ApplicationSecret
			ConsumerKey       = $ConsumerKey
			Method            = 'POST'
			Path              = "/sms/$ServiceName/jobs"
			Body              = @{
				#charset	     = 'UTF-8' # not needed and source of errors
				sender            = $From
				receivers         = @($To)
				message           = $Message
				noStopClause      = $true
				priority          = $Priority
				senderForResponse = $false
			}
			ErrorAction       = 'Stop'
		}

		$response = Invoke-BSAOvhApiRequest @properties
		Write-Verbose -Message "response: $($response | Out-String)"

		# Remove the SMS from the OVH history
		if (!$KeepHistory) {
			if ($response.ids) {
				$properties = @{
					ApplicationKey    = $ApplicationKey
					ApplicationSecret = $ApplicationSecret
					ConsumerKey       = $ConsumerKey
					ServiceName       = $ServiceName
					SmsId             = $response.ids
					ErrorAction       = 'SilentlyContinue'
				}
				Remove-BSAOvhSms @properties | Out-Null
			}
		}

		<# EXEMPLE DE REPONSE
		ids                 : {308527665}       
		totalCreditsRemoved : 1 
		invalidReceivers    : {}
		validReceivers      : {+33600000001}            
		#>
		
		return $response
	}
	catch {
		Write-Error $_
	}
}