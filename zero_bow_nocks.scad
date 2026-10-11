$fn=100;
// outer diameter of bow at ends in mm
bow_od=21.8;
// inner diameter of bow at ends in mm
bow_id=20.2;
// overall height of the fitting in mm
nock_length=20;

// overall amount that fits inside the bow
insert_length=25;
// diameter of the rib crests at the bottom of the insert (smaller than bow_id so it starts easily; the top is bow_id)
insert_bottom_width=18.5;

// string groove diameter in mm
string_groove_depth=4.5;
// string groove height in mm so you can have the groove wider or narrower than the depth
string_groove_height=5.5;
// string groove tilt_angle
string_groove_angle=30;
// makes the back of the groove deeper or shallower for fine tune
string_groove_lateral_offset=2.1;
// moves the string groove up or down
string_groove_vertical_offset=7.1;

// size of the 45 degree chamfer on the top edge of the nock (0 = none)
nock_chamfer=1;

// --- ribbed insert (from Limb Tips) ---
// width of each rib
rib_width=2.1;
// how far each rib stands proud of the core
rib_height=1.1;
// number of ribs around the insert
rib_count=6;
// distance over which ribs ramp in at the bottom so the insert starts easily
rib_lead_in=2;

// --- index wing (from Limb Tips) ---
wing_enable=true;
// wing profile: rectangle = flush with the top of the nock (no overhang when printed upside down), kite = tapered. Both span the full nock length
wing_shape="kite"; // [rectangle, kite]
// tip to tip length of the wing
wing_length=33;
// thickness of the wing
wing_thickness=4;
// height of the widest point of the kite wing as a percentage of the nock length
wing_peak_percent=70;
// rotation of the wing about the bow axis (0 = +X, 90 = +Y, 180 = -X, 270 = -Y)
wing_angle=270;
// true = wing sticks out both sides, false = only the +side
wing_both_sides=false;

// calculated vars - should not need to alter
bow_or=bow_od/2;
bow_ir=bow_id/2;
id_diff=bow_or-bow_ir;
torus_or=(bow_od+string_groove_depth)/2;
torus_ir=(bow_id-string_groove_depth)/2;

// how much of the groove is not cut (between 1.0 and 2.0)
torus_cutoff_adjust=1.25;

difference() {
  union()  {
    cylinder(h=nock_length-nock_chamfer, d=bow_od);
    translate([0,0,nock_length-nock_chamfer]) cylinder(h=nock_chamfer+0.001, r1=bow_or, r2=bow_or-nock_chamfer);
    insert();
    torus(bow_od/2,bow_id/2);
    if (wing_enable) wing();
    // translate([0,0,nock_length]) torus(bow_od/2,bow_id/2);
  }

  translate([0,string_groove_lateral_offset,string_groove_vertical_offset]) {
    rotate([string_groove_angle,0,0]) {
      scale([1,1,string_groove_height/string_groove_depth]) {
        u_torus(torus_or, torus_ir);
      }
    }
  }
}


// crest radius of the tapered insert at height z (z=-insert_length is the bottom, 0 the top)
function crest_r(z) = (insert_bottom_width + (bow_id-insert_bottom_width)*(z+insert_length)/insert_length)/2;

module insert()
{
  core_bottom=crest_r(-insert_length)-rib_height;
  translate([0,0,-insert_length]) cylinder(h=insert_length, r1=core_bottom, r2=crest_r(0)-rib_height);
  translate([0,0,-insert_length]) torus(core_bottom,core_bottom-id_diff);
  for (i=[0:rib_count-1]) rotate([0,0,i*360/rib_count]) rib();
}

module rib_slice(z, crest)
{
  translate([0,0,z]) linear_extrude(0.01) hull() {
    translate([crest-rib_width/2,0]) circle(d=rib_width);
    translate([crest-rib_height-0.5,-rib_width/2]) square([0.5,rib_width]);
  }
}

module rib()
{
  z0=-insert_length;
  z1=0;
  hull() {
    rib_slice(z0, crest_r(z0)-rib_height+0.1);
    rib_slice(z0+rib_lead_in, crest_r(z0+rib_lead_in));
  }
  hull() {
    rib_slice(z0+rib_lead_in, crest_r(z0+rib_lead_in));
    rib_slice(z1-0.01, crest_r(z1));
  }
}

// flat index fin, rectangular or kite shaped
module wing()
{
  half=wing_length/2;
  rotate([0,0,wing_angle])
  rotate([90,0,0])
  linear_extrude(wing_thickness, center=true)
  union() {
    for (side=[1, wing_both_sides ? -1 : 1])
      scale([side,1])
      polygon(wing_shape=="rectangle"
        ? [[0,0],[half,0],[half,nock_length],[0,nock_length]]
        : [[0,0],[bow_or,0],[half,nock_length*wing_peak_percent/100],[bow_or,nock_length],[0,nock_length]]);
  }
}

module torus(outerRadius, innerRadius, angle=360)
{
  r=(outerRadius-innerRadius)/2;
  rotate_extrude(angle=angle) translate([innerRadius+r,0,0]) circle(r);
}

module u_torus(outer_radius, inner_radius, u_length=15)
{
  r=(outer_radius-inner_radius)/2;
  union() {
    translate([r-outer_radius, 0, 0]) rotate([90,0,0]) linear_extrude(u_length) circle(r);
    translate([outer_radius-r, 0, 0]) rotate([90,0,0]) linear_extrude(u_length) circle(r);
    rotate_extrude(angle=180) translate([inner_radius+r,0,0]) circle(r);
  }
}

// suggested filename for the STL export (see the console)
echo(str("zero_bow_nock",
  "_o", bow_od, "_i", bow_id, "_l", nock_length,
  "_ins", insert_length, "_w", insert_bottom_width, "-", bow_id,
  "_ribs", rib_count,
  wing_enable ? str("_wing-", wing_shape, wing_both_sides ? "-2" : "") : "_nowing",
  "_g", string_groove_depth, "x", string_groove_height, "_", string_groove_angle, "deg",
  ".stl"));
