@echo off
title Mi Toolbox - Modo de Prueba (Sin Administrador)
color 0e
echo.
echo ==========================================
echo    MI TOOLBOX - MODO DE PRUEBA
echo ==========================================
echo.
echo ATENCION: Ejecutandose en modo de prueba
echo No requiere permisos de administrador
echo Algunas instalaciones podrian fallar
echo.

cd /d "%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0main.ps1' -TestMode"

echo.
echo ==========================================
echo       Instalador finalizado
echo ==========================================
echo.
pause