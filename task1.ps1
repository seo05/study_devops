param (
    [Parameter()]
    $ip_address_1,
    $ip_address_2,
    $network_mask 
)
$ipregex=[regex]'^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$'
$fullmaskregex=[regex]'^([0-9]|[1-2][0-9]|3[0-2]){1}$|([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$'
$maskregex=[regex]'^([0-9]|[1-2][0-9]|3[0-2]){1}$'
if ($null -eq $network_mask -or $null -eq $ip_address_1 -or $null -eq $ip_address_2){
    write-host "not all arguments are specified" -ForegroundColor Red
    exit
}
if ($ip_address_1 -notmatch $ipregex){
    write-host "invalid ip_address_1 >$ip_address_1<" -ForegroundColor Red
    exit
}
if ($ip_address_2 -notmatch $ipregex){
    write-host "invalid ip_address_2 >$ip_address_2<" -ForegroundColor Red
    exit
}
if ($network_mask -notmatch $fullmaskregex){
    write-host "invalid netmask >$network_mask<" -ForegroundColor Red
    exit
}
if ($network_mask -match $maskregex) {    
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
        write-host "ip addresses do Not belong to the same network"
    }
}
else {
    [uint32[]]$arrMask=$network_mask.split(".")
    [uint32]$mask=($arrMask[0] -shl 24) + ($arrMask[1] -shl 16) + ($arrMask[2] -shl 8) + $arrMask[3]
    $bimask=[System.Convert]::ToString($mask,2) # make  to 11111111111111111111111100000000
    if ($bimask.contains("01") ) {
        write-host  "invalid netmask >>$network_mask<<" -ForegroundColor Red 
        exit
    }
    [uint32[]]$arrIp1=$ip_address_1.split(".")
    [uint32]$Ip1=($arrIp1[0] -shl 24) + ($arrIp1[1] -shl 16) + ($arrIp1[2] -shl 8) + $arrIp1[3] 
    [uint32[]]$arrIp2=$ip_address_2.split(".")
    [uint32]$Ip2=($arrIp2[0] -shl 24) + ($arrIp2[1] -shl 16) + ($arrIp2[2] -shl 8) + $arrIp2[3]
    $network_addr1=($mask -band $Ip1) 
    $network_addr2=($mask -band $Ip2)
    if ($network_addr1 -eq $network_addr2) {
        write-host "ip addresses belong to the same network"
    }
    else {
        write-host "ip addresses do Not belong to the same network"
    }
}   
