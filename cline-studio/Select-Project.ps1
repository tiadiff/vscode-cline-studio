Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$recentFile = Join-Path $scriptDir "recent-projects.json"

function Load-RecentProjects {
    $list = @()
    if (Test-Path $recentFile) {
        try {
            $raw = Get-Content -Path $recentFile -Raw -Encoding UTF8 | ConvertFrom-Json
            if ($raw -is [System.Array]) { $list = @($raw) }
            elseif ($raw) { $list = @($raw) }
        } catch {}
    }
    return @($list | Where-Object { $_ -and (Test-Path $_ -PathType Container) } | Select-Object -Unique)
}

function Save-RecentProject([string]$folder) {
    $existing = Load-RecentProjects
    $updated = @($folder) + @($existing | Where-Object { $_ -ine $folder })
    $updated = @($updated | Select-Object -First 8)
    $updated | ConvertTo-Json -Depth 2 | Set-Content -Path $recentFile -Encoding UTF8
}

function Remove-RecentProject([string]$folder) {
    $existing = Load-RecentProjects
    $updated = @($existing | Where-Object { $_ -ine $folder })
    $updated | ConvertTo-Json -Depth 2 | Set-Content -Path $recentFile -Encoding UTF8
}

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Cline Agent Studio — Select Project"
        Width="540" Height="420"
        WindowStartupLocation="CenterScreen"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent"
        ResizeMode="NoResize"
        FontFamily="Segoe UI Variable Text, Segoe UI, sans-serif">
    <Window.Resources>
        <Style x:Key="PrimaryBtn" TargetType="Button">
            <Setter Property="Background" Value="#ECEEF0"/>
            <Setter Property="Foreground" Value="#0E0F10"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Padding" Value="16,8"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bdr" Background="{TemplateBinding Background}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bdr" Property="Background" Value="#FFFFFF"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter TargetName="bdr" Property="Opacity" Value="0.4"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="SecondaryBtn" TargetType="Button">
            <Setter Property="Background" Value="#1B1D20"/>
            <Setter Property="Foreground" Value="#E4E6E9"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="Medium"/>
            <Setter Property="Padding" Value="14,8"/>
            <Setter Property="BorderBrush" Value="#2A2D32"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bdr" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bdr" Property="Background" Value="#25282D"/>
                                <Setter TargetName="bdr" Property="BorderBrush" Value="#3C4047"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="CloseBtn" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#7C828B"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Width" Value="28"/>
            <Setter Property="Height" Value="28"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bdr" Background="{TemplateBinding Background}" CornerRadius="6">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bdr" Property="Background" Value="#24262B"/>
                                <Setter Property="Foreground" Value="#ECEEF0"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Border Background="#0E0F10" BorderBrush="#26282D" BorderThickness="1" CornerRadius="14" Margin="10">
        <Border.Effect>
            <DropShadowEffect BlurRadius="22" ShadowDepth="6" Color="#000000" Opacity="0.65"/>
        </Border.Effect>
        <Grid Margin="22,18,22,20">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <!-- Header -->
            <Grid x:Name="HeaderBar" Grid.Row="0" Background="Transparent" Margin="0,0,0,16">
                <StackPanel Orientation="Vertical">
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                        <TextBlock Text="Cline" Foreground="#ECEEF0" FontSize="17" FontWeight="SemiBold"/>
                        <Border Width="1" Height="14" Background="#2C2F35" Margin="10,0"/>
                        <TextBlock Text="STUDIO" Foreground="#70767F" FontSize="11" FontFamily="Consolas" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock Text="Select the project folder to open" Foreground="#8C929B" FontSize="12.5" Margin="0,4,0,0"/>
                </StackPanel>
                <Button x:Name="BtnClose" Content="&#x2715;" Style="{StaticResource CloseBtn}" HorizontalAlignment="Right" VerticalAlignment="Top"/>
            </Grid>

            <!-- Path Input + Browse -->
            <Grid Grid.Row="1" Margin="0,0,0,14">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <Border Grid.Column="0" Background="#151618" BorderBrush="#27292E" BorderThickness="1" CornerRadius="8" Margin="0,0,8,0">
                    <TextBox x:Name="TxtPath" Background="Transparent" Foreground="#ECEEF0" CaretBrush="#ECEEF0"
                             BorderThickness="0" Padding="10,8" FontSize="12.5" FontFamily="Consolas" VerticalContentAlignment="Center"/>
                </Border>
                <Button x:Name="BtnBrowse" Grid.Column="1" Content="Browse..." Style="{StaticResource SecondaryBtn}"/>
            </Grid>

            <!-- Recent Projects -->
            <Grid Grid.Row="2" Margin="0,0,0,16">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <TextBlock Grid.Row="0" Text="RECENT PROJECTS" Foreground="#6E747D" FontSize="10.5" FontWeight="SemiBold" Margin="2,0,0,8"/>
                <Border Grid.Row="1" Background="#131416" BorderBrush="#202226" BorderThickness="1" CornerRadius="10" Padding="4">
                    <ListBox x:Name="LstRecent" Background="Transparent" BorderThickness="0" Foreground="#E4E6E9"
                             ScrollViewer.HorizontalScrollBarVisibility="Disabled">
                        <ListBox.ItemContainerStyle>
                            <Style TargetType="ListBoxItem">
                                <Setter Property="Padding" Value="10,8"/>
                                <Setter Property="Margin" Value="2"/>
                                <Setter Property="Cursor" Value="Hand"/>
                                <Setter Property="HorizontalContentAlignment" Value="Stretch"/>
                                <Setter Property="Template">
                                    <Setter.Value>
                                        <ControlTemplate TargetType="ListBoxItem">
                                            <Border x:Name="itemBdr" Background="Transparent" CornerRadius="7" Padding="{TemplateBinding Padding}">
                                                <ContentPresenter/>
                                            </Border>
                                            <ControlTemplate.Triggers>
                                                <Trigger Property="IsMouseOver" Value="True">
                                                    <Setter TargetName="itemBdr" Property="Background" Value="#1C1E22"/>
                                                </Trigger>
                                                <Trigger Property="IsSelected" Value="True">
                                                    <Setter TargetName="itemBdr" Property="Background" Value="#23262C"/>
                                                </Trigger>
                                            </ControlTemplate.Triggers>
                                        </ControlTemplate>
                                    </Setter.Value>
                                </Setter>
                            </Style>
                        </ListBox.ItemContainerStyle>
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <StackPanel>
                                    <TextBlock Text="{Binding Name}" Foreground="#ECEEF0" FontSize="13" FontWeight="Medium"/>
                                    <TextBlock Text="{Binding FullPath}" Foreground="#70767F" FontSize="11" FontFamily="Consolas" TextTrimming="CharacterEllipsis" Margin="0,1,0,0"/>
                                </StackPanel>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </Border>
            </Grid>

            <!-- Footer Buttons -->
            <Grid Grid.Row="3">
                <Button x:Name="BtnRemove" Content="Remove" Style="{StaticResource SecondaryBtn}" HorizontalAlignment="Left" FontSize="12" Padding="10,6" Visibility="Collapsed"/>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                    <Button x:Name="BtnCancel" Content="Cancel" Style="{StaticResource SecondaryBtn}" Margin="0,0,8,0"/>
                    <Button x:Name="BtnOpen" Content="Open Project" Style="{StaticResource PrimaryBtn}" IsDefault="True"/>
                </StackPanel>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$headerBar = $window.FindName("HeaderBar")
