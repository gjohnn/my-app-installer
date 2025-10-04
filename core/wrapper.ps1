# Script Wrapper para funciones de instalacion

function global:Invoke-AppInstallation {
    param(
        [Parameter(Mandatory)]
        [string[]]$AppNames,
        
        [Parameter(Mandatory)]
        [hashtable]$Categories,
        
        [switch]$ShowProgress
    )
    
    try {
        if ($AppNames.Count -eq 0) {
            throw "No se proporcionaron aplicaciones para instalar"
        }
        
        # Verificar que Winget está disponible
        $wingetCommand = Get-Command winget -ErrorAction SilentlyContinue
        if (-not $wingetCommand) {
            throw "Winget no está disponible. Por favor instala Winget desde https://aka.ms/getwinget"
        }
        
        $successCount = 0
        $errorCount = 0
        $errorApps = @()
        $totalApps = $AppNames.Count
        
        Write-Host ""
        Write-Host "=== INICIANDO INSTALACION ===" -ForegroundColor Cyan
        Write-Host "Total de aplicaciones: $totalApps" -ForegroundColor White
        Write-Host ""
        
        for ($i = 0; $i -lt $AppNames.Count; $i++) {
            $app = $AppNames[$i]
            $currentStep = $i + 1
            
            if ($ShowProgress) {
                $percentComplete = [int](($currentStep / $totalApps) * 100)
                Write-Progress -Activity "Instalando aplicaciones" -Status "$app ($currentStep de $totalApps)" -PercentComplete $percentComplete
            }
            
            try {
                # Buscar ID en categorias
                $appId = $null
                foreach ($categoryName in $Categories.Keys) {
                    $category = $Categories[$categoryName]
                    if ($category.ContainsKey($app)) {
                        $appId = $category[$app]
                        break
                    }
                }
                
                if (-not $appId) {
                    throw "No se encontro ID para la aplicacion: $app"
                }
                
                Write-Host "[$currentStep/$totalApps] Instalando: $app" -ForegroundColor Yellow
                Write-Host "   ID: $appId" -ForegroundColor Gray
                
                # Instalar aplicacion usando método alternativo más simple
                $wingetCommand = "winget install --id `"$appId`" --exact --silent --accept-package-agreements --accept-source-agreements"
                
                Write-Host "   Ejecutando: $wingetCommand" -ForegroundColor Gray
                
                try {
                    # Usar Invoke-Expression para mayor compatibilidad
                    $output = Invoke-Expression $wingetCommand 2>&1
                    $exitCode = $LASTEXITCODE
                    
                    if ($exitCode -eq 0) {
                        Write-Host "   Instalacion exitosa" -ForegroundColor Green
                        $successCount++
                    } else {
                        throw "Winget retorno codigo de error: $exitCode. Salida: $output"
                    }
                }
                catch {
                    throw "Error ejecutando winget: $($_.Exception.Message)"
                }
            }
            catch {
                Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
                $errorApps += $app
                $errorCount++
            }
            
            Write-Host ""
        }
        
        if ($ShowProgress) {
            Write-Progress -Activity "Instalando aplicaciones" -Completed
        }
        
        # Mostrar resumen
        Write-Host "=== RESUMEN DE INSTALACION ===" -ForegroundColor Cyan
        Write-Host "Exitosas: $successCount" -ForegroundColor Green
        Write-Host "Fallidas: $errorCount" -ForegroundColor Red
        
        if ($errorCount -gt 0 -and $errorApps.Count -gt 0) {
            Write-Host ""
            Write-Host "Aplicaciones con errores:" -ForegroundColor Yellow
            foreach ($app in $errorApps) {
                Write-Host "   - $app" -ForegroundColor Red
            }
        }
        
        Write-Host ""
        
        return @{
            Success = ($errorCount -eq 0)
            SuccessCount = $successCount
            ErrorCount = $errorCount
            ErrorApps = $errorApps
        }
    }
    catch {
        Write-Host "Error critico en la instalacion: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}