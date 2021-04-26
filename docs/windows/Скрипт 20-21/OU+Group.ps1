Import-Module ActiveDirectory
Import-Csv -Delimiter ";" C:\Users.csv | ForEach-Object {if ($_.OU -ne $curOU) {
        New-ADOrganizationalUnit -Name $_.OU -Path "DC=skill39,DC=wsr"
        New-ADGroup -Name $_.OU -GroupCategory Security -GroupScope Global -Path ("OU=" + $_.OU + ",DC=skill39,DC=wsr")
        $curOU=$_.OU
    }
}