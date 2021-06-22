    param (
        [Parameter(Mandatory, Position=0)]
        [ValidatePattern("^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$")] 
        [string]$ip_address_1, 

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullorEmpty()]
        [ValidatePattern("^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$")]
        [string]$ip_address_2,  

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullorEmpty()]
        [ValidatePattern("^([0-9]|[1-2][0-9]|30){1}$")]
        [int]$network_mask 
    )
            $mask = (-bnot [uint32]0) -shl (32 — $network_mask) 
            [uint32[]]$arrIp1=$ip_address_1.split(".") #array e.g. 192 168 100 200
            [uint32]$Ip1=($arrIp1[0] -shl 24) + ($arrIp1[1] -shl 16) + ($arrIp1[2] -shl 8) + $arrIp1[3] #shift bits left
            [uint32[]]$arrIp2=$ip_address_2.split(".")
            [uint32]$Ip2=($arrIp2[0] -shl 24) + ($arrIp2[1] -shl 16) + ($arrIp2[2] -shl 8) + $arrIp2[3]
            $network_addr1=($mask -band $Ip1) # bitwise and
            $network_addr2=($mask -band $Ip2)
            if ($network_addr1 -eq $network_addr2) {
                write-host "ip addresses belong to the same network"
            }
            else {
                write-host "ip addresses do not belong to the same network"
            }
        
       
