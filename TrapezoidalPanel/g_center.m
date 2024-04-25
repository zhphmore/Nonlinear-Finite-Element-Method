% Calculate the barycenter and surface area of each element
%
% input:
% x_a  : coordinates of all the nodes
% elem : connectivity table
%
% output:
% xg   : barycenters of all the elements
% Area : surface areas of all the elements
function [xg,Area]=g_center(x_a,elem)

    % TODO: Complete this function
    % 一共有elements个网格，每个网格NNE个结点
    [elements,NNE]=size(elem);
    
    % 三角形网格
    if NNE==3
        for i=1:elements
            % 三角形3个顶点的坐标：(x1, y1)，(x2, y2)，(x3, y3)
            x1=x_a(elem(i,1),1);
            x2=x_a(elem(i,2),1);
            x3=x_a(elem(i,3),1);
            y1=x_a(elem(i,1),2);
            y2=x_a(elem(i,2),2);
            y3=x_a(elem(i,3),2);
            % 根据顶点坐标计算三角形的重心
            xg(i,1)=(x1+x2+x3)/3;
            xg(i,2)=(y1+y2+y3)/3;
            % 根据顶点坐标计算三角形的面积
            Area(i)=abs((x1*y2+x2*y3+x3*y1-x1*y3-x3*y2-x2*y1)/2);
        end
    
    % 四边形网格
    elseif NNE==4
        for i=1:elements
            % 四边形4个顶点的坐标：(x1, y1)，(x2, y2)，(x3, y3)，(x4, y4)
            x1=x_a(elem(i,1),1);
            x2=x_a(elem(i,2),1);
            x3=x_a(elem(i,3),1);
            x4=x_a(elem(i,4),1);
            y1=x_a(elem(i,1),2);
            y2=x_a(elem(i,2),2);
            y3=x_a(elem(i,3),2);
            y4=x_a(elem(i,4),2);
            % 根据顶点坐标计算四边形的重心
            xg(i,1)=(x1+x2+x3+x4)/4;
            xg(i,2)=(y1+y2+y3+y4)/4;
            % 根据顶点坐标计算四边形的面积
            % 四边形面积可以拆分为两个三角形面积之和
            Area1=abs((x1*y2+x2*y3+x3*y1-x1*y3-x3*y2-x2*y1)/2);
            Area2=abs((x1*y4+x4*y3+x3*y1-x1*y3-x3*y4-x4*y1)/2);
            Area(i)=Area1+Area2;
        end
    end
        
end