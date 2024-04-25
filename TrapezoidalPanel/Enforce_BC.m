% Enforce the displacement boundary conditions in this function
% input:
% F: the original force vector
% K: the original stiffness matrix
% boundary:
% disp:
% x_a: the coordinates of all the nodes
% output:
% F: modified force vector
% K: modified stiffness matrix
function [F,K]=Enforce_BC(F,K,boundary,disp,x_a)

    % TODO: Complete this function
    % 一共有nodes个结点
    [nodes,~]=size(x_a);
    % 处理边界条件：固定位置的结点
    % 划0置1法
    % 对于固定位置的点，K matrix对应位置的对角线元素置1，其它行列元素置0
    % 同时，对应的外力F置0
    for i=1:2*nodes
        if boundary(i)==1
            K(:,i)=0;
            K(i,:)=0;
            K(i,i)=1;
            F(i)=0;
        end
    end
    % TODO: Complete this function

end