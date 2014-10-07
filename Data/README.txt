ADL Recognition with Wrist-worn Accelerometer Data Set
------------------------------------------------------

1. What is it?
--------------

The "ADL Recognition with Wrist-worn Accelerometer Data Set" is a public collection of
labelled accelerometer data recordings to be used for the creation and validation of
acceleration models of simple human activities, called Human Motion Primitives (HMP).
Human Motion Primitives allow for the recognition of mechanical, location-independent
Activities of Daily Living (ADL).
We believe that, in a similar fashion to computer vision public datasets, the adoption
of common testbenches for human activity recognition algorithms will allow for a better
comparison between different approaches and ultimately lead to the development of more
accurate and reliable solutions.

A detailed description of the dataset can be found at:
1. Bruno, B., Mastrogiovanni, F., Sgorbissa, A.:
   A Public Domain Dataset for ADL Recognition Using Wrist-placed Accelerometers
   In: IEEE Int Symp on Robot and Human Interactive Communication (RO-MAN),
   2014

A description of the ADL monitoring system that we have designed on the basis of the
dataset can be found at:
1. Bruno, B., Mastrogiovanni, F., Sgorbissa, A., Vernazza, T., Zaccaria, R.: 
   Analysis of human behavior recognition algorithms based on acceleration data 
   In: IEEE Int Conf on Robotics and Automation (ICRA), 
   pp. 1602--1607 (2013)
2. Bruno, B., Mastrogiovanni, F., Sgorbissa, A., Vernazza, T., Zaccaria, R.: 
   Human motion modelling and recognition: A computational approach 
   In: IEEE Int Conf on Automation Science and Engineering (CASE), 
   pp. 156--161 (2012)

2. Version
----------

Version: 1.1
Released on: 23/06/2014

The trials and models added in this version were collected by Fabio Fimmanò and Laura
Schiaffino, as part of their work for the Master Thesis "Analysis and Comparison of
Clustering Algorithms for the Modelling and Recognition of Human Activities". 

2.1. Version history
--------------------

23/06/2014:    version 1.1 is published, with 5 new models and a total of 74 new trials
11/02/2014:    version 1.0 of the dataset is published at UCI Machine Learning Repository

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
- Barbara Bruno
  Laboratorium, dept. DIBRIS
  Università degli Studi di Genova (Italy)
  barbara.bruno@unige.it

- Fulvio Mastrogiovanni
  Laboratorium, dept. DIBRIS
  Università degli Studi di Genova (Italy)
  fulvio.mastrogiovanni@unige.it

- Antonio Sgorbissa
  Laboratorium, dept. DIBRIS
  Università degli Studi di Genova (Italy)
  antonio.sgorbissa@unige.it