# PowerShell script to generate tag pages for Jekyll blog

# Create tags directory if it doesn't exist
$tagsDir = "tags"
if (-not (Test-Path $tagsDir)) {
    New-Item -ItemType Directory -Path $tagsDir | Out-Null
}

# Get all markdown files in _posts directory
$postFiles = Get-ChildItem "_posts" -Recurse -Filter "*.md"

# Extract all unique tags
$allTags = @()

foreach ($file in $postFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Look for tags in front matter (tags: [tag1, tag2, tag3])
    if ($content -match 'tags:\s*\[(.*?)\]') {
        $tagsLine = $matches[1]
        # Split by comma and clean up
        $tags = $tagsLine -split ',' | ForEach-Object { $_.Trim() }
        $allTags += $tags
    }
}

# Get unique tags
$uniqueTags = $allTags | Sort-Object | Get-Unique

Write-Host "Found $($uniqueTags.Count) unique tags"

# Create tag pages
foreach ($tag in $uniqueTags) {
    # Create filename (replace special characters if needed)
    $filename = "$tag.md"
    $filepath = Join-Path $tagsDir $filename
    
    # Create front matter
    $frontMatter = @"
---
layout: tag
tag: $tag
permalink: "/tags/$tag"
---
"@
    
    # Write to file
    Set-Content -Path $filepath -Value $frontMatter -Encoding UTF8
    Write-Host "Created tag page: $filename"
}

Write-Host "Done! Created $($uniqueTags.Count) tag pages."