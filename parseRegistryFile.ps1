function Start-ParseRegFile {
  <#
    .Start-ParseRegFile
    Parameters: regFile
  #>
  param (
    [String]$regFile
  )
  
  if (!(Test-Path $regFile)) {
    Write-Host 'Not a .reg file'
    Return 0
  }
  
  $regFileKeys = [PSCustomObject]@{ }
  [String]$tempKey = ""
  [String]$tempProperty = ""
  [String]$tempValue = ""
  [String]$tempType = ""
  $regFileContent = Get-Content -Path $regFile
  $regFileContent | ForEach-Object {
    if ($_ -eq "`n") {
      # skip line
      Write-Host 'skip'
      return
    }
    elseif ($_.StartsWith('[')) {
      # save the new reg key
      $tempKey = $_.Trim('[', ']')
      $regFileKeys | Add-Member -MemberType NoteProperty -Name $tempKey -Value ([System.Collections.ArrayList]@())
    }
    elseif ($_.StartsWith('"')) {
      $tempProperty = $_.Split('=')[0].Trim('"')
      
      if ($_.Split('=')[1].StartsWith('"')) {
        $tempValue = $_.Split('=')[1].Trim('"')
        $tempType = 'String'
      }
      elseif ($_.Split('=')[1].Contains(':')) {
        if ($_.Split('=')[1].EndsWith('\')) {
          $tempValue = $_.Split('=')[1].Split(':')[1].Trim('\')
          $tempType = $_.Split('=')[1].Split(':')[0]
          Write-Host 'skip'
          return
        }
      }
      $tempValue = $_.Split('=')[1].Split(':')[1]
      $tempType = $_.Split('=')[1].Split(':')[0]
      
      $regFileKeys.$tempKey.Add([PSCustomObject]@{
          'name'  = $tempProperty
          'value' = $tempValue
          'type'  = $tempType
        })
      
      $tempProperty = ""
      $tempValue = ""
      $tempType = ""
    }
    elseif ($tempValue -ne "") {
      if ($_.EndsWith('\')) {
        $tempValue += $_.TrimStart('  ').Trim('\')
        Write-Host 'skip'
        return
      }
      $tempValue += $_.TrimStart('  ')
      
      $regFileKeys.$tempKey.Add([PSCustomObject]@{
          'name'  = $tempProperty
          'value' = $tempValue
          'type'  = $tempType
        })
      
      $tempProperty = ""
      $tempValue = ""
      $tempType = ""
    }
    else {
      Write-Host $_
    }
  }
  
  return $regFileKeys
}
 
$regFile = "C:\Github\PSRegistryParser\test.reg"

$obj = Start-ParseRegFile -regFile $regFile
$obj | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name
$obj