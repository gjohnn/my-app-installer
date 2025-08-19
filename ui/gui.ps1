function Show-Toolbox {
    param(
        [Parameter(Mandatory)]
        [hashtable]$Categories
    )

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Form principal
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Mi Toolbox - Juan Guerrero"
    $form.Size = New-Object System.Drawing.Size(900, 700)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
    $form.MaximizeBox = $false

    # Panel izquierdo: categorías
    $panelLeft = New-Object System.Windows.Forms.Panel
    $panelLeft.Location = New-Object System.Drawing.Point(10, 10)
    $panelLeft.Size = New-Object System.Drawing.Size(500, 620)
    $panelLeft.AutoScroll = $true
    $form.Controls.Add($panelLeft)

    # Panel derecho: apps seleccionadas
    $panelRight = New-Object System.Windows.Forms.Panel
    $panelRight.Location = New-Object System.Drawing.Point(520, 10)
    $panelRight.Size = New-Object System.Drawing.Size(360, 620)
    $panelRight.BackColor = [System.Drawing.Color]::FromArgb(235, 235, 235)
    $panelRight.BorderStyle = "FixedSingle"
    $panelRight.AutoScroll = $true
    $form.Controls.Add($panelRight)

    # Label panel derecho
    $lblSelected = New-Object System.Windows.Forms.Label
    $lblSelected.Text = "Seleccionados:"
    $lblSelected.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
    $lblSelected.Location = New-Object System.Drawing.Point(10, 10)
    $lblSelected.Size = New-Object System.Drawing.Size(340, 25)
    $panelRight.Controls.Add($lblSelected)

    # Lista de seleccionados
    $lstSelected = New-Object System.Windows.Forms.ListBox
    $lstSelected.Location = New-Object System.Drawing.Point(10, 40)
    $lstSelected.Size = New-Object System.Drawing.Size(340, 500)
    $panelRight.Controls.Add($lstSelected)

    $checkboxes = @{}
    $y = 10

    # Crear categorías y checkboxes
    foreach ($cat in $Categories.Keys) {
        $group = New-Object System.Windows.Forms.GroupBox
        $group.Text = $cat
        $group.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $group.Location = New-Object System.Drawing.Point(10, $y)
        $height = 25 + ($Categories[$cat].Count * 30)
        $group.Size = New-Object System.Drawing.Size(460, $height)

        $gy = 25
        foreach ($app in $Categories[$cat].Keys) {
            $cb = New-Object System.Windows.Forms.CheckBox
            $cb.Text = $app
            $cb.Font = New-Object System.Drawing.Font("Segoe UI", 9)
            $cb.Location = New-Object System.Drawing.Point(20, $gy)
            $cb.Size = New-Object System.Drawing.Size(420, 25)
            $group.Controls.Add($cb)
            $checkboxes[$app] = $cb

            # Evento para agregar/quitar de lista
            $cb.Add_CheckedChanged({
                if ($cb.Checked) {
                    if (-not $lstSelected.Items.Contains($app)) {
                        $lstSelected.Items.Add($app)
                    }
                } else {
                    if ($lstSelected.Items.Contains($app)) {
                        $lstSelected.Items.Remove($app)
                    }
                }
            })
            $gy += 30
        }

        $panelLeft.Controls.Add($group)
        $y += $group.Height + 10
    }

    # Botón para deseleccionar desde la lista
    $btnRemove = New-Object System.Windows.Forms.Button
    $btnRemove.Text = "Quitar seleccionado"
    $btnRemove.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnRemove.BackColor = [System.Drawing.Color]::FromArgb(200, 60, 60)
    $btnRemove.ForeColor = "White"
    $btnRemove.FlatStyle = "Flat"
    $btnRemove.FlatAppearance.BorderSize = 0
    $btnRemove.Size = New-Object System.Drawing.Size(340, 35)
    $btnRemove.Location = New-Object System.Drawing.Point(10, 550)
    $panelRight.Controls.Add($btnRemove)

    $btnRemove.Add_Click({
        foreach ($item in $lstSelected.SelectedItems) {
            if ($checkboxes[$item].Checked) { $checkboxes[$item].Checked = $false }
        }
    })

    # Botón instalar
    $btnInstall = New-Object System.Windows.Forms.Button
    $btnInstall.Text = "Instalar seleccionados"
    $btnInstall.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnInstall.BackColor = [System.Drawing.Color]::FromArgb(60, 120, 200)
    $btnInstall.ForeColor = "White"
    $btnInstall.FlatStyle = "Flat"
    $btnInstall.FlatAppearance.BorderSize = 0
    $btnInstall.Size = New-Object System.Drawing.Size(340, 40)
    $btnInstall.Location = New-Object System.Drawing.Point(10, 595)
    $panelRight.Controls.Add($btnInstall)

    $btnInstall.Add_Click({
        $selected = @($lstSelected.Items)
        if ($selected.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("No seleccionaste nada.", "Atención", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        } else {
            Install-Apps -AppNames $selected -Categories $Categories
            [System.Windows.Forms.MessageBox]::Show("Instalación completa.", "Éxito", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
    })

    [void]$form.ShowDialog()
}
