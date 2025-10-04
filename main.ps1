# Mi Toolbox - Instalador grafico de aplicaciones Windows
# Configuracion inicial
[CmdletBinding()]
param(
    [switch]$TestMode,
    [switch]$NoAdmin
)

$ErrorActionPreference = 'Continue'
$VerbosePreference = 'SilentlyContinue'

# Variable para controlar si mantener la ventana abierta
$script:KeepWindowOpen = $true

# Importacion de modulos
try {
    Write-Host "Cargando modulos..." -ForegroundColor Cyan
    
    $modules = @(
        "$PSScriptRoot\core\admin.ps1",
        "$PSScriptRoot\core\apps.ps1", 
        "$PSScriptRoot\core\installer.ps1",
        "$PSScriptRoot\ui\gui.ps1"
    )
    
    foreach ($module in $modules) {
        if (Test-Path $module) {
            . $module
            Write-Host "  Cargado: $(Split-Path $module -Leaf)" -ForegroundColor Green
        } else {
            Write-Warning "  No encontrado: $(Split-Path $module -Leaf)"
        }
    }
    
    Write-Host "Modulos cargados correctamente" -ForegroundColor Green
}
catch {
    Write-Host "" 
    Write-Error "Error al cargar modulos: $($_.Exception.Message)"
    Write-Host "Verifica que todos los archivos esten presentes en las carpetas core/ y ui/" -ForegroundColor Yellow
    Write-Host "" 
    Read-Host "Presiona Enter para salir"
    exit 1
}

# Funcion principal
function Start-ApplicationInstaller {
    param(
        [switch]$TestMode
    )
    
    $script:KeepWindowOpen = $true
    
    try {
        Write-Host "Verificando permisos de administrador..." -ForegroundColor Yellow
        
        # Si estamos en modo test, omitir verificacion de admin
        if (-not $TestMode) {
            Ensure-Admin -TestMode:$TestMode
        } else {
            Write-Host "Modo de prueba: Omitiendo verificacion de administrador" -ForegroundColor Yellow
        }
        
        Write-Host "Verificando Winget..." -ForegroundColor Yellow
        $wingetAvailable = Test-WingetAvailability
        
        if (-not $wingetAvailable) {
            Write-Warning "Winget no esta disponible. Algunas funciones pueden no funcionar."
        }
        
        Write-Host "Iniciando interfaz grafica..." -ForegroundColor Cyan
        Show-Toolbox -Categories $global:ApplicationCategories
        
        Write-Host "" 
        Write-Host "Instalador completado exitosamente" -ForegroundColor Green
    }
    catch {
        Write-Host "" 
        Write-Host "Error critico: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "" 
        Write-Host "Informacion de debug:" -ForegroundColor Yellow
        Write-Host "- Linea: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Gray
        Write-Host "- Archivo: $($_.InvocationInfo.ScriptName)" -ForegroundColor Gray
        Write-Host "" 
        Write-Host "Para obtener ayuda, revisa el README.md" -ForegroundColor Cyan
    }
    finally {
        if ($script:KeepWindowOpen) {
            Write-Host "" 
            Write-Host "Presiona Enter para salir..." -ForegroundColor Gray
            Read-Host
        }
    }
}

# Ejecucion principal
if ($MyInvocation.InvocationName -ne '.') {
    Clear-Host
    Write-Host ""
    Write-Host "=================================" -ForegroundColor Magenta
    Write-Host "       MI TOOLBOX              " -ForegroundColor Magenta
    Write-Host "   Instalador de Aplicaciones " -ForegroundColor Magenta
    Write-Host "=================================" -ForegroundColor Magenta
    Write-Host ""
    
    # Mostrar información de modo de ejecución
    if ($TestMode -or $NoAdmin) {
        Write-Host "⚠️  MODO DE PRUEBA ACTIVADO" -ForegroundColor Yellow
        Write-Host "   Ejecutándose sin privilegios elevados" -ForegroundColor Yellow
        Write-Host ""
    }
    
    Start-ApplicationInstaller -TestMode:($TestMode -or $NoAdmin)
}