$regFile = "C:\Github\PSRegistryParser\7zip.reg"
if (!(Test-Path $regFile)) {
  Write-Host 'Not a .reg file'
  Exit
}
    
$regFileKeys = [PSCustomObject]@{ }
[String]$tempKey = ""
[String]$tempProperty = ""
[String]$tempValue = ""
[String]$tempType = ""
Get-Content -Path $regFile | ForEach-Object {
  if ($_.StartsWith('`r`n')) {
    # skip line
    continue
  }
  elseif ($_.StartsWith('[')) {
    # save the new reg key
    $tempKey = $_.Trim('[', ']')
    $regFileKeys | Add-Member -MemberType NoteProperty -Name $tempKey -Value ([System.Collections.ArrayList]@())
  }
  elseif ($_.StartsWith('"')) {
    $tempProperty = $_.Split('=')[0].Trim('"')
    
    $value = ""
    if ($_.Split('=')[1].StartsWith('"')) {

    }
    elseif ($_.Split('=')[1].Contains(':'))

    $type = ""
    $regFileKeys.$tempKey.Add([PSCustomObject]@{
        'name'  = $tempProperty
        'value' = $value
        'type'  = $type
      })
  }
}

return $regFileKeys