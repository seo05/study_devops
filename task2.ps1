$data=@(Get-Content $args[0])
$addPart="@abc.com"
foreach ($item in $data) {
    if (($item.Split(",") | Select-Object -Index 0) -eq "id") { # for header
        $item >> accounts_new.csv
    }
    else {   
        $id=$item.Split(",") | Select-Object -Index 0
        $location_id=$item.Split(",") | Select-Object -Index 1
        $oldname=$item.Split(",") | Select-Object -Index 2
        $name=((Get-Culture).TextInfo).ToTitleCase($oldname)
        if ($item -cmatch '"'){ #for "Manager, Commanding Officer" etc.
            $title=(($item.Split(",") | Select-Object -Index 3,4) -join ",")
            $department=$item.Split(",") | Select-Object -Index 6
        }
        else {
            $title=$item.Split(",") | Select-Object -Index 3
            $department=$item.Split(",") | Select-Object -Index 5
        }
        if ($item -cmatch '@'){ #for e.feeney@foobar.org etc.
            $email=$item.Split(",") | Select-Object -Index 4
        }
        else {
            if ($oldname -cmatch '-' ){ #for marilyn baker-"V"enturini
                $lowercase=(($oldname.Split(" ") | ForEach-Object { $_ -replace $_[0], $([char]::ToLower($_[0]))}) -join " " )
                $lowercase1=(($lowercase.Split("-") | ForEach-Object { $_ -replace $_[0], $([char]::ToLower($_[0]))}) -join "-" )
                $firstLetter=$lowercase1.Split(" ") | Select-Object -Index 0 | ForEach-Object { $_ -replace $_, $_[0]}
                $surname=$lowercase1.Split(" ") | Select-Object -Index 1
                $email=-join($firstLetter,$surname,$location_id,$addPart)
            }
            else {
                $lowercase=(($oldname.Split(" ") | ForEach-Object { $_ -replace $_[0], $([char]::ToLower($_[0]))}) -join " " )
                $firstLetter=$lowercase.Split(" ") | Select-Object -Index 0 | ForEach-Object { $_ -replace $_, $_[0]}
                $surname=$lowercase.Split(" ") | Select-Object -Index 1
                $email=-join($firstLetter,$surname,$location_id,$addPart)
            }
        }
    ($id,$location_id,$name,$title,$email,$department) -join "," >> accounts_new.csv
    }
}
