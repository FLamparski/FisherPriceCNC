Remove-Item .\README.md.bak
Move-Item .\README.md .\README.md.bak
.\nopscadtool.ps1 make_all
Move-Item -Force .\README.md .\ASSEMBLY.md
Move-Item .\README.md.bak .\README.md