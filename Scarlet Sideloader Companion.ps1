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

# Check if partner token file exists
# Get the path of the script
$scriptPath = (Get-Location).Path

# Build the full path to the partner token file
$myPartnerTokenFile = Join-Path $scriptPath "myPartnerToken.txt"

# Check if partner token file exists
(Test-Path $myPartnerTokenFile) 
    # Read partner token from file
    $myPartnerToken = Get-Content $myPartnerTokenFile | Select-Object -First 1
    $myPartnerTokenTextBox.Text = $myPartnerToken

# Define Dropdown List
$appxToUploadComboBox = New-Object System.Windows.Forms.ComboBox
$appxToUploadComboBox.Location = New-Object System.Drawing.Point(10, 70)
$appxToUploadComboBox.Size = New-Object System.Drawing.Size(400, 20)
$appxToUploadComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList

# Define Button for Randomizing App Name
$randomizeButton = New-Object System.Windows.Forms.Button
$randomizeButton.Location = New-Object System.Drawing.Point(10, 100)
$randomizeButton.Size = New-Object System.Drawing.Size(400, 40)
$randomizeButton.Text = "Randomize Name"

# Populate Dropdown List with Apps in "appsToUpload" folder
$appsToUploadPath = (Get-Location).Path + "\appsToUpload"
Get-ChildItem -Path $appsToUploadPath | Foreach-Object {
    $appxToUploadComboBox.Items.Add($_.Name)
}

# Define Upload Button
$uploadButton = New-Object System.Windows.Forms.Button
$uploadButton.Location = New-Object System.Drawing.Point(10, 150)
$uploadButton.Size = New-Object System.Drawing.Size(400, 40)
$uploadButton.Text = "Upload"

# Add controls to Form
$form.Controls.Add($wantedAppNameTextBox)
$form.Controls.Add($randomizeButton)
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

$randomizeButton.Add_Click({
    $chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
    $wantedAppName = ''
    for ($i = 0; $i -lt 32; $i++) {
        $wantedAppName += $chars[(Get-Random -Maximum $chars.Length)]
    }
    $wantedAppNameTextBox.Text = $wantedAppName
})

# Show Form
$form.ShowDialog()