% Assemble the force vector in this function
% input:
% x_a    : nodal vector
% Load   : traction on each node
% l_area : surface area associated with each node
% output:
% F      : the global force vector
function [F]=F_vector(x_a,Load,l_area)

    % TODO: Complete this function
    % 一共有nodes个结点
    % Forces vector: F is a vector with 2N entries, N is the total number of nodes
    [nodes,~]=size(x_a);
    F=zeros(2*nodes,1);
    
    % 二维，外应力作线积分
    % 结点上的外应力，乘结点占据的边界长度
    for i=1:nodes
        F(2*i)=-Load*l_area(2*i);
    end
    % TODO: Complete this function
    
end



    