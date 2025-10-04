# Catalogo de aplicaciones organizadas por categorias

$global:ApplicationCategories = @{
    "Navegadores" = @{
        "Google Chrome"     = "Google.Chrome"
        "Mozilla Firefox"   = "Mozilla.Firefox"
        "Microsoft Edge"    = "Microsoft.Edge"
        "Zen Browser"       = "Zen-Team.Zen-Browser"
        "Brave Browser"     = "Brave.Brave"
    }
    
    "Productividad" = @{
        "Visual Studio Code"  = "Microsoft.VisualStudioCode"
        "Notepad++"           = "Notepad++.Notepad++"
        "7-Zip"               = "7zip.7zip"
        "WinRAR"              = "win.rar.WinRAR"
        "Adobe Acrobat Reader" = "Adobe.Acrobat.Reader.64-bit"
        "LibreOffice"         = "TheDocumentFoundation.LibreOffice"
        "Microsoft PowerToys"  = "Microsoft.PowerToys"
    }
    
    "Multimedia" = @{
        "VLC Media Player"    = "VideoLAN.VLC"
        "Spotify"             = "Spotify.Spotify"
        "OBS Studio"          = "OBSProject.OBSStudio"
        "Audacity"            = "Audacity.Audacity"
        "GIMP"                = "GIMP.GIMP"
        "HandBrake"           = "HandBrake.HandBrake"
    }
    
    "Juegos & Social" = @{
        "Steam"               = "Valve.Steam"
        "Discord"             = "Discord.Discord"
        "Epic Games Launcher" = "EpicGames.EpicGamesLauncher"
        "TeamSpeak"           = "TeamSpeakSystems.TeamSpeakClient"
        "WhatsApp Desktop"    = "WhatsApp.WhatsApp"
    }
    
    "Sistema" = @{
        "Windows Terminal"    = "Microsoft.WindowsTerminal"
        "Git"                 = "Git.Git"
        "Python"              = "Python.Python.3.12"
        "Node.js"             = "OpenJS.NodeJS"
        "Docker Desktop"      = "Docker.DockerDesktop"
        "CPU-Z"               = "CPUID.CPU-Z"
        "GPU-Z"               = "TechPowerUp.GPU-Z"
    }
}

function Get-ApplicationCategories {
    return $global:ApplicationCategories
}

function Get-ApplicationById {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$AppName
    )
    
    foreach ($category in $global:ApplicationCategories.Keys) {
        if ($global:ApplicationCategories[$category].ContainsKey($AppName)) {
            return $global:ApplicationCategories[$category][$AppName]
        }
    }
    
    return $null
}