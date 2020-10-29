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
jarDiameter=29.4; //[29.1, 29.4]
vialDiameter=11.5; //[11.2, 11.5]
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
    flangeExtrude();

    module slot(d=db, t=tf) { rotate([90, 0, 0]) cylinder(d=d, h=t); };
    module hole(d=dv, h=hb) { cylinder(d=d, h=h); };
    
    holderHeight=7;
    module holder(d=dp, h=holderHeight, t=2, o=1) {
    // t is thickness of the holder
    // o is offset of cutting solid from center para hindi semicircle ang kalabasan
        translate([0, 0, (d+2*t)/2]) rotate([90,0,0]) {
            // translate rotate kasi ayaw kong centered ang kalabasan
            difference() {
                union() {
                    cube([d+2*t, d+2*t, h], center=true);
                    cylinder(d=d+t, h=h, center=true);
                };
                cylinder(d=d, h=h, center=true);
                translate([-(d+2*t), o, -h/2])
                    cube([2*(d+2*t), (d+2*t)/2, h]);
            }
        }
    };

    // hole placement
    locVialHole=[-x/2+15, y/2-15, 0];
    locJarHole=[-x/2+50, y/2-15-(dj-dv)/2, 0];
    //locJarHole=[0, y/4, 0];

    // holder placement
    locProng=[x/2-30, y/2, 0];
    locBrush=[x/2-15, y/2, 0]; // -10 is the brush slot's offset from the edge of fence


    translate(locVialHole+[0,-dj+holderHeight,0]) holder(d=dv, t=3, o=2); // vial holder
    translate(locProng + [0,-y/4,0]) holder(d=dp, t=2); // prong holder
    translate(locBrush + [0,-y/4,0]) holder(d=db, t=1); // brush holder

    //for now these are through holes
    difference() {
        bottomPlate();
        translate(locVialHole + [0, 0, -hb/2])
            hole(d=dv, h=hb); // vial
        translate(locJarHole + [0, 0, -hb/2])
            hole(d=dj, h=hb); // jar
    };
    difference() {
        translate([0, 0, hf/2]) fence();
        //translate([x/2-10, y/2, hf]) slot(d=db); // -10 is the brush slot's offset from the edge of fence
        translate(locBrush + [0,0,hf]) slot(d=db);
        translate(locProng +[0,0,hf]) slot(d=dp); // -30 naman para sa prong slot
    };

};

easelBase();
