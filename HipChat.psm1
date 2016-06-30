"$(Split-Path -Path $MyInvocation.MyCommand.Path)\Functions\*.ps1" | Resolve-Path | % { . $_.ProviderPath }

# create an alias
New-Alias hcmsg Send-HCRoomMessage