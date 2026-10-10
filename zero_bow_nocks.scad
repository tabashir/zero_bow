$fn=100;
// outer diameter of bow at ends in mm
bow_od=21.5;
// inner diameter of bow at ends in mm
bow_id=19.1;
// overall height of the fitting in mm
nock_length=17.1;

// overall amount that fits inside the bow
insert_length=18.1;

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
    cylinder(h=nock_length, d=bow_od);
    outer_size=bow_id+(bow_od-bow_id)*0.8;
    translate([0,0,-insert_length]) cylinder(h=insert_length, d1=bow_id, d2=outer_size);
    torus(bow_od/2,bow_id/2);
    translate([0,0,-insert_length]) torus(bow_ir,bow_ir-id_diff);
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


