# Variables de ruta
$source = "C:\Ruta\De\Origen"
$destination = "D:\Ruta\De\Destino"
$logFile = "C:\Ruta\A\Tu\backup_log.txt"
$days = 30

#  copia de seguridad forzada especialmete usar para la primera copia de seguridad y cuando crea conveniente
$forceBackup = $false  # Cambie a $true para forzar la copia de seguridad hoy, asi no se hallan cumplido los 30 dias

# Comprobar la fecha de la última copia de seguridad
if (Test-Path -Path $logFile) {
  $lastBackupDateContent = Get-Content -Path $logFile
  $lastBackupDate = [datetime]::Parse($lastBackupDateContent)
} else {
  $lastBackupDate = [datetime]::MinValue
}

# Obtener la fecha actual
$currentDate = Get-Date

# Comprobar si se necesita una copia de seguridad
if ($lastBackupDate -ne $null) {
    if ($forceBackup -or $currentDate -gt $lastBackupDate.AddDays($days)) {
        # Crear carpeta de destino si no existe
        if (!(Test-Path -Path $destination)) {
            New-Item -ItemType Directory -Path $destination
        }

        # Copiar archivos
        Copy-Item -Path "$source\*" -Destination $destination -Recurse -Force

        # Registrar la fecha de la copia de seguridad actual
        $currentDate.ToString() | Out-File -FilePath $logFile -Force

        Write-Output "Copia de seguridad realizada exitosamente"
    } else {
        Write-Output "No han pasado 30 días desde la última copia de seguridad. La próxima copia esta programada para: $($lastBackupDate.AddDays($days))"
    }
} else {
    Write-Output "No se encontró una fecha de última copia de seguridad en el archivo de registro."
}

