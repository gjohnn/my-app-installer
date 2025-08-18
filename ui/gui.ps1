function Show-Toolbox {
    param(
        [Parameter(Mandatory)]
        [hashtable]$Categories
    )

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Mi Toolbox"
    $form.Size = New-Object System.Drawing.Size(500,600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(245,245,245)

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = "Top"
    $panel.AutoScroll = $true
    $panel.Size = New-Object System.Drawing.Size(480,500)
    $form.Controls.Add($panel)

    $checkboxes = @{}
    $y = 10

    foreach ($cat in $Categories.Keys) {
        $group = New-Object System.Windows.Forms.GroupBox
        $group.Text = $cat
        $group.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
        $group.Location = New-Object System.Drawing.Point(10,$y)

        $height = 80 + ($Categories[$cat].Count * 30)
        $group.Size = New-Object System.Drawing.Size(440, $height)

        $gy = 25
        foreach ($app in $Categories[$cat].Keys) {
            $cb = New-Object System.Windows.Forms.CheckBox
            $cb.Text = $app
            $cb.Font = New-Object System.Drawing.Font("Segoe UI",9)
            $cb.Location = New-Object System.Drawing.Point(15,$gy)
            $cb.Size = New-Object System.Drawing.Size(350,25)
            $group.Controls.Add($cb)
            $checkboxes[$app] = $cb
            $gy += 30
        }

        $panel.Controls.Add($group)
        $y += $group.Height + 10
    }

    $btnInstall = New-Object System.Windows.Forms.Button
    $btnInstall.Text = "🚀 Instalar seleccionados"
    $btnInstall.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
    $btnInstall.BackColor = [System.Drawing.Color]::FromArgb(60,120,200)
    $btnInstall.ForeColor = "White"
    $btnInstall.FlatStyle = "Flat"
    $btnInstall.Location = New-Object System.Drawing.Point(150,520)
    $btnInstall.Size = New-Object System.Drawing.Size(200,40)

    $btnInstall.Add_Click({
        $selected = $checkboxes.Keys | Where-Object { $checkboxes[$_].Checked }
        if ($selected.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("⚠️ No seleccionaste nada.")
        } else {
            Install-Apps -AppNames $selected -Categories $Categories
            [System.Windows.Forms.MessageBox]::Show("✅ Instalación completa.")
        }
    })
    $form.Controls.Add($btnInstall)

    [void]$form.ShowDialog()
}
