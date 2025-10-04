@echo off
title Mi Toolbox - Instalador de Aplicaciones
color 0b
echo.
echo ==========================================
echo        MI TOOLBOX - INSTALADOR
echo ==========================================
echo.
echo Iniciando instalador de aplicaciones...
echo Requiere permisos de administrador.
echo.

cd /d "%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0main.ps1'"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Error al ejecutar el instalador.
    echo Intenta ejecutar como administrador.
    echo.
    pause
)