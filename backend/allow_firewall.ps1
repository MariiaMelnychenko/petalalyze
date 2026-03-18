# Дозволити вхідні з'єднання на порт 8000 для backend.
# Запустіть PowerShell від імені адміністратора:
#   Правий клік на PowerShell -> "Запуск от имени администратора"
#   cd C:\Users\Admin\DYPLOM_FLOWERS\backend
#   .\allow_firewall.ps1

$ruleName = "Flower Backend 8000"
$existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "Правило '$ruleName' вже існує."
} else {
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -LocalPort 8000 -Protocol TCP -Action Allow
    Write-Host "Правило додано. Порт 8000 відкрито."
}

Write-Host ""
Write-Host "Перевірте ваш IP: ipconfig"
