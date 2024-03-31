<#	
	.NOTES
	===========================================================================
	 Created on:   	31/05/2021 16:46
	 Created by:   	Brice SARRAZIN
	 Organization: 	
	 Filename:     	Send-BSAOvhSmsBatches.ps1
	===========================================================================
	.DESCRIPTION
		Send SMS in batches with the OVH API.
#>

function Send-BSAOvhSmsBatches {
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
		[string]$ServiceName,
		[string]$From = 'OVH',
		[Parameter(Mandatory = $true,
			HelpMessage = 'Input phone numbers in international format (e.g. +33600000001, +33600000002)')]
		[ValidatePattern('^\+(?:[0-9]\x20?){6,14}[0-9]$')]
		[array]$To,
		[Parameter(Mandatory = $true)]
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