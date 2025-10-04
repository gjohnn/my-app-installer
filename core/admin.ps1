# Modulo de gestion de permisos administrativos

function Ensure-Admin {
    [CmdletBinding()]
    param(
        [switch]$TestMode
    )
    
    try {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal(
            [Security.Principal.WindowsIdentity]::GetCurrent()
        )
        
        $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        
        if (-not $isAdmin) {
            if ($TestMode) {
                Write-Warning "MODO PRUEBA: Ejecutándose sin privilegios de administrador"
                Write-Warning "Algunas instalaciones podrían fallar"
                return
            }
            
            Write-Host "Se requieren privilegios de administrador" -ForegroundColor Yellow
            Write-Host "Reiniciando como Administrador..." -ForegroundColor Cyan
            
            # Obtener la ruta del script principal
            $scriptPath = $PSCommandPath
            if (-not $scriptPath) {
                $scriptPath = $MyInvocation.MyCommand.Path
            }
            if (-not $scriptPath) {
                $scriptPath = Join-Path $PSScriptRoot "..\main.ps1"
            }
            
            if (-not (Test-Path $scriptPath)) {
                Write-Error "No se pudo encontrar el script principal para reiniciar"
                Read-Host "Presiona Enter para continuar sin privilegios elevados"
                return
            }
            
            Write-Host "Ruta del script: $scriptPath" -ForegroundColor Gray
            
            $arguments = @(
                "-NoProfile",
                "-ExecutionPolicy", "Bypass",
                "-NoExit",
                "-File", "`"$scriptPath`""
            )
            
            try {
                Start-Process "powershell.exe" -ArgumentList $arguments -Verb "RunAs" -WindowStyle "Normal"
                Write-Host "Proceso elevado iniciado. Cerrando instancia actual..." -ForegroundColor Green
                Start-Sleep -Seconds 2
                exit 0
            }
            catch {
                Write-Warning "No se pudo elevar privilegios: $($_.Exception.Message)"
                Write-Host "Continuando sin privilegios de administrador..." -ForegroundColor Yellow
                Read-Host "Presiona Enter para continuar"
            }
        }
        else {
            Write-Host "✅ Privilegios de administrador verificados" -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Error al verificar privilegios: $($_.Exception.Message)"
        Read-Host "Presiona Enter para continuar"
    }
}

function Test-AdminPrivileges {
    [CmdletBinding()]
    [OutputType([bool])]
    param()
    
    try {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal(
            [Security.Principal.WindowsIdentity]::GetCurrent()
        )
        
        return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    catch {
        Write-Warning "No se pudo verificar privilegios: $($_.Exception.Message)"
        return $false
    }
}