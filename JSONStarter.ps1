param(
    $ConfigPath=$(throw "ConfigPath is required"),
    [switch]$Test
    )

If (-not (Test-Path $ConfigPath)) {
    throw "$ConfigPath not found"
}
[string]$jsonString = Get-Content $ConfigPath -raw
$json = ConvertFrom-Json $jsonString
foreach ($script in $json.Script) {
    $command=$script.Command
    $ParamNames=($script.Params |Get-Member -MemberType NoteProperty).Name
    $ParamString=""
    foreach ($param in $script.Params) {
        $ParamString+=(" -{0} {1}" -f $param.Name,$param.Value)
    }
    $exp=("{0}{1}" -f $command,$ParamString)
    if ($Test) {
        Write-Host $exp
    } else {
        Invoke-Expression $exp
    }
}