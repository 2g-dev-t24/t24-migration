# Script simple para listar archivos duplicados en paquetes DSF
# Solo muestra nombres de archivos y paquetes donde se encuentran

param(
    [string]$DsfPath = "artifacts/dsf"
)

Write-Host "=== ARCHIVOS DUPLICADOS EN PAQUETES DSF ===" -ForegroundColor Green
Write-Host ""

# Verificar que la ruta existe
if (-not (Test-Path $DsfPath)) {
    Write-Host "ERROR: La ruta $DsfPath no existe." -ForegroundColor Red
    exit 1
}

# Obtener todos los paquetes DSF
$packages = Get-ChildItem -Path $DsfPath -Directory | Where-Object { $_.Name -match ".*-1\.0\.0$" }

# Diccionario para almacenar archivos por hash
$fileHashes = @{}
$duplicates = @{}

# Función para calcular hash MD5
function Get-FileHashMD5 {
    param([string]$FilePath)
    try {
        $hash = Get-FileHash -Path $FilePath -Algorithm MD5
        return $hash.Hash
    }
    catch {
        return $null
    }
}

Write-Host "Analizando archivos..." -ForegroundColor Yellow

# Recorrer todos los paquetes
foreach ($package in $packages) {
    # Obtener todos los archivos (no directorios) en el paquete
    $files = Get-ChildItem -Path $package.FullName -File -Recurse
    
    foreach ($file in $files) {
        $fileHash = Get-FileHashMD5 -FilePath $file.FullName
        
        if ($fileHash) {
            $fileName = $file.Name
            $relativePath = $file.FullName.Replace((Get-Location).Path + "\", "")
            
            if ($fileHashes.ContainsKey($fileHash)) {
                # Archivo duplicado encontrado
                if (-not $duplicates.ContainsKey($fileHash)) {
                    $duplicates[$fileHash] = @()
                    # Agregar el archivo original
                    $duplicates[$fileHash] += @{
                        Name = $fileHashes[$fileHash].Name
                        Path = $fileHashes[$fileHash].Path
                        Package = $fileHashes[$fileHash].Package
                    }
                }
                $duplicates[$fileHash] += @{
                    Name = $fileName
                    Path = $relativePath
                    Package = $package.Name
                }
            } else {
                # Primer archivo con este hash
                $fileHashes[$fileHash] = @{
                    Name = $fileName
                    Path = $relativePath
                    Package = $package.Name
                }
            }
        }
    }
}

# Mostrar resultados de forma simple
if ($duplicates.Count -eq 0) {
    Write-Host "No se encontraron archivos duplicados." -ForegroundColor Green
} else {
    Write-Host "Se encontraron $($duplicates.Count) archivos duplicados:" -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($hash in $duplicates.Keys) {
        $files = $duplicates[$hash]
        $fileName = $files[0].Name
        
        Write-Host "Archivo: $fileName" -ForegroundColor Cyan
        Write-Host "Se encuentra en:" -ForegroundColor White
        
        foreach ($file in $files) {
            Write-Host "  - $($file.Package)" -ForegroundColor Gray
        }
        Write-Host ""
    }
}

Write-Host "Análisis completado." -ForegroundColor Green 