[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $ScriptToRun
)

$OPENSCAD_PATH = "C:\Program Files\OpenSCAD";
$NOPSCADLIB_PATH = [Environment]::GetFolderPath("MyDocuments") + "\OpenSCAD\libraries\NopSCADlib";

$env:Path += ";$OPENSCAD_PATH";
$env:OPENSCADPATH = $OPENSCAD_PATH;
$env:PYTHONIOENCODING = "UTF-8";

python "$NOPSCADLIB_PATH\scripts\$ScriptToRun.py"