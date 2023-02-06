Add-Type -AssemblyName System.Windows.Forms

# Define Form
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(420,250)
$form.Text = "Scarlett Sideloader Companion"
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# Define TextBoxes
$wantedAppNameTextBox = New-Object System.Windows.Forms.TextBox
$wantedAppNameTextBox.Location = New-Object System.Drawing.Point(10, 10)
$wantedAppNameTextBox.Size = New-Object System.Drawing.Size(400, 20)
$wantedAppNameTextBox.Text = "Enter the desired for your app"

$myPartnerTokenTextBox = New-Object System.Windows.Forms.TextBox
$myPartnerTokenTextBox.Location = New-Object System.Drawing.Point(10, 40)
$myPartnerTokenTextBox.Size = New-Object System.Drawing.Size(400, 20)
$myPartnerTokenTextBox.Text = "Enter your partner token"

# Define Dropdown List
$appxToUploadComboBox = New-Object System.Windows.Forms.ComboBox
$appxToUploadComboBox.Location = New-Object System.Drawing.Point(10, 70)
$appxToUploadComboBox.Size = New-Object System.Drawing.Size(400, 20)
$appxToUploadComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList

# Populate Dropdown List with Apps in "appsToUpload" folder
$appsToUploadPath = (Get-Location).Path + "\appsToUpload"
Get-ChildItem -Path $appsToUploadPath | Foreach-Object {
    $appxToUploadComboBox.Items.Add($_.Name)
}

# Define Button
$uploadButton = New-Object System.Windows.Forms.Button
$uploadButton.Location = New-Object System.Drawing.Point(10, 100)
$uploadButton.Size = New-Object System.Drawing.Size(400, 40)
$uploadButton.Text = "Upload"

# Add controls to Form
$form.Controls.Add($wantedAppNameTextBox)
$form.Controls.Add($myPartnerTokenTextBox)
$form.Controls.Add($appxToUploadComboBox)
$form.Controls.Add($uploadButton)

# Add event handler for Button
$uploadButton.Add_Click({
    $wantedAppName = $wantedAppNameTextBox.Text
    $myPartnerToken = $myPartnerTokenTextBox.Text
    $appxToUpload = (Join-Path $appsToUploadPath ($appxToUploadComboBox.SelectedItem))
    
    & dotnet Scarlett-Sideloader.dll -n $wantedAppName -p $myPartnerToken $appxToUpload
    Start-Sleep -s 2
    $form.Close()
})

# Show Form
$form.ShowDialog()
