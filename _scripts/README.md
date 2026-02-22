# Scripts for Jekyll Blog Maintenance

This folder contains PowerShell scripts for maintaining the Jekyll blog. These scripts are not part of the website build process and are for administrative use only.

## Script Descriptions

### `generate_tags_final.ps1` (Recommended)
The final version of the tag generation script. This script:
- Extracts all unique tags from blog posts (case-insensitive)
- Handles UTF-8 encoding properly for Chinese characters
- Creates tag pages in the `tags/` directory
- Uses the original tag names in permalinks (matching categories)
- Replaces invalid filename characters with underscores
- Cleans up existing tag files before regeneration

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File _scripts\generate_tags_final.ps1
```

### `generate_tags.ps1` (Initial version)
The original tag generation script. Creates tag pages but has encoding issues with Chinese characters.

### `generate_tags_fixed.ps1` (Improved version)
Fixed version with case-insensitive deduplication but still has encoding issues.

### `generate_tags_utf8.ps1` (UTF-8 version)
Adds proper UTF-8 encoding but has issues with URL encoding.

### `generate_tags_slugized.ps1` (Slugized version)
Attempts to use slugized URLs but doesn't match Jekyll's `slugize` filter exactly.

### `test_tag_links.ps1`
Tests tag link consistency by:
- Verifying all tag files have proper front matter
- Checking that tag names match permalinks
- Ensuring no invalid characters in filenames
- Confirming home.html doesn't use `slugize` filter

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File _scripts\test_tag_links.ps1
```

## When to Regenerate Tags

Run `generate_tags_final.ps1` when:
1. New posts with new tags are added
2. Tag names in existing posts are changed
3. Tag pages need to be regenerated for any reason

## Notes

- Jekyll ignores folders starting with underscore (`_`) by default, so this folder won't be included in the website build
- All scripts use UTF-8 encoding without BOM for proper Chinese character handling
- The final script creates 531 unique tag pages (case-insensitive)
- Tag links in `_layouts/home.html` should NOT use the `slugize` filter to match the tag page permalinks