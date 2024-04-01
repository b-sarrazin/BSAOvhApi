<#	
	.SYNOPSIS
	Module to interact with the OVH API.

	.DESCRIPTION
	This module provides functionality to interact with the OVH API. It includes functions for sending and receiving SMS, making API requests, and retrieving account information.

	.NOTES
	Created on:    29/04/2021
	Created by:    Brice SARRAZIN
	Organization:  

	.LINK
	GitHub Repository: https://github.com/bsarrazin/BSAOvhApi

	.EXAMPLE
	# Import the module
	Import-Module BSAOvhApi

	# Send an SMS
	Send-BSAOvhSms -ApplicationKey 'your_application_key' -ApplicationSecret 'your_application_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name' -To @("+33600000001", "+33600000002") -Message 'Hello, World!'

	.EXAMPLE
	# Get outgoing SMS messages
	Get-BSAOvhOutgoingSms -ApplicationKey 'your_application_key' -ApplicationSecret 'your_application_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name'

	.EXAMPLE
	# Get account information
	Get-BSAOvhSmsAccountInformations -ApplicationKey 'your_application_key' -ApplicationSecret 'your_application_secret' -ConsumerKey 'your_consumer_key' -ServiceName 'your_service_name'
#>

@{
	# Script module or binary module file associated with this manifest
	RootModule = 'BSAOvhApi.psm1'

	# Version number of this module.
	ModuleVersion = '1.0.0.2'

	# ID used to uniquely identify this module
	GUID = '8c5a2606-6b9b-4085-b3e8-f580cda2787f'

	# Author of this module
	Author = 'Brice SARRAZIN'

	# Company or vendor of this module
	CompanyName = ''

	# Copyright statement for this module
	Copyright = '(c) 2021. All rights reserved.'

	# Description of the functionality provided by this module
	Description = 'Module to interact with the OVH API'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '3.0'

	# Name of the Windows PowerShell host required by this module
	PowerShellHostName = ''

	# Minimum version of the Windows PowerShell host required by this module
	PowerShellHostVersion = ''

	# Minimum version of the .NET Framework required by this module
	DotNetFrameworkVersion = '2.0'

	# Minimum version of the common language runtime (CLR) required by this module
	CLRVersion = '2.0.50727'

	# Processor architecture (None, X86, Amd64, IA64) required by this module
	ProcessorArchitecture = 'None'

	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @()

	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies = @()

	# Script files (.ps1) that are run in the caller's environment prior to
	# importing this module
	ScriptsToProcess = @()

	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess = @()

	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @()

	# Modules to import as nested modules of the module specified in
	# ModuleToProcess
	NestedModules = @()

	# Functions to export from this module
	FunctionsToExport = @(
		'Get-BSAOvhOutgoingSms',
		'Get-BSAOvhSmsAccountInformations',
		'Invoke-BSAOvhApiRequest',
		'Measure-BSAOvhSms',
		'Remove-BSAOvhSms',
		'Send-BSAOvhSms',
		'Send-BSAOvhSmsBatches'
	) # For performance, list functions explicitly

	# Cmdlets to export from this module
	CmdletsToExport = '*'

	# Variables to export from this module
	VariablesToExport = '*'

	# Aliases to export from this module
	AliasesToExport = '*' # For performance, list alias explicitly

	# DSC class resources to export from this module.
	#DSCResourcesToExport = ''

	# List of all modules packaged with this module
	ModuleList = @()

	# List of all files packaged with this module
	FileList = @()

	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		# Support for PowerShellGet galleries.
		PSData = @{
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('OVH', 'API')

			# A URL to the license for this module.
			LicenseUri = 'https://github.com/b-sarrazin/BSAOvhApi/blob/main/LICENSE.md'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/b-sarrazin/BSAOvhApi'

			# A URL to an icon representing this module.
			IconUri = 'https://raw.githubusercontent.com/b-sarrazin/BSAOvhApi/main/logo.png'

			# ReleaseNotes of this module
			ReleaseNotes = 'https://github.com/b-sarrazin/BSAOvhApi/releases'
		}
	}
}