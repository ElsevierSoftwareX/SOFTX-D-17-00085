% 04/30/2013

%Get BC
for i = 1:numBC
    node = NodeBC(i,1);
    dir = NodeBC(i,2);
    if dir > ndf
        errmsg = ['dof ID exceeds ndf for BC=' num2str(i)];
        error(errmsg)
    end
    displacement = NodeBC(i,3);
    idFEAP(dir,node) = -1; %#ok<*SAGROW>
    idFEAPBC(dir,node) = displacement;
end