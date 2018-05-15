function [NodeItem,numItem] = UpdateNodeSetFunction(reg,RegionOnElement,Input_data,NodeItem_in,numItem_in)
                           
ElementsOnNode = Input_data.ElementsOnNode;
ElementsOnNodeDup = Input_data.ElementsOnNodeDup;
ElementsOnNodeNum = Input_data.ElementsOnNodeNum;

[NodeItem,numItem] = UpdateNodeSet(reg,RegionOnElement,ElementsOnNodeNum,ElementsOnNode,ElementsOnNodeDup,NodeItem_in,numItem_in);