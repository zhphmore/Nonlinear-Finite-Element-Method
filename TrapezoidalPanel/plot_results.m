

function plot_results(x_a,elem,P,d,h,N,flag)

    [elements,NNE]=size(elem);
    [nodes,sp]=size(x_a);
    
    x=zeros(nodes,1);
    y=zeros(nodes,1);
    x1=zeros(nodes,1);
    y1=zeros(nodes,1);
    
    for i=1:nodes
        x(i,1)=x_a(i,1);
        y(i,1)=x_a(i,2);
        
        %Deformed coordinates
        x1(i)=x(i)+h*d(i*sp-1);
        y1(i)=y(i)+h*d(i*sp);
    end
    
    DDD=max(x(:));
    HHH=max(y(:));
    
%1.  Deformed shape
    
      figure
      if flag==1
        triplot(elem,x,y,'b'), hold on
        triplot(elem,x1,y1,'r')
      elseif flag==2
        quadplot(elem,x,y,'b'), 
        hold on
        quadplot(elem,x1,y1,'r')
      end
    
%2.  Pressure




    %Pressure in nodes
    PP=zeros(nodes,1);
    for i=1:elements
        p=N{i};
        for j=1:NNE
            PP(elem(i,j))=PP(elem(i,j))+P(i)*p(j);
        end                     
    end
    
    
    [xg1,yg1]=meshgrid(0:0.1:DDD,0:0.1:HHH);

    figure
    Pr=griddata(x,y,PP(:)/9800,xg1,yg1,'cubic');
    surf(xg1,yg1,Pr)
    colorbar
    axis([0,DDD,0,HHH])
    drawnow




end