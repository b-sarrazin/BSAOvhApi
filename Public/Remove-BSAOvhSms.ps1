<#	
	.NOTES
	===========================================================================
	 Created on:   	31/05/2021 16:46
	 Created by:   	Brice SARRAZIN
	 Organization: 	
	 Filename:     	Remove-BSAOvhSms.ps1
	===========================================================================
	.DESCRIPTION
		Remove sent SMS from the OVH API.
#>

function Remove-BSAOvhSms {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]$ApplicationKey,
		[Parameter(Mandatory = $true)]
		[string]$ApplicationSecret,
		[Parameter(Mandatory = $true)]
		[string]$ConsumerKey,
		[Parameter(Mandatory = $true)]
		[string]$ServiceName,
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