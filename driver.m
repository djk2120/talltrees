%clear
close all

rr = [0,1];
% 1 = example drydown
% 2 = vary height/kmax (rooting constant)


if rr(2)>0
    
    kmax  = 4e-3;
    z     = 20;
    zr    = 3;
    p1    = -1;
    p2    = -4;
    p50   = -1.6;
    a     = 7;
    
    
    kvals = linspace(1e-3,5e-3,100);
    zvals = linspace(15,40,100);
    if 1==2
    out1 = zeros(100,100);
    out2 = zeros(100,100);
    
    for i=1:100
        disp(i)
        for j=1:100
            param = [kvals(i),zvals(j),p1,p2,p50,a];
            %experiment
            psoil = -0.2;
            dmax  = 60;
            x=zeros(48*dmax,4);
            for dd=1:dmax
                [out,psoil] = oneday(psoil,param,zr);
                x((1:48)+48*(dd-1),:)=out;
            end
            Amax = mean(x(1:48,4));
            Amin = mean(x(end-(47:-1:0),4));
            
            out1(i,j)=Amax;
            out2(i,j)=Amin;
        end
    end
    end    
            
    imagesc(kvals,zvals,out2./out1)
    colorbar
end



if rr(1)>0
    %parameter setup
    kmax  = 4e-3;
    z     = 20;
    zr    = 3;
    p1    = -1;
    p2    = -4;
    p50   = -1.6;
    a     = 7;
    param = [kmax,z,p1,p2,p50,a];
    
    %experiment
    psoil = -0.2;
    x=[];
    for i=1:60
        [out,psoil] = oneday(psoil,param,zr);
        x = [x;out];
    end
    
    %plotting
    xdk = figure;
    subplot(1,2,1)
    plot(x(:,1))
    hold on
    plot(x(:,2))
    set(gca,'xtick',216:48*10:length(x))
    set(gca,'xticklabel',5:10:length(x)/48)
    xlim([0 length(x)+1])
    xlabel('day')
    ylabel('water potential (MPa)')
    legend('soil','leaf')
    
    daily = repmat(1:length(x)/48,48,1);
    daily = daily(:);
    out   = splitapply(@mean,x(:,4),daily);
    subplot(1,2,2)
    plot(out)
    xlim([0 length(out)+1])
    ylim([0 9])
    set(gca,'xtick',5:10:length(out))
    xlabel('day')
    ylabel('daily mean GPP')
    
    xdk.Units = 'inches';
    xdk.Position = [2,2,7,3];
    xdk.PaperSize = [7,3];
    xdk.PaperPosition = [0,0,7,3];
    print(xdk,'figs/fig1','-dpdf')
end

