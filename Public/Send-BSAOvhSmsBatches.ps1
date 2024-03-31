<#
	.SYNOPSIS
		Sends SMS in batches with the OVH API.

	.DESCRIPTION
		The Send-BSAOvhSmsBatches function sends SMS in batches using the OVH API. It requires the application key, application secret, consumer key, service name, sender name, recipient numbers, and message as input parameters.

	.PARAMETER ApplicationKey
		Specifies the application key required for authentication with the OVH API.

	.PARAMETER ApplicationSecret
		Specifies the application secret required for authentication with the OVH API.

	.PARAMETER ConsumerKey
		Specifies the consumer key required for authentication with the OVH API.

	.PARAMETER ServiceName
		Specifies the name of the service to send the SMS batches.

	.PARAMETER From
		Specifies the name of the sender. The default value is 'OVH'.

	.PARAMETER To
		Specifies an array of recipient numbers in international format. Example: @("+33600000001", "+33600000002").

	.PARAMETER Message
		Specifies the message to send.

	.EXAMPLE
		Send-BSAOvhSmsBatches -ApplicationKey 'your_application_key' -ApplicationSecret 'your_application_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name' -From 'OVH' -To @("+33600000001", "+33600000002") -Message 'Hello, this is a test message.'

		This example sends an SMS batch using the specified application key, application secret, consumer key, service name, sender name, recipient numbers, and message.

	.NOTES
		Created by: Brice SARRAZIN
		Created on: 31/05/2021
		Filename: Send-BSAOvhSmsBatches.ps1
#>

function Send-BSAOvhSmsBatches {
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
		[string]$Message
	)
	
	try {	
		$properties = @{
			ApplicationKey    = $ApplicationKey
			ApplicationSecret = $ApplicationSecret
			ConsumerKey       = $ConsumerKey
			Method            = 'POST'
			Path              = "/sms/$ServiceName/batches"
			Body              = @{
				#charset	     = 'UTF-8' # visiblement inutile et source d'erreurs
				from              = $From
				to                = @($To)
				message           = $Message
				#name = "nom de la campagne SMS"
				noStop            = $true
				senderForResponse = $false
			}
			ErrorAction       = 'Stop'
		}

		$response = Invoke-BSAOvhApiRequest @properties
		
		<# Example of response:
		accountID        : 39155
		createdAt        : 2021-06-01T16:39:13+02:00
		errors           : {}
		estimatedCredits : 2
		finishedAt       :
		from             : from
		id               : 7a6a2c9e-31ff-43b1-ad3d-d4b0b1d24d2d
		message          : message to send
		name             : name of the batch
		processedRecords : 0
		receivers        : {+33600000001, +33600000002}
		sentAt           :
		slotID           :
		startedAt        :
		status           : PENDING
		totalRecords     : 2
		updatedAt        : 2021-06-01T16:39:13+02:00
		#>

		return $response
	}
 catch {
		Write-Error $_
	}
}