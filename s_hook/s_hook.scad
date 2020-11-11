_innerDiameterTop=25;
_innerDiameterBot=25;
_innerDistance=50;
_bodyWidth=10;

_hookThickness=10;

_cutY=10;

module s_hook(idt=_innerDiameterTop, idb=_innerDiameterTop, yDelta=_innerDistance, t=_hookThickness, w=_bodyWidth, cy=_cutY) {
    dOuter=idt+2*w;
    module body(d=dOuter) {
        hull() {
            cylinder(d=d, h=t);
            translate([0,yDelta,0]) cylinder(d=d, h=t);
        };
    };
    module holes() {
        cylinder(d=idt, h=t);
        translate([0,yDelta,0]) cylinder(d=idb, h=t);
    };
    module cutRectangle(y=cy, angle=0) {
        x=(idt+2*w)/2;
        translate([0,yDelta/2,t/2])
            cube([x,y,t], center=true);
    };
    //cutRectangle();
    difference() {
        body();
        holes();
        translate([dOuter/4,(yDelta-idt+cy)/2,0])
            cutRectangle();
        translate([-dOuter/4,-(yDelta-idb+cy)/2,0])
            cutRectangle();
    };
};
s_hook();
