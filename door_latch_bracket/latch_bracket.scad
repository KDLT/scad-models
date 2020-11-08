_xLatch=65;
_yLatch=22.8;
_zLatch=2.88;
//_zLatch=0.64;

_xHoleGapLarge=52;
_xHoleGapSmall=26.5;
_yHoleGap=10;
_yHoleEdgeOffset=6;
_holeDiameter=4.54;

//_nutDiameter=22;
_nutDiameter=22.4; // accounting for hole shrinkage
_mountAngle=10;
_slotHeight=12;

filletRadius=6.5;
trapezoidInset=3;
trapezoidReferenceY=11;

/* minkowski() { */
/*     cube([65-6,22.8-6,2.88]); */
/*     cylinder(h=2.88, r=6); */
/* }; */

module latch_bracket(x=_xLatch, y=_yLatch, z=_zLatch, rh=_holeDiameter/2, xgL=_xHoleGapLarge, xgS=_xHoleGapSmall, yg=_yHoleGap, yo=_yHoleEdgeOffset, rf=filletRadius, ti=trapezoidInset, ty=trapezoidReferenceY, dn=_nutDiameter, ma=_mountAngle, hs=_slotHeight) {
    module basePlate(z=z) {
        module referenceTrapezoid() {
            polygon([
                [0, 0],
                [xgL, 0],
                [xgL-ti, ty],
                [ti, ty]
            ]);
        };
        linear_extrude(height=z) {
            minkowski() {
                circle(r=rf);
                referenceTrapezoid();
            };
        };
    };
    module holes(fn=60) {
        nearOffset=(xgL-xgS)/2;
        farOffset=xgL-nearOffset;
        cylinder(h=z, r=rh, $fn=fn);
        translate([xgL,0]) cylinder(h=z, r=rh, $fn=fn);
        translate([nearOffset,yg]) cylinder(h=z, r=rh, $fn=fn);
        translate([farOffset,yg]) cylinder(h=z, r=rh, $fn=fn);
    };
    module nutSlot(h=hs, x=30) {
        slotY=ty+rf*2;
        slotX=x;
        nutOffset=5;
        module slot(fn=80) {
            translate([-slotX/2,0])
                cylinder(d=slotY, h=h, $fn=fn);
            translate([0,0,h/2])
                cube([slotX, slotY, h], center=true);
        };
        module nut(tilt=-ma) {
            rotate([0,tilt,0]) 
                cylinder(h=h+5, r=dn/2, $fn=6); //h+5 kasi angled ang nut so kailangan patangkarin upang ma-cut ang buong lalim ng slot
        };
        translate([-10,ty/2]) // 10mm shifted up
        difference() {
            slot(fn=200);
            translate([-slotX/2+nutOffset,0,-2]) nut();
        }
    };
    //nutSlot(h=5, x=17);
    difference() {
        //translate([0,ys/2,0])
            nutSlot();
        basePlate(z=hs);
    };
    difference() {
        basePlate();
        holes();
    };
};

latch_bracket();
