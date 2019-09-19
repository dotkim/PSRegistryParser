# PSRegistryParser

## Usage

`Import-Module path-to-parseRegistryFile.psm1`

```powershell
$obj = Start-ParseRegFile -regFile "path to .reg file"

# You can make the reg file into a json file with:
$obj | ConvertTo-Json -Depth 3 -Compress

#You can also see what properties are in the first object with
$obj | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name
```

## Returned Structure

The structure of the returned object looks like this:

```powershell
[PSCustomObject]@{
  "key" = [System.Collections.Arraylist]@(
    [PSCustomObject]@{
      "name" = "PropertyName"
      "value" = "PropertyValue"
      "type" = "PropertyType"
    },
    [PSCustomObject]@{
      "name" = "PropertyName"
      "value" = "PropertyValue"
      "type" = "PropertyType"
    }
  )
}
```
