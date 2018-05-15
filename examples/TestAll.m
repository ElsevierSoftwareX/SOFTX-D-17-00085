% Batch script to test all files.
%
% Last revision: 10/28/2017 TJT

%% Tutorial
fprintf('Tutorial files\n')
cd 'Tutorial'
DEIPex1
batchinter = 'batch';
batchname = 'DEIPex2.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'DEIPex2CZM.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel01_2d_T3.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel01_3d_T10.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel01_3d_W6.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel01_3d_W18.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Tet10toHex8_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Tet10toHex8DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Tri6toQua4_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
cd '..'

%% ABAQUS
batchinter = 'batch';
fprintf('ABAQUS files: press any key to continue\n')
pause
cd 'ABAQUS'
batchname = 'AbaqCZMTest2d';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'AbaqCZMTest3d.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'PlateTest.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'PlateQ4toT3.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'PlateCOHnoNotch.m';
fprintf('starting file %s\n',batchname)
FEA_Program
cd '..'

%% FEA_CZ
batchinter = 'batch';
fprintf('CZ files: press any key to continue\n')
pause
cd 'FEA_CZ'
batchname = 'Lel08_2d_Q4CZM_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_2d_T6CZM_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_2d_Q9CZM_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_T10CZM_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_B8CZM_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_B27CZM_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_T4CZM_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
cd '..'

%% FEA_DG
batchinter = 'batch';
fprintf('DG files: press any key to continue\n')
pause
cd 'FEA_DG'
batchname = 'Lel08_2d_Q4DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_2d_Q9DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_2d_T3DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_2d_T3Q4DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_2d_T6DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_B8DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_B27DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_T4DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_T10DG_Test.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_W6DG_Test1.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'Lel08_3d_W6DG_Test2.m';
fprintf('starting file %s\n',batchname)
FEA_Program
cd '..'

%% GMSH
batchinter = 'batch';
fprintf('GMSH files: press any key to continue\n')
pause
cd 'GMSH'
batchname = 'AsterCZMTest2d.m';
fprintf('starting file %s\n',batchname)
FEA_Program
fprintf('starting file NeperGmshCZ\n')
NeperGmshCZ
batchinter = 'batch';
batchname = 'NeperGmshDG.m';
fprintf('starting file %s\n',batchname)
FEA_Program
cd '..'

%% MultiPointConstraint (MPC)
batchinter = 'batch';
fprintf('Multi Point Constraint files: press any key to continue\n')
pause
cd 'MultiPointConstraint'
batchname = 'MPC_2d_DG.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_2d_DG9.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_2d_DGB.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_2d_DGT.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_2d_DGT3.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_2d_DGT6.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_3d_DG.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_3d_DG27.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_3d_DGB.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_3d_DGT.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_3d_DGT2.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'MPC_3d_DGT18.m';
fprintf('starting file %s\n',batchname)
FEA_Program
cd '..'

%% Multiple Material
batchinter = 'batch';
fprintf('Multi Material files: press any key to continue\n')
pause
cd 'Multi_Material'
batchname = 'NeperModel.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'NeperModel_2.m';
fprintf('starting file %s\n',batchname)
FEA_Program
batchname = 'PlateCOHNotch.m';
fprintf('starting file %s\n',batchname)
FEA_Program
cd '..'
