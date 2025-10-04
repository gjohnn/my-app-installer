
# Mi Toolbox – PowerShell Installer GUI

**Mi Toolbox** es un instalador gráfico en PowerShell que permite instalar rápidamente aplicaciones populares en Windows usando **Winget**.  
Está inspirado en el estilo de Chris Titus, con interfaz sencilla y organizada por categorías.  

---

## 🔹 Características

- Instalación silenciosa de aplicaciones comunes: navegadores, productividad, multimedia y juegos/social.  
- Interfaz gráfica con **checkboxes** agrupados por categorías.  
- Funciona siempre con **privilegios de administrador**.  
- Modular: catálogo de apps, lógica de instalación y GUI separados para fácil mantenimiento y escalabilidad.  
- Posibilidad de ejecutar directamente desde un comando tipo (dentro de la carpeta):  
```powershell
powershell -NoExit -ExecutionPolicy Bypass -Command ".\main.ps1" 
```

---

## 🔹 Aplicaciones incluidas por defecto

**Navegadores**
- Google Chrome
- Mozilla Firefox
- Zen Browser

**Productividad**
- Visual Studio Code
- Notepad++
- 7-Zip

**Multimedia**
- VLC Media Player
- Spotify

**Juegos & Social**
- Steam
- Discord

> Puedes agregar más programas editando `core/apps.ps1`.

---

## 🔹 Estructura del proyecto

```
toolbox/
│
├─ main.ps1            # Punto de entrada
├─ core/
│   ├─ admin.ps1       # Comprobación y elevación de permisos
│   ├─ apps.ps1        # Catálogo de aplicaciones por categoría
│   └─ installer.ps1   # Funciones de instalación
└─ ui/
    └─ gui.ps1         # Interfaz gráfica
```

---

## 🔹 Uso

1. Clona o descarga el proyecto en tu PC.  
2. Ejecuta `main.ps1` desde PowerShell:  
```powershell
powershell -ExecutionPolicy Bypass -File .\main.ps1
```
3. Si no estás en modo administrador, el script se reiniciará automáticamente con privilegios elevados.  
4. Marca los programas que querés instalar y haz clic en **🚀 Instalar seleccionados**.  

---

## 🔹 Requisitos

- Windows 10 o superior.  
- [Winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) instalado.  
- PowerShell 5.1 o superior.  
- Permisos de administrador.  

---

## 🔹 Cómo agregar nuevas aplicaciones

1. Abrí `core/apps.ps1`.  
2. Añadí tu app dentro de la categoría correspondiente o crea una nueva categoría:  
```powershell
$categories["Nueva Categoría"] = @{
    "Nombre App" = "Winget.ID.De.App"
}
```

---

## 🔹 Personalización de la GUI

- Color del formulario: `$form.BackColor`  
- Fuente de GroupBoxes y CheckBoxes: `Segoe UI` o la que prefieras  
- Botón instalar: color, tamaño y texto modificables en `ui/gui.ps1`  

---

## 🔹 Contribuciones

Pull requests y sugerencias son bienvenidas.  
Asegurate de seguir la estructura modular para mantener escalable el proyecto.

---

## 🔹 Licencia

Este proyecto es **libre para uso personal y educativo**.  
No me hago responsables de instalaciones en entornos de producción sin autorización.
