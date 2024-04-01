# BSAOvhApi

Module to interact with the OVH API

## Getting Started

### OVH API Access
Follow this link https://docs.ovh.com/gb/en/customer/first-steps-with-ovh-api/ to create an Application Key, Application Secret and get your Consumer Key.

### Prerequisites

* Windows 7+ / Windows Server 2003+
* PowerShell v3+

### Installation

You can install this module from the PowerShell Gallery.
```powershell
Install-Module -Name BSAOvhApi
```

## Description

This modules contains some functions to interact with the OVH API.
For example, if you want to send SMS via the OVH API, you can use the Send-BSAOvhSms function.
If you don't find the function you need, you can use the Invoke-BSAOvhApi function to interact with other OVH API services. Or you can create a new function and commit it to this repository.

## Example

Send SMS via OVH API
```powershell
Send-BSAOvhSms -ApplicationKey 'your_application_key' -ApplicationSecret 'your_application_secret' -ConsumerKey 'your_consumer_key' -From 'My Company' -To '+33612345678' -Message 'Hello World'
```

## Authors

* **Brice Sarrazin**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* OVH API documentation: https://api.ovh.com/console/