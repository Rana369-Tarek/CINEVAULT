& "E:\flutter section\movie_library\check_cinevault_assets.ps1"$ErrorActionPreference = "Stop"

$ProjectRoot = $PSScriptRoot
$CatalogPath = Join-Path $ProjectRoot "data\movies.json"
$PosterRoot = Join-Path $ProjectRoot "assets\posters"
$MaxImages = 100

Write-Host "`n===== CINEVAULT VALIDATION =====" -ForegroundColor Cyan

if (-not (Test-Path $CatalogPath -PathType Leaf)) {
    Write-Host "ERROR: Catalog file not found." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $PosterRoot -PathType Container)) {
    Write-Host "ERROR: Poster directory not found: $PosterRoot" -ForegroundColor Red
    exit 1
}

$CatalogText = Get-Content $CatalogPath -Raw

if ([string]::IsNullOrWhiteSpace($CatalogText)) {
    Write-Host "ERROR: Catalog is empty." -ForegroundColor Red
    exit 1
}

try {
    $Catalog = @(ConvertFrom-Json -InputObject $CatalogText)
}
catch {
    Write-Host "ERROR: Invalid JSON in movies.json." -ForegroundColor Red
    Write-Host $_.Exception.Message
    exit 1
}

$PosterFiles = @(
    Get-ChildItem $PosterRoot -File -Recurse |
    Where-Object {
        $_.Extension.ToLowerInvariant() -in @(".jpg", ".jpeg", ".png", ".webp")
    }
)

$ReferencedPaths = @(
    foreach ($Item in $Catalog) {
        if ([string]::IsNullOrWhiteSpace([string]$Item.image)) {
            continue
        }

        $RelativePath = ([string]$Item.image).Replace("/", "\")
        $RelativePath = $RelativePath -replace "^assets\\posters\\", ""

        $RelativePath
    }
)

$DistinctReferences = @($ReferencedPaths | Sort-Object -Unique)

$MissingFiles = @(
    foreach ($Reference in $DistinctReferences) {
        $FullPath = Join-Path $PosterRoot $Reference

        if (-not (Test-Path $FullPath -PathType Leaf)) {
            $Reference
        }
    }
)

$UnreferencedFiles = @(
    foreach ($File in $PosterFiles) {
        $RelativePath = $File.FullName.Substring($PosterRoot.Length).TrimStart("\")

        if ($DistinctReferences -notcontains $RelativePath) {
            $File.Name
        }
    }
)

$DuplicateReferences = @(
    $ReferencedPaths |
    Group-Object |
    Where-Object { $_.Count -gt 1 }
)

Write-Host "Catalog records: $($Catalog.Count)"
Write-Host "Poster files found: $($PosterFiles.Count)"
Write-Host "Distinct posters referenced: $($DistinctReferences.Count)"
Write-Host "Unreferenced poster files: $($UnreferencedFiles.Count)"
Write-Host "Missing poster files: $($MissingFiles.Count)"
Write-Host "Maximum allowed images: $MaxImages"

if ($PosterFiles.Count -gt $MaxImages) {
    Write-Host "`nWARNING: Image limit exceeded by $($PosterFiles.Count - $MaxImages) files." -ForegroundColor Yellow
}

if ($MissingFiles.Count -gt 0) {
    Write-Host "`nMissing poster files:" -ForegroundColor Red
    $MissingFiles | ForEach-Object { Write-Host $_ }
}

if ($UnreferencedFiles.Count -gt 0) {
    Write-Host "`nUnreferenced poster files:" -ForegroundColor Yellow
    $UnreferencedFiles | ForEach-Object { Write-Host $_ }
}

if ($DuplicateReferences.Count -gt 0) {
    Write-Host "`nRepeated image references:" -ForegroundColor Yellow
    $DuplicateReferences | ForEach-Object {
        Write-Host "$($_.Name) ($($_.Count) records)"
    }
}

Write-Host "`nValidation finished. No files were deleted or modified." -ForegroundColor Green
