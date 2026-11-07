#Requires -Version 5.1
<#
.SYNOPSIS
    Installiert mehrere Standard-Programme unter Windows per Remote-Skripten.
.DESCRIPTION
    Lädt jedes Install-Skript per `irm` (Invoke-RestMethod) von GitHub und führt es per `iex` aus.
    Fragt nur EINMALIG beim Start nach Administratorrechten (UAC).
#>

# ============================================================
# 1) Selbst-Elevation - NUR EINMAL beim Start
# ============================================================
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Administratorrechte erforderlich - starte neu mit UAC-Prompt..." -ForegroundColor Yellow

    # Script-Pfad ermitteln (Datei-Ausführung oder iex-Fallback)
    $scriptPath = $PSCommandPath
    if ([string]::IsNullOrWhiteSpace($scriptPath) -or -not (Test-Path -LiteralPath $scriptPath)) {
        try {
            $scriptPath = Join-Path $env:TEMP ("install-software-{0}.ps1" -f (Get-Random))
            $MyInvocation.MyCommand.ScriptBlock.ToString() |
                Set-Content -LiteralPath $scriptPath -Encoding UTF8
        } catch {
            Write-Host "[X] Konnte Skript nicht zwischenspeichern." -ForegroundColor Red
            Write-Host "    Bitte als .ps1 Datei speichern und erneut starten." -ForegroundColor Yellow
            try { Read-Host "Enter zum Beenden" } catch { }
            exit 1
        }
    }

    try {
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-NoProfile","-ExecutionPolicy","Bypass","-File","`"$scriptPath`"" `
            -Verb RunAs -ErrorAction Stop
    } catch {
        Write-Host "[X] Start mit Adminrechten fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor Red
        try { Read-Host "Enter zum Beenden" } catch { }
        exit 1
    }
    exit 0
}

# ============================================================
# 2) Konfiguration
# ============================================================
$BaseUrl = "https://raw.githubusercontent.com/deutschich/danltech-sw-win/main/scripts"

$Packages = @(
    [pscustomobject]@{ Name = "Thunderbird";  File = "install-thunderbird.ps1"  }
    [pscustomobject]@{ Name = "VLC";          File = "install-vlc.ps1"          }
    [pscustomobject]@{ Name = "LibreOffice";  File = "install-libreoffice.ps1"  }
    [pscustomobject]@{ Name = "KeePassXC";    File = "install-keepassxc.ps1"    }
    [pscustomobject]@{ Name = "7-Zip";        File = "install-7zip.ps1"         }
    [pscustomobject]@{ Name = "Notepad++";    File = "install-nppp.ps1"         }
    [pscustomobject]@{ Name = "VSCodium";     File = "install-vscodium.ps1"     }
    [pscustomobject]@{ Name = "Chrome";       File = "install-chrome.ps1"       }
    [pscustomobject]@{ Name = "SysInternals"; File = "install-sysinternals.ps1" }
    # NEW
    [pscustomobject]@{ Name = "Python";       File = "install-python.ps1"       }
    [pscustomobject]@{ Name = "TemurinJDK25"; File = "install-temurin.ps1"      }
    [pscustomobject]@{ Name = "Sysmon";       File = "install-sysmon.ps1"       }
    [pscustomobject]@{ Name = "Wireshark";    File = "install-wireshark.ps1"    }
    [pscustomobject]@{ Name = "x64dbg";       File = "install-x64dbg.ps1"       }
    [pscustomobject]@{ Name = "Ghidra";       File = "install-ghidra.ps1"       }
    [pscustomobject]@{ Name = "PEStudio";     File = "install-pestudio.ps1"     }
    [pscustomobject]@{ Name = "DetectItEasy"; File = "install-die.ps1"          }
    [pscustomobject]@{ Name = "PE-bear";      File = "install-pebear.ps1"       }
    [pscustomobject]@{ Name = "Regshot";      File = "install-regshot.ps1"      }
    [pscustomobject]@{ Name = "FakeNet-NG";   File = "install-fakenet.ps1"      }
    [pscustomobject]@{ Name = "FLOSS";        File = "install-floss.ps1"        }
    [pscustomobject]@{ Name = "capa";         File = "install-capa.ps1"         }
    [pscustomobject]@{ Name = "HxD";          File = "install-hxd.ps1"          }
    [pscustomobject]@{ Name = "YARA";         File = "install-yara.ps1"         }
    [pscustomobject]@{ Name = "dnSpyEx";      File = "install-dnspyex.ps1"      }
    [pscustomobject]@{ Name = "ILSpy";        File = "install-ilspy.ps1"        }
    # DotPeek is Broken...
    # [pscustomobject]@{ Name = "dotPeek";      File = "install-dotpeek.ps1"      }
)

# ============================================================
# 3) Installation mit Fehlerbehandlung
# ============================================================
$Results = New-Object System.Collections.Generic.List[object]

foreach ($pkg in $Packages) {
    $name = $pkg.Name
    $url  = "$BaseUrl/$($pkg.File)"

    Write-Host ""
    Write-Host ("=" * 60) -ForegroundColor Cyan
    Write-Host " Installiere $name ..." -ForegroundColor Cyan
    Write-Host ("=" * 60) -ForegroundColor Cyan
    Write-Host "  URL: $url" -ForegroundColor DarkGray

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $content = Invoke-RestMethod -Uri $url -UseBasicParsing -ErrorAction Stop
        if ([string]::IsNullOrWhiteSpace($content)) {
            throw "Leere Antwort vom Server erhalten."
        }
        Invoke-Expression $content
        $sw.Stop()
        Write-Host ("[OK] {0} erfolgreich (Dauer: {1:N1}s)" -f $name, $sw.Elapsed.TotalSeconds) -ForegroundColor Green
        $Results.Add([pscustomobject]@{ Paket = $name; Status = "OK"; Fehler = "" })
    }
    catch {
        $sw.Stop()
        $errMsg = $_.Exception.Message
        Write-Host ("[FEHLER] {0}: {1}" -f $name, $errMsg) -ForegroundColor Red
        if ($_.InvocationInfo.PositionMessage) {
            Write-Host $_.InvocationInfo.PositionMessage -ForegroundColor DarkRed
        }
        $Results.Add([pscustomobject]@{ Paket = $name; Status = "FEHLER"; Fehler = $errMsg })
    }
}

# ============================================================
# 4) Zusammenfassung
# ============================================================
Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host " Zusammenfassung" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan

foreach ($r in $Results) {
    $color = if ($r.Status -eq "OK") { "Green" } else { "Red" }
    Write-Host ("  {0,-15} {1}" -f $r.Paket, $r.Status) -ForegroundColor $color
    if ($r.Fehler) {
        Write-Host ("     -> {0}" -f $r.Fehler) -ForegroundColor DarkRed
    }
}

$failed = @($Results | Where-Object { $_.Status -ne "OK" })
if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host ("[!] {0} von {1} Installationen fehlgeschlagen." -f $failed.Count, $Results.Count) -ForegroundColor Yellow
    $exitCode = 1
} else {
    Write-Host ""
    Write-Host "[OK] Alle Installationen erfolgreich abgeschlossen." -ForegroundColor Green
    $exitCode = 0
}

try { Read-Host "Enter zum Beenden" } catch { }
exit $exitCode
