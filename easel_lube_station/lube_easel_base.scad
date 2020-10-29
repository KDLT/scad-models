use <MCAD/boxes.scad>

_baseHeight = 1.2; // 2 layers high only, nope
_baseLength = 151.6; // kulang pa ng 1.5 ang 150 [150, 151.6]
_baseWidth = 101.4; // kulang pa ng 0.32 ang 101 [101, 101.5, 101.4]
_borderThickness = 6.6;
_fenceThickness = 3; // [0.8,3]
_fenceHeight = 16; // 9 for the final height, 16 na
_flangeHeight=8; // measured ang 8

_fenceRadius=5;
_bottomRadius=3;

brushDiameter=4.65;
jarDiameter=29.2; //[29.1, 29.4, 29.2]
vialDiameter=11.25; //[11.2, 11.5, 11.25]
prongToolDiameter=8;

$fn=40;

module easelBase(x=_baseWidth, y=_baseLength, hb=_baseHeight, hf=_fenceHeight, hfl=_flangeHeight, tb=_borderThickness, tf=_fenceThickness, rf=_fenceRadius, rb=_bottomRadius, db=brushDiameter, dj=jarDiameter, dv=vialDiameter, dp=prongToolDiameter) {
    
    module bottomPlate(bX=x+2*tb, bY=y+2*tb, bZ=hb, r=rb) {
        roundedBox(size=[bX, bY, bZ], radius=r, sidesonly=true);
    }; //bottomPlate();

    module fence(t=tf, h=hf, r=rf) {
        difference() {
            roundedBox(size=[x, y, h], radius=r, sidesonly=true);
            roundedBox(size=[x-2*t, y-2*t, h], radius=r-t, sidesonly=true);
        }
    }; //fence();

    module flangeExtrude(h=hfl) {
        translate([0,0,h/2])
        difference() {
            bottomPlate(bZ=h);
            fence(t=1000);
        }
    };

    module slot(d=db, t=tf) { rotate([90, 0, 0]) cylinder(d=d, h=t); };

    module ring(d=dv, h=3.6, t=2) {
    // t is thickness of cylinder
    // h is the height of cylinder
        difference() {
            cylinder(d=d+t, h=h);
            cylinder(d=d, h=h);
        };
    };

    _holderHeight=7;
    _beamThickness=2;
    _slotOffset=1;

    _xVial=-x/2+15;
    _xProng=x/2-30;
    _xBrush=x/2-15;

    module holderBeam(h=_holderHeight, t=_beamThickness, o=_slotOffset) { 
        module beam(x=x, t=t, h=h) {
            translate([0,0,h/2]) cube([x,t,h], center=true);
        };
        //beam();
        module slottedBeam(op=o, ob=o, ov=o) {
            difference() {
                beam();
                translate([_xProng, t/2, h-op]) rotate([90,0,0]) cylinder(d=dp, h=t); // prong
                translate([_xBrush, t/2, h-ob]) rotate([90,0,0]) cylinder(d=db, h=t); // brush
                translate([_xVial, t/2, h-ov]) rotate([90,0,0]) cylinder(d=dv, h=t); // vial
            };
        };
        slottedBeam();
        translate([0,-25,0]) slottedBeam();
    };

    // hole placement
    locVial=[_xVial, y/2-15, 0];
    locJar=[-x/2+45, y/2-15-(dj-dv)/2, 0];

    bottomPlate();
    flangeExtrude();
    translate([0, 0, hf/2]) fence();

    translate([0,25,0]) holderBeam(h=10);

    translate(locVial + [0, 0, -hb/2])
        ring(d=dv, t=3); // vial
    translate(locJar + [0, 0, -hb/2])
        ring(d=dj, t=5, h=7); // jar

};

easelBase();
