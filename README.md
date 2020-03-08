# Fisher Price CNC

A desktop, 2D CNC machine made from parts salvaged from a
really terrible 3D priner. This repository contains the
phyiscal CAD design of the machine, electrical and electronic
schematics for any custom boards, and any extra code to make it
run (unlikely to be needed but you never know).

More documentation is currently available on the following
Trello board: https://trello.com/b/17SHQEqY/fisher-price-cnc

## Physical designs - OpenSCAD  - `/scad`

The machine is designed with OpenSCAD, a CAD program that does
away with all of this "drawing" nonsense and instead lets you
use a C-ish programming language to do geometry. The upshot
is that you could treat it like any old source file in git, and
you also have a fairly well understood model for including
libraries.

Speaking of libraries, you will need them. Please install the
following to your OpenSCAD libraries folder:

* [NopSCADlib](https://github.com/nophead/NopSCADlib)

### BOMs

NopSCADlib allows generating BOMs (bills of materials). To regenerate the BOM of this project,
use `nopscadtool.ps1 bom`.

## Attribution

A number of the parts and a lot of the code for this machine
has been borrowed from other projects. Here's a list:

* Some phyiscal parts have been reused or adapted from the [Prusa i3 MK3s](https://github.com/prusa3d/Original-Prusa-i3/tree/MK3S/Printed-Parts/SCAD) (GPLv3)
