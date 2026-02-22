# PowerShell script to generate tag pages for Jekyll blog - Slugized version

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

# Simple slugize function (approximation of Jekyll's slugize)
function Get-SlugizedString {
    param([string]$inputString)
    
    # Convert to lowercase
    $slug = $inputString.ToLower()
    
    # Replace spaces with hyphens
    $slug = $slug -replace '\s+', '-'
    
    # Remove special characters (keep only alphanumeric and hyphens)
    $slug = $slug -replace '[^a-z0-9\-]', ''
    
    # Remove leading/trailing hyphens
    $slug = $slug.Trim('-')
    
    # Collapse multiple hyphens
    $slug = $slug -replace '-+', '-'
    
    return $slug
}

# Create tag pages
foreach ($tag in $uniqueTags) {
    # Create slugized version for filename and URL
    $slug = Get-SlugizedString $tag
    
    # If slug is empty after processing, use a fallback
    if ([string]::IsNullOrEmpty($slug)) {
        $slug = "tag-$($tag.GetHashCode().ToString('x'))"
    }
    
    $filename = "$slug.md"
    $filepath = Join-Path $tagsDir $filename
    
    # Create front matter with slugized permalink
    $frontMatter = @"
---
layout: tag
tag: $tag
permalink: "/tags/$slug"
---
"@
    
    # Write to file with UTF8 encoding (without BOM for PowerShell 5.1)
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($filepath, $frontMatter, $utf8NoBom)
    Write-Host "Created tag page: $filename for tag: $tag"
}

Write-Host "Done! Created $($uniqueTags.Count) tag pages."