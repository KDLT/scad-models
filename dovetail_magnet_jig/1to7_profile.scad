base_dimensions=[50,50,20];

module jig() {
    module baseCut() {
    };
    module base() {
        cube(base_dimensions, center=true);
    };
    difference() {
        base();
        baseCut();
    };
};

jig();
