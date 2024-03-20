param (
    [string]$ExecutablePath
)

# Start the program
$process = Start-Process -FilePath $ExecutablePath -PassThru

# Wait for the program to open
Start-Sleep -Seconds 2

# Import necessary .NET namespaces
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class Win32Window {
    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
}
"@

# Find the handle of the program's window
$windowHandle = $process.MainWindowHandle

# Set the program's window to be always on top
if ($windowHandle -ne [System.IntPtr]::Zero) {
    $result = [Win32Window]::SetWindowPos($windowHandle, -1, 0, 0, 0, 0, 0x0001 -bor 0x0002)
    if (-not $result) {
        Write-Host "Failed to set the program's window as always on top."
    }
} else {
    Write-Host "Program window not found."
}
