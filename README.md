# ZeroBow

Parametric OpenSCAD parts and ready-to-print STLs for a Zero Bow (a bow made from a length of pipe/tube): string nocks for the limb ends, an arrow rest, and a handle/grip.

## Source files

| File | Description |
| --- | --- |
| `zero_bow_nocks.scad` | Parametric string nock. A ribbed, tapered insert pushes into the end of the pipe; a tilted string groove sits on the outside, with an optional index wing (rectangle or kite shaped). |
| `zero_bow_nocks.json` | Saved OpenSCAD Customizer parameter sets for the nock (different pipe sizes/fits). |
| `zero_bow_arrow_rest.scad` | Parametric arrow rest: a clip ring that fits around the pipe with a U-shaped rest. Optional double rest (left and right on one fitting). |

### Nock parameters (main ones)

- `bow_od` / `bow_id`: outer / inner diameter of the pipe at the ends (mm).
- `nock_length`, `insert_length`: height of the visible nock and the portion that goes inside the pipe.
- `insert_bottom_width`: rib crest diameter at the insert tip (smaller than `bow_id` so it starts easily).
- `string_groove_depth`, `string_groove_height`, `string_groove_angle`, `string_groove_*_offset`: string groove size, tilt and position.
- `rib_*`: rib width, height, count and lead-in.
- `wing_*`: index wing enable, shape, length, thickness, rotation and sides.
- `nock_chamfer`: 45° chamfer on the top edge.

The script prints a suggested STL filename to the console. Existing STL names encode the parameters, e.g. `o21.8_i20.6_l20_ins25_w18.9-20.6_ribs6_wing-kite38_g4.5x5.5_30deg` = outer 21.8, inner 20.6, length 20, insert 25, insert width 18.9–20.6, 6 ribs, kite wing, groove 4.5×5.5 at 30°.

### Arrow rest parameters (main ones)

- `bow_od`: pipe outer diameter.
- `clip_thickness`, `clip_height`: the clip ring.
- `rest_height`, `rest_width`, `rest_thickness`, `rest_depth`, `rest_vertical_adjust`: the U-shaped rest.
- `double_rest`: add a second rest on the opposite side.

## Printable STLs

| File | Description |
| --- | --- |
| `zero_bow_nock_o21.8_i20.2_*.stl` | Nock for 21.8 mm OD / 20.2 mm ID pipe, kite index wing. |
| `zero_bow_nock_o21.8_i20.6_*.stl` | Nock for 21.8 mm OD / 20.6 mm ID pipe, kite index wing. |
| `zero_bow_arrow_rest.stl` | Single arrow rest. |
| `zero_bow_arrow_rest_double_r20.5_w12.1.stl` | Double arrow rest, 20.5 mm pipe. |
| `zero_bow_arrow_rest_double_r21.1_w12.1.stl` | Double arrow rest, 21.1 mm pipe. |
| `zero_bow_22mm_hole.stl` | Main Zero Bow handle with a 22 mm pipe hole (based on the Thingiverse designs in Credits). |
| `zero_bow_elezo.stl` | Handle variant (original design by the repo author). |

## Usage

1. Open a `.scad` file in OpenSCAD and use the Customizer (load a set from `zero_bow_nocks.json` if wanted).
2. Measure your pipe and set the diameters; print a test fit and adjust.
3. Render (F6), export STL, and print. Nocks are intended to be printed upside down so the wing has no overhang.

## Credits

- The main Zero Bow handle is from https://www.thingiverse.com/thing:6287650, which is itself based on https://www.thingiverse.com/thing:3491255. Please see those pages for the original authors and licences.
- `zero_bow_elezo.stl`, the nocks and the arrow rest are original designs by the repo author.