$btnClose  = $window.FindName("BtnClose")
$txtPath   = $window.FindName("TxtPath")
$btnBrowse = $window.FindName("BtnBrowse")
$lstRecent = $window.FindName("LstRecent")
$btnRemove = $window.FindName("BtnRemove")
$btnCancel = $window.FindName("BtnCancel")
$btnOpen   = $window.FindName("BtnOpen")

$script:selectedFolder = $null

function Refresh-List {
    $items = @()
    foreach ($p in (Load-RecentProjects)) {
        $items += [PSCustomObject]@{
            Name     = (Split-Path $p -Leaf)
            FullPath = $p
        }
    }
    $lstRecent.ItemsSource = $items
    if ($items.Count -gt 0 -and [string]::IsNullOrWhiteSpace($txtPath.Text)) {
        $lstRecent.SelectedIndex = 0
        $txtPath.Text = $items[0].FullPath
    }
}

Refresh-List

$headerBar.Add_MouseLeftButtonDown({ $window.DragMove() })
$btnClose.Add_Click({ $window.DialogResult = $false; $window.Close() })
$btnCancel.Add_Click({ $window.DialogResult = $false; $window.Close() })

$window.Add_KeyDown({
    if ($_.Key -eq [System.Windows.Input.Key]::Escape) {
        $window.DialogResult = $false
        $window.Close()
    }
})

$lstRecent.Add_SelectionChanged({
    if ($lstRecent.SelectedItem) {
        $txtPath.Text = $lstRecent.SelectedItem.FullPath
        $btnRemove.Visibility = [System.Windows.Visibility]::Visible
    } else {
        $btnRemove.Visibility = [System.Windows.Visibility]::Collapsed
    }
})

$lstRecent.Add_MouseDoubleClick({
    if ($lstRecent.SelectedItem) {
        $script:selectedFolder = $lstRecent.SelectedItem.FullPath
        Save-RecentProject $script:selectedFolder
        $window.DialogResult = $true
        $window.Close()
    }
})

$btnRemove.Add_Click({
    if ($lstRecent.SelectedItem) {
        Remove-RecentProject $lstRecent.SelectedItem.FullPath
        $txtPath.Text = ""
        Refresh-List
    }
})

$btnBrowse.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Select a project folder for Cline Agent Studio"
    $dialog.UseDescriptionForTitle = $true
    $dialog.ShowNewFolderButton = $true
    if ($txtPath.Text -and (Test-Path $txtPath.Text -PathType Container)) {
        $dialog.SelectedPath = $txtPath.Text
    }
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtPath.Text = $dialog.SelectedPath
        $script:selectedFolder = $dialog.SelectedPath
        Save-RecentProject $script:selectedFolder
        $window.DialogResult = $true
        $window.Close()
    }
})

$btnOpen.Add_Click({
    $candidate = $txtPath.Text.Trim()
    if ($candidate -and (Test-Path $candidate -PathType Container)) {
        $script:selectedFolder = $candidate
        Save-RecentProject $script:selectedFolder
        $window.DialogResult = $true
        $window.Close()
    } else {
        [System.Windows.MessageBox]::Show("The specified folder does not exist.`nUse Browse... to pick a valid directory.", "Invalid Folder", "OK", "Warning") | Out-Null
    }
})

$result = $window.ShowDialog()
if ($result -eq $true -and $script:selectedFolder) {
    Write-Output $script:selectedFolder
}
