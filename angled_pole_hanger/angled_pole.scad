$fn=80;
baseX=24; baseY=13; baseZ=3;
cylinder_radius=3; 
cylinder_height=45;
z_offset = cylinder_radius*sin(35);
holeRadius = 2;
holeOffset = 5;
filletRadius = 5;
trimX = baseX - filletRadius*2;
trimY = baseY - filletRadius*2;
tinyOffset=0.01;

difference() {
    union() {
        translate([0,0,z_offset])
            rotate([0,35,0])
            cylinder(r=cylinder_radius, h=cylinder_height);
        translate([-trimX/2, -baseY/2, 0]) cube([trimX, baseY, baseZ]);
        translate([-baseX/2, -trimY/2, 0]) cube([baseX, trimY, baseZ]);
        for (x=[baseX/2-filletRadius, -baseX/2+filletRadius],
                y=[baseY/2-filletRadius, -baseY/2+filletRadius]) {
            translate([x, y, 0]) cylinder(r=filletRadius, h=baseZ+0.001);
        };
    };
    translate([-baseX/2,-baseY/2,cylinder_height*sin(55)])
        cube([baseX*2, baseY, baseZ*2]);
    translate([-baseX/2+holeOffset, 0, -tinyOffset])
        cylinder(r=holeRadius, h=baseZ+tinyOffset*2);
}
