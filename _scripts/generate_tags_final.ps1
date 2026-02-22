# PowerShell script to generate tag pages - Final version matching Jekyll's behavior

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

# Simple function to approximate Jekyll's slugize for filenames
# Jekyll's slugize: downcase, replace spaces with hyphens, remove special chars
# But for Chinese, it keeps the characters
function Get-JekyllSlug {
    param([string]$inputString)
    
    # Convert to lowercase (only affects ASCII)
    $slug = $inputString.ToLower()
    
    # Replace spaces with hyphens
    $slug = $slug -replace '\s+', '-'
    
    # Remove or replace characters that are problematic in URLs
    # Keep Chinese characters, letters, numbers, hyphens
    # This is a simplified version
    return $slug
}

# Create tag pages
foreach ($tag in $uniqueTags) {
    # Create filename using the tag itself (like categories do)
    # But replace characters that are invalid in Windows filenames
    $filename = $tag
    
    # Replace characters invalid in Windows filenames
    $invalidChars = '[<>:"/\\|?*]'
    $filename = $filename -replace $invalidChars, '_'
    
    # Trim and ensure not empty
    $filename = $filename.Trim()
    if ([string]::IsNullOrEmpty($filename)) {
        $hash = [System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($tag))) -replace '-', ''
        $filename = "tag-$hash"
    }
    
    # Ensure filename ends with .md
    $filename = "$filename.md"
    $filepath = Join-Path $tagsDir $filename
    
    # Create front matter - use the tag as-is in permalink
    # Jekyll will handle URL encoding
    $frontMatter = @"
---
layout: tag
tag: $tag
permalink: "/tags/$tag"
---
"@
    
    # Write to file with UTF-8 encoding (without BOM)
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($filepath, $frontMatter, $utf8NoBom)
    Write-Host "Created tag page: $filename for tag: $tag"
}

Write-Host "Done! Created $($uniqueTags.Count) tag pages."