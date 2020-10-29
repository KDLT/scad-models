sandalan_dimensions = [15, 90, 20];
upuan_dimensions = [sandalan_dimensions[0] + 20, 90, 8];
armrest_dimensions = [upuan_dimensions[0], 8, sandalan_dimensions[2]-upuan_dimensions[2]];

module sofa(sd=sandalan_dimensions, ud=upuan_dimensions, ad=armrest_dimensions) {
    module sandalan(s=sd) { cube(s); };
    module upuan(s=ud) { cube(s); };
    module armrest(s=ad) { cube(s); };
    sandalan();
    upuan();
    translate([0,0,ud[2]]) armrest();
    translate([0,ud[1]-ad[1],ud[2]]) armrest();
};

sofa();
