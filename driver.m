%clear
close all

rr = [0,0,1];
% 1 = example drydown, plot timeseries
% 2 = vary height/kmax (rooting constant)
% 3 = example drydown, tall vs. short plot psi_l vs. psi_s


if rr(3) > 0
    %parameter setup1
    kmax  = 2e-3;
    z     = 15;
    zr    = 3;
    p1    = -1;
    p2    = -4;
    p50   = -1.5;
    a     = 7;
    param = [kmax,z,p1,p2,p50,a];
    
    %experiment1
    psoil = -0.2;
    x=[];
    for day=1:60
        [out,psoil] = oneday(psoil,param,zr);
        x = [x;out];
    end
    
    %parameter setup2
    kmax  = 2e-3;
    z     = 40;
    zr    = 4;
    p1    = -1;
    p2    = -4;
    p50   = -2.5;
    a     = 7;
    param = [kmax,z,p1,p2,p50,a];
    
    %experiment2
    psoil = -0.2;
    y=[];
    for day=1:60
        [out,psoil] = oneday(psoil,param,zr);
        y = [y;out];
    end

    
    %plotting
    xdk = figure;
    subplot(1,2,1)
    plot(x(:,1),x(:,2),'.')
    hold on
    xlabel('Soil Potential (MPa)')
    ylabel('Leaf Potential (MPa)')
    title('Short (15m)')
    xlim([-1.1,0])
    ylim([-2,0])
    subplot(1,2,2)
    plot(y(:,1),y(:,2),'.')
    xlim([-1,0])
    ylim([-3.25,0])
    xlabel('Soil Potential (MPa)')
    ylabel('Leaf Potential (MPa)')
    title('Tall (40m)')
    
    xdk.Units = 'inches';
    xdk.Position = [2,2,7,3];
    xdk.PaperSize = [7,3];
    xdk.PaperPosition = [0,0,7,3];
    print(xdk,'figs/fig2a','-dpdf')
    
    xdk2 = figure;
    plot(x(25:48:end,1),x(25:48:end,2)-x(25,2),'.')
    hold on
    plot(y(25:48:end,1),y(25:48:end,2)-y(25,2),'.')    
    xlabel('Soil potential (MPa)')
    ylabel('\psileaf - \psileaf_0 (MPa)')
    title('Midday water potential')
    legend({'short','tall'},'location','northwest')
    xdk2.Units = 'inches';
    xdk2.Position = [2,2,4,3];
    xdk2.PaperSize = [4,3];
    xdk2.PaperPosition = [0,0,4,3];
    print(xdk2,'figs/fig2b','-dpdf')
    
    
    xdk3=figure;
    subplot(1,2,1)
    plot(0.5:0.5:24,x(1:48,4))
    hold on
    plot(0.5:0.5:24,y(1:48,4))
    title('Day1')
    xlabel('hour')
    ylabel('GPP')
    set(gca,'xtick',0:6:24)
    subplot(1,2,2)
    plot(0.5:0.5:24,x(end-47:end,4))
    hold on
    plot(0.5:0.5:24,y(end-47:end,4))
    title('Day60')
    legend({'short','tall'})
    set(gca,'xtick',0:6:24)
    ylim([0,25])
    xlabel('hour')
    ylabel('GPP')
    
        
    xdk3.Units = 'inches';
    xdk3.Position = [2,2,7,3];
    xdk3.PaperSize = [7,3];
    xdk3.PaperPosition = [0,0,7,3];
    print(xdk3,'figs/fig2c','-dpdf')

end



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
    xlabel('kmax')
    ylabel('tree height')
    h = colorbar;
    ylabel(h,'% of max GPP')
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

