// Configuration
GEAR = 1;
TEST = 2;
WHOLE = 0;

PARTNO = TEST; // part number
$fn=50; // Resolution

// Teeth Info
teethCount = 16;
teethDepth = 2;

// Backing Info
backRadius = 10;
backDepth = 4;
backLip = 0.5;

// Hole Info
holeRadius = 4;

// Test Info
handleLength = 20;
handleHeight = 2;
handleWidth = 5;

// Tolerances
clearance = 0.2; // Clearance between mating parts
teethInset = 0; // Pull teeth in towards backing


// Calculations
teethAngle =  360 / teethCount / 2; // Teeth spacing as an angle
teethOffset = teethAngle / 2; // Angle offset to get proper alignment
teethRadius = backRadius - backLip;

module backing() {
	translate ([0,0,-backDepth]) {
		cylinder(h=backDepth,r=backRadius);
	}
}

module tooth() {
	toothPoints = [
		[0,0,0],
		[0, teethRadius, 0],
		[0, teethRadius, teethDepth],
		[0,0,teethDepth/2],
		[ teethRadius * sin(teethAngle), teethRadius * cos(teethAngle) , 0],
	];
    
    toothFaces = [
		[0,1,2,3],
		[0,4,1],
		[3,2,4],
		[1,4,2],
		[0,3,4]
	];
	polyhedron( toothPoints, toothFaces );
}

module teeth() {
	rotate([0,0,teethOffset]) union() {
		for ( i = [1:teethCount]) {
			rotate([0,0,(i-1) * teethAngle*2]) {
				tooth();	
				mirror([1,0,0]) tooth();
			}
		}
	}
}


module handle() {
	translate ([0,handleLength/2,-backDepth+handleHeight/2]) {
	    cube([handleWidth,handleLength,handleHeight],center=true);
	}
}

module gear() {
	difference() {
		union() {
			backing();
			//tooth();
			teeth();
			if(PARTNO == 2) {
				handle(mountDepth=1.5);
			}
		}
		cylinder(h=(backDepth+teethDepth)*2, r=holeRadius+clearance, center = true);
	}
}


gear();
