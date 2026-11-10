# Recreate the harness links that point at .agents\skills.
# Run from the repo root:  powershell -ExecutionPolicy Bypass -File setup-links.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$skills = @('cinecode', 'rea-video')

function Link($path, $target) {
  if (Test-Path $path) { cmd /c rmdir "$path" 2>$null }
  $parent = Split-Path -Parent $path
  if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  New-Item -ItemType Junction -Path $path -Target $target | Out-Null
  Write-Output ("  " + $path.Replace($root + '\', '') + "  ->  " + $target.Replace($root + '\', ''))
}

Write-Output 'links:'
Link (Join-Path $root '.agent') (Join-Path $root '.agents')
foreach ($h in @('.claude', '.cursor', '.opencode')) {
  foreach ($s in $skills) {
    Link (Join-Path $root "$h\skills\$s") (Join-Path $root ".agents\skills\$s")
  }
}
Write-Output 'done.'
