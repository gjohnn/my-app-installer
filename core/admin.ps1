function Assert-Admin {
    $principal = New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )

    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Reiniciando como Administrador..."

        # archivo que disparó este proceso (main.ps1)
        $script = $MyInvocation.PSCommandPath  

        Start-Process "powershell.exe" -ArgumentList @(
            "-NoProfile",
            "-ExecutionPolicy", "Bypass",
            "-File", $script
        ) -Verb RunAs

        exit
    }
}
