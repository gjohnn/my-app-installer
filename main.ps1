# Entry point

# Importar módulos
. "$PSScriptRoot\core\admin.ps1"
. "$PSScriptRoot\core\apps.ps1"
. "$PSScriptRoot\core\installer.ps1"
. "$PSScriptRoot\ui\gui.ps1"
. "$PSScriptRoot\core\monitor.ps1"

# --- Verificar permisos ---
Assert-Admin

# --- Lanzar la GUI ---
Show-Toolbox -Categories $categories

