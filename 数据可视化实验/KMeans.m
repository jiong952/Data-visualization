function [u re]=KMeans(data,N)   
    [m n]=size(data);   %m是数据个数，n是数据维数
    ma=zeros(n);        %每一维最大的数
    mi=zeros(n);        %每一维最小的数
    u=zeros(N,n);       %随机初始化，最终迭代到每一类的中心位置
    cid=zeros(1,m);     %用来标记该点所属聚类

    for i=1:n
       ma(i)=max(data(:,i));    %每一维最大的数
       mi(i)=min(data(:,i));    %每一维最小的数
       for j=1:N
            u(j,i)=ma(i)+(mi(i)-ma(i))*rand();  %随机初始化，不过还是在每一维[min max]中初始化好些
       end      
    end

    figure;
            a=get(gca);
        x=a.XLim;%获取横坐标上下限
        y=a.YLim;%获取纵坐标上下限
        x0=x(1)+(x(2)-x(1))*rand;%获取text横坐标
        y0=y(1)+(y(2)-y(1))*rand;%获取text纵坐标
       text(x0,y0,'张俊鸿 3120005043');    
        set(gcf,'menubar','none','toolbar','none');
        aviname='test.avi';
        aviobj=avifile(aviname);
        aviobj.quality=100;
        aviobj.compression='None';
        aviobj.fps=1;
        
    while 1
        pre_u=u;            %上一次求得的中心位置
        for i=1:N
            for j=1:m
                dist = sum((repmat(data(j,:), N, 1) - u).^2, 2); %欧式距离
                [junk, index]=min(dist);
                cid(j)=index;   %标记所属的聚类中心点
            end
        end

        for i = 1:N
            index = find(cid==i);
            u(i,:) = mean(data(index,:));
        end
        re=[data cid'];

        [m1 n1]=size(re);
         %最后显示聚类后的数据
        
         hold on;
         for i=1:N
              plot3(u(i,1),u(i,2),u(i,3),'kx','MarkerSize',12,'LineWidth',2);
         end
         for i=1:m1 
            if re(i,4)==1   
                plot3(re(i,1),re(i,2),re(i,3),'r*'); 
            elseif re(i,4)==2
                plot3(re(i,1),re(i,2),re(i,3),'g*'); 
            else 
                plot3(re(i,1),re(i,2),re(i,3),'b*'); 
            end
         end
         text(x0,y0,'张俊鸿 3120005043');
        grid on;
        hold off;
        frame = getframe;            % 把图像存入视频文件中
       aviobj=addframe(aviobj,frame); % 将帧写入视频

        if norm(pre_u-u)<0.001  %不断迭代直到位置不再变化
            aviobj=close(aviobj); % 关闭视频文件句柄
            break;
        else pause(0.5);plot(0,0,'w+');
        end 
    end
end
