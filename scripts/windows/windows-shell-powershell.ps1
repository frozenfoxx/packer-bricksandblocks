<#
        .DESCRIPTION
        Sets default shell to PowerShell

        .SYNOPSIS
        - Sets teh default shell to PowerShell
        - From url: https://docs.ansible.com/ansible/latest/os_guide/windows_ssh.html
#>

# Set default to powershell.exe
$shellParams = @{
    Path         = 'HKLM:\SOFTWARE\OpenSSH'
    Name         = 'DefaultShell'
    Value        = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    PropertyType = 'String'
    Force        = $true
}
New-ItemProperty @shellParams

# Set default back to cmd.exe
Remove-ItemProperty -Path HKLM:\SOFTWARE\OpenSSH -Name DefaultShell
