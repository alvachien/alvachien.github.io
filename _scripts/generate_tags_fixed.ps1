# PowerShell script to generate tag pages for Jekyll blog - Fixed version

# Create tags directory if it doesn't exist
$tagsDir = "tags"
if (-not (Test-Path $tagsDir)) {
    New-Item -ItemType Directory -Path $tagsDir | Out-Null
}

# Get all markdown files in _posts directory
$postFiles = Get-ChildItem "_posts" -Recurse -Filter "*.md"

# Extract all unique tags (case-insensitive)
$tagDictionary = @{}

foreach ($file in $postFiles) {
    $content = Get-Content $file.FullName -Raw
    
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
    # Create filename (handle special characters)
    # Replace characters that are invalid in filenames
    $filename = $tag -replace '[<>:"/\\|?*]', '_'
    $filename = "$filename.md"
    $filepath = Join-Path $tagsDir $filename
    
    # Create front matter
    $frontMatter = @"
---
layout: tag
tag: $tag
permalink: "/tags/$tag"
---
"@
    
    # Write to file with UTF8 encoding (without BOM for PowerShell 5.1)
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($filepath, $frontMatter, $utf8NoBom)
    Write-Host "Created tag page: $filename"
}

Write-Host "Done! Created $($uniqueTags.Count) tag pages."