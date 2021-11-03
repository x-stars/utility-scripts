@ REM Open hosts file with Notepad as Administrator.
@ PowerShell -NoProfile -Command ^
    Start-Process -Verb RunAs notepad.exe ^
    $env:SystemRoot\System32\drivers\etc\hosts
