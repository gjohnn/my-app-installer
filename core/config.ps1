# Configuracion del instalador
# Archivo de configuracion para personalizar el comportamiento del instalador

$global:InstallerConfig = @{
    # Configuracion de la interfaz
    InterfaceSettings = @{
        WindowTitle = "Mi Toolbox - Instalador de Aplicaciones"
        WindowWidth = 700
        WindowHeight = 750
        Theme = "Modern"
    }
    
    # Configuracion de instalacion
    InstallationSettings = @{
        Silent = $true
        AcceptAgreements = $true
        ShowProgress = $true
        LogInstallation = $true
    }
    
    # Configuracion de Winget
    WingetSettings = @{
        Source = "winget"
        VerifyAvailability = $true
        TimeoutSeconds = 300
    }
    
    # Configuracion de seguridad
    SecuritySettings = @{
        RequireAdmin = $true
        CheckIntegrity = $true
        ValidatePackages = $true
    }
}

# Funcion para obtener la configuracion
function Get-InstallerConfig {
    return $global:InstallerConfig
}

# Funcion para actualizar la configuracion
function Set-InstallerConfig {
    param(
        [Parameter(Mandatory)]
        [hashtable]$NewConfig
    )
    
    $global:InstallerConfig = $NewConfig
}