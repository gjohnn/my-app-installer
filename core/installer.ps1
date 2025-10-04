# Modulo de instalacion de aplicaciones usando Winget

function Test-WingetAvailability {
    [CmdletBinding()]
    param()
    
    try {
        Write-Host "Verificando disponibilidad de Winget..." -ForegroundColor Yellow
        
        $wingetCommand = Get-Command winget -ErrorAction SilentlyContinue
        
        if (-not $wingetCommand) {
            Write-Warning "Winget no esta instalado o no esta en el PATH del sistema"
            Write-Host "Para instalar Winget, visite: https://aka.ms/getwinget" -ForegroundColor Cyan
            Write-Host "Continuando sin Winget - Las instalaciones fallaran" -ForegroundColor Yellow
            return $false
        }
        
        $wingetVersion = & winget --version 2>$null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Winget no responde correctamente"
            Write-Host "Intenta reinstalar Winget desde: https://aka.ms/getwinget" -ForegroundColor Cyan
            return $false
        }
        
        Write-Host "Winget disponible - Version: $wingetVersion" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Warning "Error al verificar Winget: $($_.Exception.Message)"
        Write-Host "Para instalar Winget, visite: https://aka.ms/getwinget" -ForegroundColor Cyan
        return $false
    }
}

function Install-Apps {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$AppNames,
        
        [Parameter(Mandatory)]
        [hashtable]$Categories,
        
        [switch]$ShowProgress
    )
    
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
            $appId = Get-ApplicationIdFromCategories -AppName $app -Categories $Categories
            
            if (-not $appId) {
                throw "No se encontro ID para la aplicacion: $app"
            }
            
            Write-Host "[$currentStep/$totalApps] Instalando: $app" -ForegroundColor Yellow
            Write-Host "   ID: $appId" -ForegroundColor Gray
            
            $installResult = Install-SingleApp -AppId $appId -AppName $app
            
            if ($installResult.Success) {
                Write-Host "   Instalacion exitosa" -ForegroundColor Green
                $successCount++
            } else {
                throw $installResult.ErrorMessage
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
    
    Show-InstallationSummary -SuccessCount $successCount -ErrorCount $errorCount -ErrorApps $errorApps
}

function Install-SingleApp {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [string]$AppId,
        
        [Parameter(Mandatory)]
        [string]$AppName
    )
    
    try {
        $arguments = @(
            "install",
            "--id", $AppId,
            "--exact",
            "--silent",
            "--accept-package-agreements",
            "--accept-source-agreements"
        )
        
        $process = Start-Process -FilePath "winget" -ArgumentList $arguments -Wait -PassThru -NoNewWindow -RedirectStandardOutput "NUL" -RedirectStandardError "NUL"
        
        if ($process.ExitCode -eq 0) {
            return [PSCustomObject]@{
                Success = $true
                ErrorMessage = $null
            }
        } else {
            return [PSCustomObject]@{
                Success = $false
                ErrorMessage = "Winget retorno codigo de error: $($process.ExitCode)"
            }
        }
    }
    catch {
        return [PSCustomObject]@{
            Success = $false
            ErrorMessage = $_.Exception.Message
        }
    }
}

function Get-ApplicationIdFromCategories {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$AppName,
        
        [Parameter(Mandatory)]
        [hashtable]$Categories
    )
    
    foreach ($categoryName in $Categories.Keys) {
        $category = $Categories[$categoryName]
        if ($category.ContainsKey($AppName)) {
            return $category[$AppName]
        }
    }
    
    return $null
}

function Show-InstallationSummary {
    [CmdletBinding()]
    param(
        [int]$SuccessCount,
        [int]$ErrorCount,
        [string[]]$ErrorApps
    )
    
    Write-Host "=== RESUMEN DE INSTALACION ===" -ForegroundColor Cyan
    Write-Host "Exitosas: $SuccessCount" -ForegroundColor Green
    Write-Host "Fallidas: $ErrorCount" -ForegroundColor Red
    
    if ($ErrorCount -gt 0 -and $ErrorApps.Count -gt 0) {
        Write-Host ""
        Write-Host "Aplicaciones con errores:" -ForegroundColor Yellow
        foreach ($app in $ErrorApps) {
            Write-Host "   - $app" -ForegroundColor Red
        }
    }
    
    Write-Host ""
}