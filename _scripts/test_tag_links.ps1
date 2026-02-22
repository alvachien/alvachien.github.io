# PowerShell script to test tag links consistency

Write-Host "Testing tag links consistency..." -ForegroundColor Green

# Check if tags directory exists
$tagsDir = "tags"
if (-not (Test-Path $tagsDir)) {
    Write-Host "ERROR: tags directory not found!" -ForegroundColor Red
    exit 1
}

# Get all tag files
$tagFiles = Get-ChildItem $tagsDir -Filter "*.md"

Write-Host "Found $($tagFiles.Count) tag files" -ForegroundColor Green

# Check each tag file
$errors = 0
foreach ($file in $tagFiles) {
    # Read file content
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Extract tag name from front matter
    if ($content -match 'tag:\s*(.+)') {
        $tagName = $matches[1].Trim()
        
        # Extract permalink from front matter
        if ($content -match 'permalink:\s*"/tags/(.+)"') {
            $permalinkTag = $matches[1].Trim()
            
            # Check if tag name matches permalink (they should be the same)
            if ($tagName -ne $permalinkTag) {
                Write-Host "WARNING: Mismatch in $($file.Name): tag='$tagName' vs permalink='$permalinkTag'" -ForegroundColor Yellow
                $errors++
            }
            
            # Check if filename is reasonable (no invalid characters)
            if ($file.Name -match '[<>:"/\\|?*]') {
                Write-Host "WARNING: Invalid characters in filename: $($file.Name)" -ForegroundColor Yellow
                $errors++
            }
        } else {
            Write-Host "ERROR: No permalink found in $($file.Name)" -ForegroundColor Red
            $errors++
        }
    } else {
        Write-Host "ERROR: No tag found in $($file.Name)" -ForegroundColor Red
        $errors++
    }
}

# Check home.html for tag links
Write-Host "`nChecking home.html for tag links..." -ForegroundColor Green
$homeContent = [System.IO.File]::ReadAllText("_layouts/home.html", [System.Text.Encoding]::UTF8)

# Count tag links in home.html (should match number of unique tags)
$tagLinkCount = ($homeContent | Select-String -Pattern 'href="[^"]*/tags/[^"]*"' -AllMatches).Matches.Count
Write-Host "Found $tagLinkCount tag links in home.html" -ForegroundColor Green

# Check for slugize filter (should not be present)
if ($homeContent -match 'slugize') {
    Write-Host "WARNING: home.html still contains 'slugize' filter" -ForegroundColor Yellow
    $errors++
}

# Summary
Write-Host "`n=== TEST SUMMARY ===" -ForegroundColor Cyan
Write-Host "Total tag files: $($tagFiles.Count)"
Write-Host "Tag links in home.html: $tagLinkCount"
Write-Host "Errors/Warnings: $errors"

if ($errors -eq 0) {
    Write-Host "`nAll tests passed! Tag links should work correctly." -ForegroundColor Green
} else {
    Write-Host "`nFound $errors issues that need attention." -ForegroundColor Yellow
}