$edge = Get-Item "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$version = $edge.VersionInfo.ProductVersion

$installer = "C:\Program Files (x86)\Microsoft\Edge\Application\$version\Installer"

cd $installer

.\setup.exe --uninstall --system-level --force-uninstall
