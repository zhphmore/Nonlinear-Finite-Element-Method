
% Mesh generation

function [x_a,elem]=generate_mesh(flag)
    
    % TODO
    % Initialize the nodal position and construct the connectivity table

    % l1, l2, l3是四边形板的几何尺寸，单位：m
    l1=1;
    l2=2;
    l3=0.5;

    % ********************************************************************************
    % 方法一和方法二不要同时取消注释，只保留一个
    % 方法一，是先确定网格总数（num_mesh），再确定网格有几行几列（row_mesh和col_mesh）
    % 方法二反之，先确定网格有几行几列，再确定网格总数
    % ********************************************************************************

    % ********************************************************************************
    % 方法一
    % 先确定网格总数
    % 网格的数量（三角形网格）
    % 根据网格单元数量的不同取消注释
    % num_mesh=2;
    num_mesh=100;
    % num_mesh=2000;
    % 网格的数量（四边形网格）
    % 根据网格单元数量的不同取消注释
    % num_mesh=1;
    % num_mesh=50;
    % num_mesh=1000;
    
    % 再确定网格有几行几列
    % 三角形网格
    if flag==1
        if num_mesh==2
            row_mesh=1;
            col_mesh=1;
        elseif num_mesh==100
            row_mesh=5;
            col_mesh=10;
        elseif num_mesh==2000
            row_mesh=20;
            col_mesh=50;
        end
    % 四边形网格
    elseif flag==2
        if num_mesh==1
            row_mesh=1;
            col_mesh=1;
        elseif num_mesh==50
            row_mesh=5;
            col_mesh=10;
        elseif num_mesh==1000
            row_mesh=20;
            col_mesh=50;
        end
    end
    % 方法一
    % ********************************************************************************
    
%     % ********************************************************************************
%     % 方法二
%     % 先确定网格有几行几列
%     row_mesh=5;
%     col_mesh=10;
%     % 再确定网格总数
%     if flag==1
%         num_mesh=2*row_mesh*col_mesh;
%     elseif flag==2
%         num_mesh=row_mesh*col_mesh;
%     end
%     % 方法二
%     % ********************************************************************************
    
    % l1d, l2d, l3d用于计算各结点的坐标，单位：m
    % 即四边形板的边长除以该边的网格数量
    l1d=l1/row_mesh;
    l2d=l2/col_mesh;
    l3d=l3/row_mesh;
    % 计算第j行第k列的结点的坐标
    for j=1:(row_mesh+1)
        for k=1:(col_mesh+1)
            % id_nodes是结点编号：编号顺序从左到右从上到下
            id_nodes=(j-1)*(col_mesh+1)+k;
            % 结点x轴坐标
            x_a(id_nodes,1)=(k-1)*l2d;
            % 结点y轴坐标
            x_a(id_nodes,2)=l1-((j-1)*l1d-(k-1)*(((j-1)*l1d-(j-1)*l3d)/col_mesh));
        end
    end
    
    % 三角形网格，每个网格3个结点
    % 网格编号顺序从左到右从上到下
    if flag==1
        % 两排地两排地算
        % 编号为奇数的网格是倒三角，编号为偶数的网格是正三角
        for i=1:(num_mesh/2)
            % 根据网格编号，计算结点编号
            % 第2i-1号网格左上角的结点（倒三角左上角的结点），是第j行第k列的结点
            % 第2i号网格顶角的结点（正三角顶角的结点），是第j行第k列的结点
            % floor()是整除，mod()是取模
            k=mod(i,col_mesh);
            if k==0
                j=floor(i/col_mesh);
                k=col_mesh;
            else
                j=floor(i/col_mesh)+1;
            end
            % 第2i-1号网格包含的3个结点
            elem(2*i-1,1)=(j-1)*(col_mesh+1)+k;
            elem(2*i-1,2)=(j-1)*(col_mesh+1)+k+1;
            elem(2*i-1,3)=j*(col_mesh+1)+k+1;
            % 第2i号网格包含的3个结点
            elem(2*i,1)=(j-1)*(col_mesh+1)+k;
            elem(2*i,2)=j*(col_mesh+1)+k;
            elem(2*i,3)=j*(col_mesh+1)+k+1;
        end

    % 四边形网格，每个网格4个结点
    % 网格编号顺序从左到右从上到下
    elseif flag==2
        for i=1:num_mesh
            % 根据网格编号，计算结点编号
            % 第i号网格左上角的结点（四边形左上角的结点），是第j行第k列的结点
            k=mod(i,col_mesh);
            if k==0
                j=floor(i/col_mesh);
                k=col_mesh;
            else
                j=floor(i/col_mesh)+1;
            end
            % 第i号网格包含的4个结点
            elem(i,1)=(j-1)*(col_mesh+1)+k;
            elem(i,2)=(j-1)*(col_mesh+1)+k+1;
            elem(i,3)=j*(col_mesh+1)+k+1;
            elem(i,4)=j*(col_mesh+1)+k;
        end
     end

    % TODO

end