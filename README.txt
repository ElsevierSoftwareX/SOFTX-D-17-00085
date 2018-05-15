DEIP - Discontinuous Element Insertion Program
Created by Timothy Truster, 2015

Source files tested on Windows, Linux, and Macintosh operating systems
and in MATLAB > 2014a and OCTAVE > 3.8.1 computing environments.


INSTALL the source code using the following steps:
1. Open MATLAB/OCTAVE terminal
2. Navigate the working directory to the folder containing the script InstallDEIP.m
3. Run the script InstallDEIP.m to load all source files into the search path


Example files are contained in 'examples' folder

Typical execution from the MATLAB Command Window:
1. Insert couplers into mesh by providing an input file: 
      Run an example file, such as 'DEIPex2.m' for a 2D problem
      or 'Lel08_3d_B8DG_Test.m' for a 3D problem
      Reference: Section 1 of manual.pdf
2. Perform finite element analysis to verify mesh: 
      Type 'FEA_Program' in the command window, select input file to run
      Reference: Section 2 of manual.pdf
3. Plot solution in MATLAB for a problem with a small mesh: 
      'plotNodeCont2(Coordinates,Node_U_V(:,1),NodesOnElement)' for 2D
      'plotNodeCont3(Coordinates,Node_U_V(:,1),NodesOnElement)' for 3D
      Reference: Section 3 of manual.pdf
4. Export mesh to Paraview .vtk files for a problem with a large mesh:
      Run 'PostParaview' and select/create directory for .vtk files
      Reference: Section 4 of manual.pdf

      
Directory structure
-------------------
LICENSE         information about redistributing DEIP
examples (dir)  simple examples for using DEIP
InstallDEIP.m   install DEIP for permanent use
README          this file
manual.pdf      user manual for DEIP and supporting modules
source (dir)    source code for DEIP
VERSION         a short version history


Author 
------


  Dr. Timothy Truster <ttruster@utk.edu>
  Department of Civil & Environmental Engineering 
  The University of Tennessee
  318 J.D. Tickle Building, 851 Neyland Drive
  Knoxville, TN, 37996, USA

  Personal Homepage: http://clmi.utk.edu

  DEIP Homepage: https://bitbucket.org/trusterresearchgroup/DEIProgram

Please submit bug reports through the DEIP Homepage or by emailing the author.
  
      
Legal Information & Credits
---------------------------
Copyright (C) 2015 Timothy Truster

This software was written by Timothy Truster.
It was developed at the University of Tennessee, Knoxville, TN, USA.

DEIP is free software. You can redistribute it and/or modify it under the terms
of the University of Illinois/NCSA Open Source License.
If not stated otherwise, this applies to all files contained in this package and
its sub-directories.

A user wishing to contribute to the origin repository source code should contact 
the author so that the new source can be verified and the proper recognition
given when new code versions are released.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
NCSA Open Source License for more details.
