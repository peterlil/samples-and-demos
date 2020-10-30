[CmdletBinding()]
param(
    [string] $Path,
    [string] $NuGetSource,
    [string] $Username,
    [string] $Password
)

if ($PSCmdlet.MyInvocation.BoundParameters["Debug"].IsPresent) 
{
     $DebugPreference = "Continue"
}
#2020-10-29T09:46:15.2788575Z Attempting to pack file: D:\a\1\s\PrivateNugetSample\MyVsLibrary.csproj
#2020-10-29T09:46:15.3096098Z [command]C:\hostedtoolcache\windows\NuGet\5.4.0\x64\nuget.exe pack D:\a\1\s\PrivateNugetSample\MyVsLibrary.csproj -NonInteractive -OutputDirectory D:\a\1\a -Properties Configuration=Release -version 1.0.2-CI-20201029-094615 -Verbosity Detailed

Write-Information -MessageData "Parsing and normalizing the path parameter. $Path"
$pathElements = ($Path -split "(\*\*)")
$pathElements | ForEach-Object {
    Write-Debug -Message "pathElement: $_"
}

$searchPath = Resolve-Path "."
$loopCount = 0
Write-Debug -Message "searchPath: $searchPath"
$recursive = $false
$pathElements | ForEach-Object {
    if($_.ToString().Length -gt 0) {
        if($_ -eq "**") {
            if($loopCount -eq 0) {
                $recursive = $true
            }
        } else {
            
            $searchPath = (Join-Path $searchPath $_)
            Write-Debug -Message "searchPath: $searchPath"
        }
        $loopCount++
    }
}

Write-Debug -Message "Recursive: $recursive"
Write-Debug -Message "searchPath: $searchPath"
$rootPath = ""
$searchPattern = ""

# Get position of first wildcard
$match = [regex]::match($searchPath,”[\*\?\[\!\#]”)
if( $match.Success -eq $true ) {
    $pathDir = $searchPath.Substring(0, $match.Index)
    Write-Debug -Message "pathDir: $pathDir"
    # Extract full path until wilcard
    $match = [regex]::match($searchPath,”[^\*\?\[!#]+(?![^\\\*\?\[!#]+(?=[\*\?\[!#]))”)
    if($match.Success -eq $false) {
        Write-Error -Message "Match unsuccessful for $($searchPath)"
    } else {
        Write-Debug -Message "Match count: $($match.Count)"
        $match | ForEach-Object {
            Write-Debug -Message "Match: $($_.Value)"
        }
        $rootPath = $match[0].Value
        $searchPattern = $searchPath.Substring($rootPath.Length)
    }
}

Write-Debug -Message "rootPath: $rootPath"
Write-Debug -Message "searchPattern: $searchPattern"
$nugetFiles = $null
if($recursive -eq $true) {
    $nugetFiles = Get-ChildItem -Path $rootPath -Include $searchPattern -Recurse
} else {
    $nugetFiles = Get-ChildItem -Path $rootPath -Include $searchPattern
}

$nugetFiles | ForEach-Object {
    Write-Verbose -Message "Found package $_"
}

$SourceName = (New-Guid).ToString()

nuget.exe sources Add `
    -Name $SourceName `
    -Source $NuGetSource `
    -username $Username `
    -password $Password

nuget.exe `
    setapikey "$($Username):$Password" `
    -Source $SourceName

$nugetFiles | ForEach-Object {
    Write-Verbose -Message "Pushing package $_"
    nuget.exe `
        push $_  `
        -Source $SourceName
}




