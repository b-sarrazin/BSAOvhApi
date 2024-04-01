# BSAOvhApi

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com) [![PowerShell Gallery](https://img.shields.io/powershellgallery/v/BSAOvhApi.svg)](https://www.powershellgallery.com/packages/BSAOvhApi) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 

Module to interact with the OVH API

## Description

This modules contains some functions to interact with the OVH API.
For example, if you want to send SMS via the OVH API, you can use the Send-BSAOvhSms function.

If you don't find the function you need, you can use the Invoke-BSAOvhApi generic function to interact with other OVH API services. Or you can create a new function and commit it to this repository.

## Get started

### Prerequisites

* Windows 7+ / Windows Server 2003+
* PowerShell v3+
* OVH account with API access

### OVH API Access

Follow this link https://docs.ovh.com/gb/en/customer/first-steps-with-ovh-api/ to create an Application Key, Application Secret and get your Consumer Key.

### Installation

You can install this module from the PowerShell Gallery.
```powershell
Install-Module -Name BSAOvhApi
```

### Usage

Send SMS via OVH API
```powershell
Send-BSAOvhSms -ApplicationKey 'your_application_key' -ApplicationSecret 'your_application_secret' -ConsumerKey 'your_consumer_key' -From 'My Company' -To '+33612345678' -Message 'Hello World'
```

## Authors

* **Brice Sarrazin** - *Initial work*

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* OVH API documentation: https://api.ovh.com/console/
