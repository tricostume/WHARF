WHARF Data Set
--------------


1. What is it?
--------------
WHARF Data Set - Wearable Human Activity Recognition Folder Data Set is a public
collection of labelled accelerometer data recordings (obtained by a single wrist-worn
tri-axial accelerometer) to be used for the creation and validation of acceleration
models of simple human activities, called Human Motion Primitives (HMP). Human Motion
Primitives allow for the recognition of mechanical, location-independent Activities
of Daily Living (ADL).
We believe that, in a similar fashion to computer vision public datasets, the adoption
of common testbenches for Human Activity Recognition algorithms will allow for a better
comparison between different approaches and ultimately lead to the development of more
accurate and reliable solutions.

WHARF Data Set is composed of over 1000 recordings of 14 HMP (referring to 5 ADL),
performed by 17 volunteers:
- ADL "Toileting"
	1.  Brush own teeth
	2.  Comb own hair
- ADL "Trasferring"
	3.  Get up from the bed
	4.  Lie down on the bed
	5.  Sit down on a chair
	6.  Stand up from a chair
- ADL "Feeding"
	7.  Drink from a glass
	8.  Eat with fork and knife
	9.  Eat with spoon
	10. Pour water into a glass
- ADL "Ability to use telephone"
	11. Use the telephone
- ADL "Mode of transportation (indoor)"
	12. Climb the stairs
	13. Descend the stairs
	14. Walk

A detailed description of the dataset can be found at:

1. Bruno, B., Mastrogiovanni, F., Sgorbissa, A.:
   A Public Domain Dataset for ADL Recognition Using Wrist-placed Accelerometers
   In: IEEE Int Symp on Robot and Human Interactive Communication (RO-MAN),
   2014


2. Version
----------
Version: 1.2
Released on: 27/11/2014

2.1. Version history
--------------------
27/11/2014:    version 1.2 is published, with clearer data organization

23/06/2014:    version 1.1 is published, with 5 new models and a total of 74 new trials (1)

11/02/2014:    version 1.0 of the dataset is published at UCI Machine Learning Repository

(1) The trials and models added in this version were collected by Fabio Fimmanò and Laura
Schiaffino, as part of their work for the Master Thesis "Analysis and Comparison of
Clustering Algorithms for the Modelling and Recognition of Human Activities". 


3. Documentation
----------------
Up-to-date documentation for this release is provided in the file MANUAL.TXT


4. Installation & usage
-----------------------
This dataset does not require any installation.

The provided MATLAB scripts "displayTrial.m" and "displayModel.m" allow for visualization
of the recorded accelerometer data. A description and example usage of the scripts can be
accessed within MATLAB environment with the commands:
        help displayTrial
        help displayModel

The provided MATLAB scripts have been developed and tested with MATLAB R2008a.


5. Licensing
------------
This dataset is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY,
including the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
The authors allow the users of the "ADL Recognition with Wrist-worn Accelerometer Data Set"
to use and modify it for their own research. Any commercial application, redistribution,
etc... has to be arranged between users and authors individually.

For further license information, please contact the authors.


6. Authors contacts
-------------------
If you want to be informed about dataset updates and new code releases, obtain further
information about the provided dataset, or contribute to its development please write to:

- Barbara Bruno,
  dept. DIBRIS
  Università degli Studi di Genova (Italy)
  barbara.bruno@unige.it

- Fulvio Mastrogiovanni,
  dept. DIBRIS
  Università degli Studi di Genova (Italy)
  fulvio.mastrogiovanni@unige.it

- Antonio Sgorbissa,
  dept. DIBRIS
  Università degli Studi di Genova (Italy)
  antonio.sgorbissa@unige.it

Barbara Bruno, Fulvio Mastrogiovanni and Antonio Sgorbissa are with DIBRIS
(Department of Computer Engineering, Bioengineering, Robotics and Systems
Engineering) at the University of Genova, via Opera Pia 13, 16145, Genova, Italia