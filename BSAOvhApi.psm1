<#	
	.SYNOPSIS
		This module contains functions for interacting with the OVH API.

	.DESCRIPTION
		The BSAOvhApi module is designed to provide a set of functions for interacting with the OVH API. It includes public and private functions that can be used to perform various tasks related to the OVH API, such as sending and receiving SMS messages, making API requests, and retrieving account information.

	.EXAMPLE
		# Import the module
		Import-Module BSAOvhApi

		# Call a function from the module
		Get-BSAOvhSmsAccountInformations -ApplicationKey 'your_application_key' -ApplicationSecret 'your_application_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name'

	.NOTES
		Author: Brice SARRAZIN
		Date Created: 29/04/2021
#>

[CmdletBinding()]
Param ()
Process {
	# Locate all the public and private function specific files
	[array]$publicFunctions = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public') -Filter '*.ps1' -ErrorAction SilentlyContinue
	[array]$privateFunctions = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Private') -Filter '*.ps1' -ErrorAction SilentlyContinue
	
	# Dot source the function files
	foreach ($functionFile in @($publicFunctions + $privateFunctions)) {
		try {
			. $functionFile.FullName -ErrorAction Stop
		}
		catch [System.Exception] {
			Write-Error -Message "Failed to import function '$($functionFile.FullName)' with error: $($_.Exception.Message)"
		}
	}
	
	Export-ModuleMember -Function $publicFunctions.BaseName -Alias *
}