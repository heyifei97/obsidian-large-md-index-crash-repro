param(
    [string]$VaultPath = (Join-Path (Split-Path -Parent $PSScriptRoot) "repro-vault"),
    [int[]]$SizesMb = @(38, 9, 9, 8, 8, 7, 6, 6)
)

$ErrorActionPreference = "Stop"

$taskDir = Join-Path $VaultPath "large-md-tasks\tasks"
New-Item -ItemType Directory -Path $taskDir -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $VaultPath ".obsidian") -Force | Out-Null

[System.IO.File]::WriteAllText((Join-Path $VaultPath ".obsidian\app.json"), "{}", [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $VaultPath ".obsidian\community-plugins.json"), "[]", [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $VaultPath "Welcome.md"), "# Obsidian Large Markdown Repro Vault`n", [System.Text.UTF8Encoding]::new($false))

$paragraph = @"
## Synthetic task transcript

This is synthetic text generated to reproduce an indexing problem with very large Markdown files.
It contains no private user data. The paragraph is intentionally repeated many times.

- Item: DataCenterAirSys synthetic note content
- Item: Modelica synthetic note content
- Item: Obsidian indexing synthetic note content

"@

for ($i = 0; $i -lt $SizesMb.Count; $i++) {
    $sizeMb = $SizesMb[$i]
    $fileName = ("large-task-{0:D2}-{1}MB.md" -f ($i + 1), $sizeMb)
    $path = Join-Path $taskDir $fileName
    $targetBytes = [int64]$sizeMb * 1MB

    $writer = [System.IO.StreamWriter]::new($path, $false, [System.Text.UTF8Encoding]::new($false))
    try {
        $writer.WriteLine("# Synthetic Large Markdown File {0}" -f ($i + 1))
        $writer.WriteLine()
        while ($writer.BaseStream.Length -lt $targetBytes) {
            $writer.Write($paragraph)
        }
    }
    finally {
        $writer.Dispose()
    }

    Write-Host ("Generated {0} ({1:N2} MB)" -f $path, ((Get-Item -LiteralPath $path).Length / 1MB))
}

Write-Host ""
Write-Host "Repro vault ready:"
Write-Host $VaultPath
