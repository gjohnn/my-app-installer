# Script de prueba rapida para la funcion de instalacion

# Cargar el wrapper
. "$PSScriptRoot\core\wrapper.ps1"
. "$PSScriptRoot\core\apps.ps1"

# Probar instalacion de una aplicacion pequena
Write-Host "=== PRUEBA DE INSTALACION ===" -ForegroundColor Cyan
Write-Host "Probando instalacion de GPU-Z..." -ForegroundColor Yellow

$testApps = @("GPU-Z")

try {
    $result = Invoke-AppInstallation -AppNames $testApps -Categories $global:ApplicationCategories -ShowProgress
    
    Write-Host ""
    Write-Host "=== RESULTADO DE LA PRUEBA ===" -ForegroundColor Cyan
    Write-Host "Exitosas: $($result.SuccessCount)" -ForegroundColor Green
    Write-Host "Fallidas: $($result.ErrorCount)" -ForegroundColor Red
    
    if ($result.Success) {
        Write-Host "PRUEBA EXITOSA!" -ForegroundColor Green
    } else {
        Write-Host "PRUEBA FALLIDA. Revisar errores arriba." -ForegroundColor Red
    }
}
catch {
    Write-Host "ERROR EN LA PRUEBA: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Read-Host "Presiona Enter para continuar"