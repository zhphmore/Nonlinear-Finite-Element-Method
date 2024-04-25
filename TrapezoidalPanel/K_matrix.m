% This function assembles the global stiffness matrix
% input:
% B: the B matrix for all the elements
% elem: connectivity table
% x_a: coordinates of all the nodes
% jacobians: jacobians of all the elements
% properties: material property vector
% output:
% K: the global stiffness matrix
function [K]=K_matrix(B,elem,x_a,jacobians,properties)

    % TODO: Complete this function
    % 杨氏模量
    E=properties(1);
    % 泊松比
    nu=properties(2);
    % 平面应力的刚度矩阵
    C=(E/(1-nu^(2)))*[  1        nu      0;
                        nu      1       0;
                        0       0       (1-nu)/2];
    
    % 一共有nodes个结点
    % K matrix: K is a 2Nx2N matrix, N is the total number of nodes
    [nodes,~]=size(x_a);
    K=zeros(2*nodes,2*nodes);
    
    % 一共有elements个网格，每个网格NNE个结点
    [elements,NNE]=size(elem);
    for i=1:elements
        % Ki是第i号网格的K matrix
        B1=transpose(B{i,1});
        B2=B{i,1};
        Ki=B1*C*B2*jacobians(i);
        % 将单个网格的K matrix合成到总体的K matrix
        % 按网格包含的结点的编号去合成
        for ii=1:NNE
            for jj=1:NNE
                K(2*elem(i,ii)-1,2*elem(i,jj)-1)=K(2*elem(i,ii)-1,2*elem(i,jj)-1)+Ki(2*ii-1,2*jj-1);
                K(2*elem(i,ii)-1,2*elem(i,jj))=K(2*elem(i,ii)-1,2*elem(i,jj))+Ki(2*ii-1,2*jj);
                K(2*elem(i,ii),2*elem(i,jj)-1)=K(2*elem(i,ii),2*elem(i,jj)-1)+Ki(2*ii,2*jj-1);
                K(2*elem(i,ii),2*elem(i,jj))=K(2*elem(i,ii),2*elem(i,jj))+Ki(2*ii,2*jj);
            end
        end
    end
    % TODO: Complete this function
  
end

