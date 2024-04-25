% Set up the boundary conditions
% input:
% x_a: the coordinates of all the nodes
% elem: connectivity table
% output:
% boundary: boolean flag for each nodal displacement in x and y direction, 1 for constrained, 0 for free
% disp: prescribed nodal displacement in x and y direction
% l_area: surface area for each node
function [boundary,disp,l_area]=B_conditions(x_a,elem)
    
    
    % Displacements imposition
    % Note: this method only works for straight line boundaries
    % parallel to the coordinate axis
    % 1st col: axis label 1 for x, 2 for y
    % 2nd col: location
    % 3rd col: 1 for displacement in x, 2 for y, and 3 for in both x and y
    %          direction
    % 4th col: value of the prescribed displacement
    % 
    % e.g apply displacement boundary condition on the edge of the domain at
    % x=1.5, u(1.5, y)=(0.0 10.0)  ->  (1, 1.5, 2, 10.0)
        
        A(1,:)=[1 0 3 0];        
        [boundary,disp]=displa(x_a,A);
        
    % Forces imposition (area of the nodes) 
    % Note: this method only works for straight line boundaries
    % parallel to the coordinate axis
    % 1st col: axis label 1 for x, 2 for y
    % 2nd col: location
    % 
    % e.g apply traction boundary conditions to the edge of the domain at
    % x=0  ->  (1,0)

        B(1,:)=[2 max(x_a(:,2))];    
        [l_area]=dist(x_a,elem,B);
end

% Set up the displacement boundary conditions in this function
% input:
% x_a: coordinates of all the nodes
% A: prescribed displacement boundary condition
% output:
% boundary: boolean flag for each nodal displacement in x and y direction, 1 for constrained, 0 for free
% disp: prescribed nodal displacement in x and y direction
function [boundary,disp]=displa(x_a,A)
    
    % TODO: Complete this function
    % 一共有nodes个结点
    [nodes,~]=size(x_a);
    % 二维，每个结点都要依次分析x方向y方向
    % 因此boundary和disp都包含2*nodes个元素
    boundary=zeros(2*nodes,1);
    disp=zeros(2*nodes,1);
    
    % 一共有sizeA项位移边界条件
    % 本题sizeA==1，只有一项位移边界条件：板左侧固定，板左侧位移为0
    [sizeA,~]=size(A);

    for a=1:sizeA
        for i=1:nodes
            % 如果第i号结点，在A(a,1)轴的坐标值刚好等于A(a,2)
            % 说明第i号结点是该项位移边界条件涉及的结点
            if x_a(i,A(a,1))==A(a,2)
                % 结点沿x轴的位移有限制
                if A(a,3)==1
                    boundary(2*i-1)=1;
                    disp(2*i-1)=A(a,4);
                % 结点沿y轴的位移有限制
                elseif A(a,3)==2
                    boundary(2*i)=1;
                    disp(2*i)=A(a,4);
                % 结点沿x轴和y轴的位移都有限制
                else
                    boundary(2*i-1)=1;
                    boundary(2*i)=1;
                    disp(2*i-1)=A(a,4);
                    disp(2*i)=A(a,4);
                end
            end
        end
    end
    % TODO: Complete this function

end

% Calculate the surface area associated with each node
% If the node is not a surface node and does not belong to the Neumann 
% boundary conditions, its surface area is initialized as 0
% input:
% x_a: coordinates of all the nodes
% elem: connectivity table
% B: prescribed traction boundary condition
% output:
% l_area: the surface area associated to each node
function [l_area]=dist(x_a,elem,B)

    % TODO: Complete this function
    % 一共有nodes个结点
    [nodes,~]=size(x_a);
    % 每个结点占据的边界大小
    % 二维，边界上的结点占据的边界长度
    % 如果是三维，则是边界上的结点占据的边界面积
    % 内部结点不占据边界，值为0
    l_area=zeros(2*nodes,1);

    % 一共有sizeB项应力边界条件
    % 本题sizeB==1，只有一项应力边界条件：板上部受到均匀负载
    [sizeB,~]=size(B);

    % 一共有elements个网格，每个网格NNE个结点
    [elements,NNE]=size(elem);
    % 首先判断网格是否是边界上的网格
    % 边界上的网格，应包含两个在边界上的结点
    % sur_cnt用于记录该网格，包含的在边界上的结点的个数，sur_id记录在边界上的结点的编号
    % 例如：如果第7号网格包含第4，5，16号结点（三角形网格），其中第4，5号结点在边界上
    % 则：sur_cnt==2，sur_id==[4 5]
    % 因此如果sur_cnt==2，说明该网格包含了两个在边界上的结点，是边界上的网格
    sur_id=zeros(NNE,1);
    for b=1:sizeB
        for i=1:elements
            sur_cnt=0;
            % 判断第i号网格的结点是否在边界上
            for j=1:NNE
                % 如果结点在B(a,1)轴的坐标值刚好等于B(a,2)，说明该结点是边界上的结点
                if x_a(elem(i,j),B(b,1))==B(b,2)
                    sur_cnt=sur_cnt+1;
                    sur_id(sur_cnt)=elem(i,j);
                end
            end
            % 如果第i号网格包含了两个在边界上的结点，说明第i号网格是边界上的网格
            if sur_cnt==2
                % 两个边界上的结点的距离，就是该网格的边界长度
                % 这两个结点均摊此长度，delta_area就是结点均摊到的长度
                % B(b,1)==1说明应力沿x轴施加
                if B(b,1)==1
                    delta_area=(abs(x_a(sur_id(1),2)-x_a(sur_id(2),2)))/2;
                    l_area(2*sur_id(1)-1)=l_area(2*sur_id(1)-1)+delta_area;
                    l_area(2*sur_id(2)-1)=l_area(2*sur_id(2)-1)+delta_area;
                % B(b,1)==2说明应力沿y轴施加（对应本题的情况）
                elseif B(b,1)==2
                    delta_area=(abs(x_a(sur_id(1),1)-x_a(sur_id(2),1)))/2;
                    l_area(2*sur_id(1))=l_area(2*sur_id(1))+delta_area;
                    l_area(2*sur_id(2))=l_area(2*sur_id(2))+delta_area;
                end
            end
        end
    end
    % TODO: Complete this function

end