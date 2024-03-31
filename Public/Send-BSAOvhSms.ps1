<#	
	.NOTES
	===========================================================================
	 Created on:   	31/05/2021 16:46
	 Created by:   	Brice SARRAZIN
	 Organization: 	
	 Filename:     	Remove-BSAOvhSms.ps1
	===========================================================================
	.DESCRIPTION
		Send an SMS with the OVH API.
#>


function Send-BSAOvhSms {
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
			HelpMessage = 'Saisir un numéro de téléphone international valide. Ex: +33123456789')]
		[ValidatePattern('^\+(?:[0-9]\x20?){6,14}[0-9]$')]
		[array]$To,
		[Parameter(Mandatory = $true)]
		[string]$Message,
		[ValidateSet('veryLow', 'low', 'medium', 'high')]
		[string]$Priority = 'high',
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