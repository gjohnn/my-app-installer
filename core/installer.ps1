function Install-Apps {
    param(
        [Parameter(Mandatory)]
        [string[]]$AppNames,
        [hashtable]$Categories
    )

    foreach ($app in $AppNames) {
        # Buscar ID en categorías
        $id = $null
        foreach ($cat in $Categories.Keys) {
            if ($Categories[$cat].ContainsKey($app)) {
                $id = $Categories[$cat][$app]
                break
            }
        }

        if ($id) {
            Write-Host "Instalando $app..."
            Start-Process "winget" -ArgumentList "install --id $id -e --silent" -Wait
        } else {
            Write-Host "⚠️ No se encontró ID para $app"
        }
    }
}
