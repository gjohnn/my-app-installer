function Ensure-Admin {
    $principal = New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "🔑 Reiniciando como Administrador..."

        $script = $MyInvocation.MyCommand.Definition  # ruta al script actual

        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$script`"" -Verb RunAs

        exit  # mata el proceso no-admin y deja corriendo el elevado
    }
}
