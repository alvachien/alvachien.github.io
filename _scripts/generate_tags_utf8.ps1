# PowerShell script to generate tag pages with proper UTF-8 encoding

# Create tags directory if it doesn't exist
$tagsDir = "tags"
if (-not (Test-Path $tagsDir)) {
    New-Item -ItemType Directory -Path $tagsDir | Out-Null
}

# Clear existing tag files
Write-Host "Cleaning up existing tag files..."
Get-ChildItem $tagsDir -Filter "*.md" | Remove-Item -Force

# Get all markdown files in _posts directory
$postFiles = Get-ChildItem "_posts" -Recurse -Filter "*.md"

# Extract all unique tags (case-insensitive)
$tagDictionary = @{}

foreach ($file in $postFiles) {
    # Read file with UTF-8 encoding
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Look for tags in front matter (tags: [tag1, tag2, tag3])
    if ($content -match 'tags:\s*\[(.*?)\]') {
        $tagsLine = $matches[1]
        # Split by comma and clean up
        $tags = $tagsLine -split ',' | ForEach-Object { $_.Trim() }
        
        foreach ($tag in $tags) {
            if ($tag -ne "") {
                # Use case-insensitive comparison
                $normalizedTag = $tag.ToLower()
                if (-not $tagDictionary.ContainsKey($normalizedTag)) {
                    # Store the original case of the first occurrence
                    $tagDictionary[$normalizedTag] = $tag
                }
            }
        }
    }
}

# Get unique tags (preserving original case of first occurrence)
$uniqueTags = $tagDictionary.Values | Sort-Object

Write-Host "Found $($uniqueTags.Count) unique tags (case-insensitive)"

# Create tag pages
foreach ($tag in $uniqueTags) {
    # Create safe filename (handle characters invalid in Windows filenames)
    # Replace : ? * " < > | with underscores
    $safeFilename = $tag -replace '[:\?\*\"<>\|]', '_'
    $safeFilename = $safeFilename -replace '/', '-'
    $safeFilename = $safeFilename.Trim()
    
    # If filename is empty or too long, use a hash
    if ([string]::IsNullOrEmpty($safeFilename) -or $safeFilename.Length -gt 200) {
        $hash = [System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($tag))) -replace '-', ''
        $safeFilename = "tag-$hash"
    }
    
    $filename = "$safeFilename.md"
    $filepath = Join-Path $tagsDir $filename
    
    # Create front matter - use original tag name in permalink
    # URL encode the tag for the permalink
    $encodedTag = [System.Web.HttpUtility]::UrlEncode($tag)
    $frontMatter = @"
---
layout: tag
tag: $tag
permalink: "/tags/$encodedTag"
---
"@
    
    # Write to file with UTF-8 encoding (without BOM)
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($filepath, $frontMatter, $utf8NoBom)
    Write-Host "Created tag page: $filename for tag: $tag"
}

Write-Host "Done! Created $($uniqueTags.Count) tag pages with proper UTF-8 encoding."