param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'

$patterns = @(
  @{ Name = 'OpenAI key'; Regex = 'sk-[A-Za-z0-9_-]{20,}' },
  @{ Name = 'GitHub token'; Regex = 'gh[pousr]_[A-Za-z0-9_]{20,}' },
  @{ Name = 'Bearer token'; Regex = 'Bearer\s+[A-Za-z0-9._-]{20,}' },
  @{ Name = 'Feishu webhook'; Regex = 'open\.feishu\.cn/open-apis/bot/v2/hook/[A-Za-z0-9-]+' },
  @{ Name = 'Windows absolute path'; Regex = '[A-Za-z]:\\Users\\|[A-Za-z]:\\ObsidianVaults\\|[A-Za-z]:\\sync-obsidian-feishu\\' },
  @{ Name = 'Private vault path'; Regex = '04\.我的上下文|07\.发布作品|00\.系统配置|个人自传|我的用户画像' },
  @{ Name = 'Environment assignment'; Regex = '(OPENAI_API_KEY|ANTHROPIC_API_KEY|GITHUB_TOKEN|FEISHU|WEBHOOK)\s*=' }
)

$blockedDirs = @('.git', '.obsidian', '.claude', '.codex', '.agents', 'logs', 'archives', 'reports', 'private', 'customer-data')
$findings = New-Object System.Collections.Generic.List[object]

Get-ChildItem -LiteralPath $Root -Recurse -Force -File | ForEach-Object {
  $file = $_
  $relative = Resolve-Path -LiteralPath $file.FullName -Relative
  if ($relative -match '(^|[\\/])\.git([\\/]|$)') {
    return
  }
  if ($file.Name -eq 'sanitize-check.ps1') {
    return
  }
  foreach ($dir in $blockedDirs) {
    if ($relative -match "(^|[\\/])$([Regex]::Escape($dir))([\\/]|$)") {
      $findings.Add([pscustomobject]@{
        Severity = 'high'
        Type = 'blocked directory'
        Path = $relative
        Line = ''
        Match = $dir
      })
    }
  }

  $text = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
  foreach ($pattern in $patterns) {
    $matches = [regex]::Matches($text, $pattern.Regex, [Text.RegularExpressions.RegexOptions]::IgnoreCase)
    foreach ($match in $matches) {
      $lineNumber = ($text.Substring(0, $match.Index) -split "`r?`n").Count
      $findings.Add([pscustomobject]@{
        Severity = 'high'
        Type = $pattern.Name
        Path = $relative
        Line = $lineNumber
        Match = $match.Value
      })
    }
  }
}

if ($findings.Count -gt 0) {
  $findings | Format-Table -AutoSize
  Write-Error "Sanitize check failed: $($findings.Count) finding(s)."
}

Write-Host "Sanitize check passed for $Root"
