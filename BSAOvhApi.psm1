<#	
	===========================================================================
	 Created on:   	29/04/2021 10:35
	 Created by:   	Brice SARRAZIN
	 Organization: 	
	 Filename:     	BSAOvhApi.psm1
	-------------------------------------------------------------------------
	 Module Name: BSAOvhApi
	===========================================================================
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