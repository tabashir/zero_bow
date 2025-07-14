$fn=100;
// outer diameter of bow at ends in mm
bow_od=21.1;
clip_thickness=4.5;
clip_height=18.1;

// the height of the U
rest_height=18.1;
// how far out the U sticks
rest_width=12.1;
// how thick the parts of the U are
rest_thickness=7.6;
// how wide the rest is from the side (ie from front>back of the bow)
rest_depth=10.1;
// fine tune the height of the clip
rest_vertical_adjust=3.1;

// has left and right rest on same fitting.
double_rest=true;

// calculated vars - should not need to alter
clip_ir=bow_od/2;
clip_or=(bow_od+clip_thickness)/2;
torus_height=clip_height/2;

rest_ir=rest_width/2;
rest_or=(rest_width+rest_thickness)/2;

strengthener_height=clip_height/10;
rest_height_scale=rest_height-rest_or;

union() {
  arrow_ring_and_rest();
  if (double_rest)
    rotate([0,0,180]) arrow_ring_and_rest();
}

module arrow_ring_and_rest() {
  union() {
    scale([1,1,clip_height/(clip_thickness/2)]) torus(clip_or,clip_ir);

    translate([clip_ir+rest_or,0,(clip_thickness/2)-rest_vertical_adjust]) {
      rotate([90,0,0]) {
          scale([1,1,rest_depth/(rest_thickness/2)]) u_torus(rest_or, rest_ir, rest_height_scale);
      }
    }
    translate([clip_ir,-rest_depth/2,(clip_height/2)-strengthener_height]) {
         cube([rest_width, rest_depth, strengthener_height], center=false);
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


