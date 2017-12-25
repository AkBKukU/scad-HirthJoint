Hirth Joint
===========

![Preview of part](https://raw.githubusercontent.com/AkBKukU/scad-HirthJoint/master/doc/images/preview.png)

This is an implementation of a basic hirth joint. The there are three things to 
know about the model that may not expected. 

 - The teeth are rotated on the model by an offset of 1/4 of one tooth. This 
   makes the part alignment work as expected.

 - The center point of the model is center point of two mating parts

 - The meeting point for the teeth in the center is half the height of the 
   teeth. This allows the teeth to properly mesh.

OpenSCAD
--------

This part was made in OpenSCAD with the intention of being as reusable as 
possible. All critical dimensions can be easily modified when creating a new 
instance of the part.


