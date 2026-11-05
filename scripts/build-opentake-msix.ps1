param(
    [Parameter(Mandatory)][string]$AppDirectory,
    [Parameter(Mandatory)][string]$OutputPath
)
$ErrorActionPreference = 'Stop'
$app = (Resolve-Path -LiteralPath $AppDirectory).Path
$output = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
$signature = Get-AuthenticodeSignature -LiteralPath (Join-Path $app 'OpenTake.exe')
if ($signature.Status -ne 'Valid' -or -not $signature.SignerCertificate) {
    throw 'The OpenTake executable must be signed before MSIX packaging.'
}
$publisher = [Security.SecurityElement]::Escape($signature.SignerCertificate.Subject)
$version = (Get-Content -Raw package.json | ConvertFrom-Json).version
if ($version -notmatch '^\d+\.\d+\.\d+$') { throw "Unsupported MSIX version: $version" }
$version = "$version.0"
$sdk = Join-Path ${env:ProgramFiles(x86)} 'Windows Kits/10/bin'
$makeAppx = Get-ChildItem -LiteralPath $sdk -Filter makeappx.exe -Recurse |
    Where-Object { $_.Directory.Name -eq 'x64' } |
    Sort-Object FullName -Descending |
    Select-Object -First 1
if (-not $makeAppx) { throw 'Windows SDK MakeAppx was not found.' }

$stage = Join-Path ([IO.Path]::GetTempPath()) "opentake-msix-$([guid]::NewGuid())"
New-Item -ItemType Directory -Path $stage | Out-Null
try {
    Copy-Item -Path (Join-Path $app '*') -Destination $stage -Recurse -Force
    Copy-Item -LiteralPath 'build/opentake-msix' -Destination (Join-Path $stage 'Assets') -Recurse
    @"
<?xml version="1.0" encoding="utf-8"?>
<Package xmlns="http://schemas.microsoft.com/appx/manifest/foundation/windows10"
         xmlns:uap="http://schemas.microsoft.com/appx/manifest/uap/windows10"
         xmlns:rescap="http://schemas.microsoft.com/appx/manifest/foundation/windows10/restrictedcapabilities"
         IgnorableNamespaces="uap rescap">
  <Identity Name="Ashbi.OpenTake" Publisher="$publisher" Version="$version" ProcessorArchitecture="x64" />
  <Properties>
    <DisplayName>OpenTake</DisplayName>
    <PublisherDisplayName>Cameron Ashley</PublisherDisplayName>
    <Logo>Assets\StoreLogo.png</Logo>
  </Properties>
  <Dependencies>
    <TargetDeviceFamily Name="Windows.Desktop" MinVersion="10.0.19041.0" MaxVersionTested="10.0.26100.0" />
  </Dependencies>
  <Resources><Resource Language="en-US" /></Resources>
  <Applications>
    <Application Id="OpenTake" Executable="OpenTake.exe" EntryPoint="Windows.FullTrustApplication">
      <uap:VisualElements DisplayName="OpenTake" Description="Screen recorder and video editor"
        BackgroundColor="#172D24" Square150x150Logo="Assets\Square150x150Logo.png"
        Square44x44Logo="Assets\Square44x44Logo.png" />
    </Application>
  </Applications>
  <Capabilities><rescap:Capability Name="runFullTrust" /></Capabilities>
</Package>
"@ | Set-Content -LiteralPath (Join-Path $stage 'AppxManifest.xml') -Encoding utf8
    & $makeAppx.FullName pack /d $stage /p $output /o
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $output)) { throw 'MakeAppx failed.' }
}
finally {
    Remove-Item -LiteralPath $stage -Recurse -Force
}
