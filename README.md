# HipChat
A HipChat module that makes use of the API version 2.

Currently a work in progress for now this only has the ability to send a message to a choosen room.

## Installing
This module can be installed from the [PowerShellGet Gallery](https://www.powershellgallery.com/packages/HipChat/),  You need [WMF 5](https://www.microsoft.com/en-us/download/details.aspx?id=44987) to use this feature.
```PowerShell
# To install HipChat, run the following command in the PowerShell prompt in Administrator mode:
Install-Module -Name HipChat
```

## Example
 Here is one example you can use the Get-Help to see more
 ```PowerShell
Send-HCRoomMessage -Hostname hipchatserver.test -AuthToken 123456789 -RoomID 9999 -Message 'Hello World' -Colour green -DisableCertCheck -From TestPerson
```
