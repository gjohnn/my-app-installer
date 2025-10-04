# Interfaz grafica de usuario para el instalador de aplicaciones

function Show-Toolbox {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Categories
    )
    
    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Mi Toolbox - Instalador de Aplicaciones"
        $form.Size = New-Object System.Drawing.Size(700, 750)
        $form.StartPosition = "CenterScreen"
        $form.BackColor = [System.Drawing.Color]::FromArgb(250, 250, 250)
        $form.FormBorderStyle = "FixedSingle"
        $form.MaximizeBox = $false
        
        # Panel principal con scroll
        $mainPanel = New-Object System.Windows.Forms.Panel
        $mainPanel.Size = New-Object System.Drawing.Size(680, 550)
        $mainPanel.Location = New-Object System.Drawing.Point(10, 50)
        $mainPanel.BackColor = "White"
        $mainPanel.BorderStyle = "FixedSingle"
        $mainPanel.AutoScroll = $true
        
        $form.Controls.Add($mainPanel)
        
        # Crear controles para cada categoria
        $allCheckboxes = @{}
        $yPosition = 10
        
        foreach ($categoryName in $Categories.Keys) {
            $categoryData = $Categories[$categoryName]
            
            # Crear grupo para la categoria
            $groupBox = New-Object System.Windows.Forms.GroupBox
            $groupBox.Text = $categoryName
            $groupBox.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
            $groupBox.ForeColor = [System.Drawing.Color]::FromArgb(63, 81, 181)
            $groupBox.Location = New-Object System.Drawing.Point(10, $yPosition)
            
            # Calcular altura del grupo
            $appCount = $categoryData.Count
            $groupHeight = 60 + ($appCount * 30) + 10
            $groupBox.Size = New-Object System.Drawing.Size(620, $groupHeight)
            
            # Crear checkboxes para cada aplicacion
            $appY = 30
            
            foreach ($appName in $categoryData.Keys) {
                $checkbox = New-Object System.Windows.Forms.CheckBox
                $checkbox.Text = $appName
                $checkbox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
                $checkbox.Location = New-Object System.Drawing.Point(20, $appY)
                $checkbox.Size = New-Object System.Drawing.Size(450, 25)
                $checkbox.AutoSize = $true
                
                $groupBox.Controls.Add($checkbox)
                $allCheckboxes[$appName] = $checkbox
                $appY += 30
            }
            
            $mainPanel.Controls.Add($groupBox)
            $yPosition += $groupHeight + 15
        }
        
        # Panel de botones
        $buttonPanel = New-Object System.Windows.Forms.Panel
        $buttonPanel.Size = New-Object System.Drawing.Size(680, 60)
        $buttonPanel.Location = New-Object System.Drawing.Point(10, 610)
        $buttonPanel.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
        $form.Controls.Add($buttonPanel)
        
        # Boton Seleccionar Todo
        $selectAllBtn = New-Object System.Windows.Forms.Button
        $selectAllBtn.Text = "Seleccionar Todo"
        $selectAllBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $selectAllBtn.Size = New-Object System.Drawing.Size(150, 35)
        $selectAllBtn.Location = New-Object System.Drawing.Point(20, 15)
        $selectAllBtn.BackColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
        $selectAllBtn.ForeColor = "White"
        $selectAllBtn.FlatStyle = "Flat"
        $buttonPanel.Controls.Add($selectAllBtn)
        
        # Boton Limpiar Todo
        $clearAllBtn = New-Object System.Windows.Forms.Button
        $clearAllBtn.Text = "Limpiar Todo"
        $clearAllBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $clearAllBtn.Size = New-Object System.Drawing.Size(130, 35)
        $clearAllBtn.Location = New-Object System.Drawing.Point(180, 15)
        $clearAllBtn.BackColor = [System.Drawing.Color]::FromArgb(255, 152, 0)
        $clearAllBtn.ForeColor = "White"
        $clearAllBtn.FlatStyle = "Flat"
        $buttonPanel.Controls.Add($clearAllBtn)
        
        # Boton Instalar
        $installBtn = New-Object System.Windows.Forms.Button
        $installBtn.Text = "INSTALAR SELECCIONADOS"
        $installBtn.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
        $installBtn.Size = New-Object System.Drawing.Size(250, 40)
        $installBtn.Location = New-Object System.Drawing.Point(400, 12)
        $installBtn.BackColor = [System.Drawing.Color]::FromArgb(63, 81, 181)
        $installBtn.ForeColor = "White"
        $installBtn.FlatStyle = "Flat"
        $buttonPanel.Controls.Add($installBtn)
        
        # Eventos de botones
        $selectAllBtn.Add_Click({
            foreach ($checkbox in $allCheckboxes.Values) {
                $checkbox.Checked = $true
            }
        }.GetNewClosure())
        
        $clearAllBtn.Add_Click({
            foreach ($checkbox in $allCheckboxes.Values) {
                $checkbox.Checked = $false
            }
        }.GetNewClosure())
        
        $installBtn.Add_Click({
            $selectedApps = @()
            foreach ($appName in $allCheckboxes.Keys) {
                if ($allCheckboxes[$appName].Checked) {
                    $selectedApps += $appName
                }
            }
            
            if ($selectedApps.Count -eq 0) {
                [System.Windows.Forms.MessageBox]::Show(
                    "No has seleccionado ninguna aplicacion para instalar.",
                    "Ninguna seleccion",
                    [System.Windows.Forms.MessageBoxButtons]::OK,
                    [System.Windows.Forms.MessageBoxIcon]::Warning
                )
                return
            }
            
            $result = [System.Windows.Forms.MessageBox]::Show(
                "Estas seguro de que quieres instalar $($selectedApps.Count) aplicacion(es)?",
                "Confirmar instalacion",
                [System.Windows.Forms.MessageBoxButtons]::YesNo,
                [System.Windows.Forms.MessageBoxIcon]::Question
            )
            
            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                $installBtn.Enabled = $false
                
                try {
                    # Usar función wrapper que evita problemas de ámbito
                    $result = Invoke-AppInstallation -AppNames $selectedApps -Categories $Categories -ShowProgress
                    
                    if ($result.Success) {
                        [System.Windows.Forms.MessageBox]::Show(
                            "Instalacion completada exitosamente.`n`nExitosas: $($result.SuccessCount)`nFallidas: $($result.ErrorCount)",
                            "Instalacion completada",
                            [System.Windows.Forms.MessageBoxButtons]::OK,
                            [System.Windows.Forms.MessageBoxIcon]::Information
                        )
                    } else {
                        [System.Windows.Forms.MessageBox]::Show(
                            "Instalacion completada con errores.`n`nExitosas: $($result.SuccessCount)`nFallidas: $($result.ErrorCount)`n`nRevisa la consola para mas detalles.",
                            "Instalacion con errores",
                            [System.Windows.Forms.MessageBoxButtons]::OK,
                            [System.Windows.Forms.MessageBoxIcon]::Warning
                        )
                    }
                }
                catch {
                    [System.Windows.Forms.MessageBox]::Show(
                        "Error durante la instalacion: $($_.Exception.Message)",
                        "Error",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Error
                    )
                }
                finally {
                    $installBtn.Enabled = $true
                }
            }
        }.GetNewClosure())
        
        # Mostrar el formulario
        [void]$form.ShowDialog()
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Error al crear la interfaz: $($_.Exception.Message)",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
    finally {
        if ($form) {
            $form.Dispose()
        }
    }
}