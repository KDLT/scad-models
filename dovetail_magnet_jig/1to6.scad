_ratio=1/6;
angle=atan(_ratio);
//echo("angle", angle);

//_baseDimensions=[50,50,20];
_baseDimensions=[60,60,30];

//_pillarDimensions=[24,24,45];
_pillarDimensions=[30,30,45];

//_holeDiameter=12;
_holeDiameter=21.5;
//_holeThickness=2;
_holeThickness=3.6;

//_holeMargin=4.5+_holeDiameter/2;
_holeMargin=5+_holeDiameter/2;

module jig(a=angle, b=_baseDimensions, p=_pillarDimensions, d=_holeDiameter, m=_holeMargin, t=_holeThickness) {
    module holePair(d=d, m=m, t=t) {
        translate([0,t,b[2]/2])
        rotate([90,0,0]) {
            translate([m,0,0]) cylinder(d=d, h=t);
            translate([b[1]-m,0,0]) cylinder(d=d, h=t);
        };
    };
    //holePair();
    module base() {
        longSide=b[2];
        h=b[1];
        module baseCut(a=angle, l=longSide, h=h) {
            s=b[2]*tan(a); //short side
            translate([0,0,l]) rotate([-90,0,0])
            linear_extrude(height=h, center=false)
                polygon([[0,0],[s,l],[s,0]]);
        };
        //baseCut();
        difference() {
            cube(b, center=false);
            l=b[2]; s=b[2]*tan(a); h=b[1];
            //translate([b[0]/2-s, 0, -b[2]/2])
            // added 0.0001 para di magreklamo sa manifold something
            translate([b[0]-s+0.001, 0, 0]) 
                baseCut(l=l, h=h);
            translate([0,-0.001,0])
                holePair();
            translate([t,0,0]) rotate([0,0,90])
                holePair();
            translate([0,b[1]-t,0])
                holePair();
            translate([b[0]+0.001,0,0])
                rotate([-a,0,90]) holePair();
        };
    };
    //base();
    module pillar() {
        module pillarCut(a=angle, l=p[1], w=p[0], h=p[2]) {
            s=b[2]*tan(a); //short side
            translate([p[0]-s+0.001,0,0])
                linear_extrude(height=h, center=false)
                    polygon([[0,0],[s,l],[s,0]]);
            translate([s-0.001,0,h]) rotate([0,180,0])
                linear_extrude(height=h, center=false)
                    polygon([[0,0],[s,l],[s,0]]);
        } //pillarCut();
        difference() {
            cube(p, center=false);
            pillarCut();
        };
    };
    //pillar();

    // amounts to this
    pX=b[0]/2-p[0]/2;
    pY=b[1]/2-p[1]/2;
    translate([pX,pY,b[2]])
        pillar();
    base();
};

jig();

module ringSpacer(do=_holeDiameter, h=_holeThickness, fn=100) {
    cylinder(d=do, h=h, $fn=fn);
};
//ringSpacer(do=21, fn=200);
