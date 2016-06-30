function Send-HCRoomMessage {
	<#
	.SYNOPSIS
	Sends a message to a HipChat room using version 2 api
	.DESCRIPTION
	See synopsis.
	.EXAMPLE
	Send-HCRoomMessage -Message 'Hello world!' -RoomID 9999 -AuthToken 000000008c036ce74151407cad43256a6386b99b -Hostname api.hipchat.com
	.EXAMPLE
	Send-HCRoomMessage -Message '<p>Hello world!</p>' -RoomID 9999 -AuthToken 000000008c036ce74151407cad43256a6386b99b -MessageFormat HTML -Hostname api.hipchat.com
	.EXAMPLE
	Send-HCRoomMessage -Message 'Hello world!' -RoomID 9999 -AuthToken 000000008c036ce74151407cad43256a6386b99b -Colour green -Hostname api.hipchat.com
	.PARAMETER Hostname
	The name of host to connect to, this can be either an IP address or hostname
	.PARAMETER AuthToken
	You can get this by going to https://hipchatserver.blah/rooms/tokens/9999
	.PARAMETER RoomID
	The room ID number, look in the url to find this number when in chat
	.PARAMETER Message
	The message in either HTML or plain text to send
	.PARAMETER From
	An additional name to add to the from tag, note the API token name is always used regardless
	.PARAMETER Colour
	The message colour the default is yellow
	.PARAMETER Format
	The available formats are HTML or text
	.PARAMETER DisableCertCheck
	Disables checking the certificate when connecting over https
	.PARAMETER NoSSL
	Forces the use of HTTP instead of HTTPS
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)]
	    [Alias('host')]
        [string]$Hostname,
        [Parameter(Mandatory=$True)]
        [string]$AuthToken,
        [Parameter(Mandatory=$True)]
        [int]$RoomID,
		[string]$Message,
		[string]$From,
        [ValidateSet('yellow', 'green', 'red', 'purple', 'gray', 'random')]
        [string]$Colour='yellow',
        [ValidateSet('text','html')]
        [string]$Format='text',
        [switch]$DisableCertCheck,
        [switch]$NoSSL
	)
    
    # Setup the hipchat request
	begin {
        
        # Build header and data ready to send
        $Header = @{
                    'Content-type'= 'application/json'
                    Authorization="Bearer $AuthToken"
                    }
        $Data   = @{
                    message=$Message
                    from=$From
                    color=$Colour
                    message_format=$Format
                    } | ConvertTo-Json

        # Disable certificate check if asked
        if($DisableCertCheck){
        
            add-type @"
                using System.Net;
                using System.Security.Cryptography.X509Certificates;
                public class TrustAllCertsPolicy : ICertificatePolicy {
                    public bool CheckValidationResult(
                        ServicePoint srvPoint, X509Certificate certificate,
                        WebRequest request, int certificateProblem) {
                        return true;
                    }
                }
"@
            [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
        
        }

        # Build the URL
        if($NoSSL){
            
            $URL = "HTTP://$Hostname/v2/room/$RoomID/notification"

        }else{

            $URL = "HTTPS://$Hostname/v2/room/$RoomID/notification"

        }


	}
    
    # Connect to HipChat and send the message
	process {

        try{
            $null = Invoke-WebRequest -Headers $Header -Method Post -Body $Data -Uri $URL -ErrorAction Stop
        }
        catch{
            Write-Error "Unable to send message to HipChat - $_"
        }

	}
}