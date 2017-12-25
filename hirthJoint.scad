//! Hirth joint implementation. 
/*!
A fully parametric Hirth Joint that creates the teeth, backing, and a hole. The
part's center is set to the center point of two mating parts.

\param radius Radius of entire part
\param teethDepth Mesh distance for the teeth
\param teethInset Add clearance to out edge for teeth
\param count Number of teeth
\param backingDepth Thickness of backing
\param clearance Clearance added to hole radius
\param holeRadius Radius of center hole
*/
module hirth( radius = 5, teethDepth = 1, teethInset = 1, count = 8, 
	backingDepth = 3, clearance = 0.2, holeRadius = 2 ) {
	
	angle =  360 / count / 2; // Teeth spacing as an angle
	teethOffset = angle / 2; // Angle offset to get proper alignment
	difference() {
		// Create Hirth gear
		translate ([0,0,-teethDepth/2])	union() {
			hirth_backing(radius, backingDepth);
			rotate([0,0,teethOffset]) hirth_teeth(radius-teethInset,
			teethDepth, count);
		}
		// Subtract center hole
		cylinder(h=(backingDepth+teethDepth)*2, r=holeRadius+clearance, 
			center = true);
	}
}


//! Backing cylinder
/*!
Cylinder to guarantee the teeth have a surface to be attached to

\param radius Radius of the teeth
\param depth Depth of the backing material
*/
module hirth_backing(radius = 5, depth = 3) {
	translate ([0,0,-depth]) {
		cylinder(h=depth,r=radius);
	}
}


//! Tooth design
/*!
Create the model for a half of a single tooth. The center point *must* be half 
the depth to get proper meshing. Especially if there is no hole. 

\param radius Radius of the teeth
\param depth Depth of the tooth
\param count Number of teeth 
*/
module hirth_tooth(radius = 4.5, depth = 1, count = 8) {
	angle =  360 / count / 2; // Teeth spacing as an angle
	points = [
		[0,0,0],
		[0, radius, 0],
		[0, radius, depth],
		[0,0,depth/2],
		// Find point on circle where next point would be
		[ radius * sin(angle), radius * cos(angle) , 0],
	];
	
	faces = [
		[0,1,2,3],
		[0,4,1],
		[3,2,4],
		[1,4,2],
		[0,3,4]
	];
	polyhedron( points, faces );
}

//! Teeth face
/*!
The full face of teeth. Result is offset by the distance of 1/2 the angle of 
one tooth. This allows mating parts to mesh as you would normally expect.

\param radius Radius of the teeth
\param depth Depth of the tooth
\param count Number of teeth 
*/
module hirth_teeth(radius = 4.5, depth = 1, count = 8) {
	angle =  360 / count / 2; // Teeth spacing as an angle
	// Create needed number of teeth
	union() for ( i = [1:count]) { 
		// Create tooth and rotate to next position
		rotate([0,0,(i-1) * angle*2]) {
			hirth_tooth(radius, depth,count);	
			mirror([1,0,0]) hirth_tooth(radius, depth,count);
		}
	
	}
}


hirth(teethDepth = 1.5, radius = 10);
