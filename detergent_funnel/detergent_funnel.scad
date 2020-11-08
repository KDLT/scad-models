_fn=120;
_diaRim=80;
_riseRim=8;
_depthLip=9;
_diaLip=57;
_angle=70;
_wallThickness=3;

//cylinder(h=10, d=20);
module detergent_funnel(t=_wallThickness, dr=_diaRim, rr=_riseRim, dil=_diaLip, del=_depthLip, fn=_fn, theta=_angle ) {
    y=del*tan(theta);
    module body(t=t) {
        rotate_extrude($fn=fn) {
            polygon([
                [0, 0],
                [dil/2-t, 0],
                [dil/2-t, del],
                [dr/2-t, y+del],
                [dr/2-t, y+del+rr],
                [0, y+del+rr]
            ]);
        }
    };
    difference() {
        body(t=0);
        body(t=t);
    };
};

detergent_funnel();
