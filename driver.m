%clear
close all

rr = [0,0,0,0,2];
% 1 = example drydown, plot timeseries
% 2 = vary height/kmax (rooting constant)
% 3 = example drydown, tall vs. short plot psi_l vs. psi_s
% 4 = re-run tall, with short soil moisture
% 5 = also, increase VPD


if rr(3) > 0
    %parameter setup1
    kmax_other_units = 220;
    kmax  = kmax_other_units/1e6*18;
    kmax_kg          = kmax_other_units*18/1000/1000;
    
    z     = 15;
    zr    = 3;
    p1    = -1;
    p2    = -4;
    p50   = -1.5;
    a     = 6;
    param = [kmax,z,p1,p2,p50,a];
    
    %experiment1
    psoil = -0.2;
    x=[];
    for day=1:60
        [out,psoil] = oneday(psoil,param,zr,1);
        x = [x;out];
    end
    
    %parameter setup2
    kmax  = kmax_other_units/1e6*18;
    z     = 40;
    zr    = 4;
    p1    = -1;
    p2    = -4;
    p50   = -2.5;
    a     = 6;
    param = [kmax,z,p1,p2,p50,a];
    
    %experiment2
    psoil = -0.2;
    y=[];
    for day=1:60
        [out,psoil] = oneday(psoil,param,zr,1);
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
    if rr(3)>1
        print(xdk,'figs/fig3a','-dpdf')
    end
    
    xdk2 = figure;
    plot(x(25:48:end,1),x(25:48:end,2)-x(25,2),'.')
    hold on
    plot(y(25:48:end,1),y(25:48:end,2)-y(25,2),'.')
    xlabel('Soil potential (MPa)')
    ylabel('\psileaf - \psileaf_0 (MPa)')
    title('Midday water potential')
    legend({'short','tall'},'location','southeast')
    xdk2.Units = 'inches';
    xdk2.Position = [2,2,4,3];
    xdk2.PaperSize = [4,3];
    xdk2.PaperPosition = [0,0,4,3];
    if rr(3)>1
        print(xdk2,'figs/fig3b','-dpdf')
    end
    
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
    if rr(3)>1
        print(xdk3,'figs/fig3c','-dpdf')
    end
    
    
    
end

if rr(4)>0
    
    %parameter setup2 (tall)
    kmax  = kmax_other_units/1e6*18;
    z     = 40;
    zr    = 4;
    p1    = -1;
    p2    = -4;
    p50   = -2.5;
    a     = 6;
    param = [kmax,z,p1,p2,p50,a];
    
    %psoil forcing from short-tree experiment above
    psoil_vals = x(:,1);
    
    
    %experiment
    yy=[];
    for day=1:60
        psoil_in = psoil_vals((1:48)+48*(day-1));
        [out,psoil] = oneday(psoil_in,param,zr,1);
        yy = [yy;out];
    end
    
    
    %comparing photosynthesis
    e1s_d1  = sum(x(1:48,4))*1800/1e6*12  ;%gC/m2
    e1t_d1  = sum(y(1:48,4))*1800/1e6*12  ;%gC/m2
    e1s_d60 = sum(x(end-47:end,4))*1800/1e6*12 ; %gC/m2
    e1t_d60 = sum(y(end-47:end,4))*1800/1e6*12 ; %gC/m2
    e2t_d60 = sum(yy(end-47:end,4))*1800/1e6*12;  %gC/m2
    
    
    e1s_d60/e1s_d1;
    e1t_d60/e1t_d1;
    e2t_d60/e1t_d1;
    
    %calculating drops
    short_drop1  = min(x(1:48,2))-max(x(1:48,2))
    short_drop60 = min(x(end-47:end,2))-max(x(end-47:end,2))
    ddrop_s      = short_drop60-short_drop1
    ddrop_s/short_drop1
    
    tall_drop1   = min(yy(1:48,2))-max(yy(1:48,2))
    tall_drop60  = min(yy(end-47:end,2))-max(yy(end-47:end,2))
    ddrop_t      = tall_drop60-tall_drop1
    ddrop_t/tall_drop1
    
    %plotting
    
    xdk2 = figure;
    subplot(1,2,1)
    plot(x(25:48:end,1),x(25:48:end,2)-x(25,2),'.')
    hold on
    plot(y(25:48:end,1),y(25:48:end,2)-y(25,2),'.')
    xlabel('Soil potential (MPa)')
    ylabel('Midday \psileaf - \psileaf_0 (MPa)')
    title('Experiment 1')
    legend({'short','tall'},'location','southeast')
    text(-1.4,-0.1,'(a)','FontSize',14,'FontWeight','bold')
    subplot(1,2,2)
    plot(x(25:48:end,1),x(25:48:end,2)-x(25,2),'.')
    hold on
    plot(yy(25:48:end,1),yy(25:48:end,2)-yy(25,2),'.')
    text(-1.4,-0.1,'(b)','FontSize',14,'FontWeight','bold')
    xlabel('Soil potential (MPa)')
    title('Experiment 2')
    xdk2.Units = 'inches';
    xdk2.Position = [2,2,7,3];
    xdk2.PaperSize = [7,3];
    xdk2.PaperPosition = [0,0,7,3];
    if rr(4)>1
    print(xdk2,'figs/fig4a','-dpdf')
    end
    
    xdk2 = figure;
    subplot(1,3,1)
    plot(0.5:0.5:24,x(1:48,4))
    hold on
    plot(0.5:0.5:24,y(1:48,4))
    xlim([0,24])
    xlabel('Hour')
    ylabel('GPP (umol/m2/s)')
    set(gca,'xtick',0:6:24)
    title('Exp1, Day1')
    text(1.5,23,'(a)','FontSize',14,'FontWeight','bold')
    legend({'short','tall'},'location','southwest')
    subplot(1,3,2)
    plot(0.5:0.5:24,x(end-47:end,4))
    hold on
    plot(0.5:0.5:24,y(end-47:end,4))
    text(1.5,23,'(b)','FontSize',14,'FontWeight','bold')
    ylim([0,25])
    xlim([0,24])
    xlabel('Hour')
    set(gca,'xtick',0:6:24)
    title('Exp1, Day60')
    subplot(1,3,3)
    plot(0.5:0.5:24,x(end-47:end,4))
    hold on
    plot(0.5:0.5:24,yy(end-47:end,4))
    text(1.5,23,'(c)','FontSize',14,'FontWeight','bold')
    ylim([0,25])
    xlim([0,24])
    set(gca,'xtick',0:6:24)
    xlabel('Hour')
    title('Exp2, Day60')
    
    
    xdk2.Units = 'inches';
    xdk2.Position = [2,2,8,3];
    xdk2.PaperSize = [8,3];
    xdk2.PaperPosition = [0,0,8,3];
    if rr(4)>1
    print(xdk2,'figs/fig4b','-dpdf')
    end
    
    xdk = figure;
    subplot(1,2,1)
    plot(0.5:0.5:24,x(1:48,2),'k','LineWidth',1.5)
    hold on
    plot(0.5:0.5:24,x(end-47:end,2),'k-.','LineWidth',1.5)
    ylim([-3,0])
    text(1.5,-2.7,'(a)','FontSize',14,'FontWeight','bold')
    set(gca,'xtick',0:6:24)
    xlabel('Hour')
    ylabel('Leaf potential (MPa)')
    title('Short z=15m')
    legend('Day1','Day60','location','southeast')
    box off
    subplot(1,2,2)
    
    hold on
    plot(0.5:0.5:24,yy(1:48,2),'k','LineWidth',1.5)
    
    plot(0.5:0.5:24,yy(end-47:end,2),'k-.','LineWidth',1.5)
    text(1.5,-2.7,'(b)','FontSize',14,'FontWeight','bold')
    ylim([-3,0])
    set(gca,'xtick',0:6:24)
    xlabel('Hour')
    title('Tall z=40m')
    xdk.Units = 'inches';
    xdk.Position = [2,2,7,3];
    xdk.PaperSize = [7,3];
    xdk.PaperPosition = [0,0,7,3];
    if rr(4)>1
    print(xdk,'figs/fig4c','-dpdf')
    end
    

end



if rr(5)>0
    
    pp=-0.2
    
    %parameter setup1
    kmax_other_units = 220;
    kmax  = kmax_other_units/1e6*18;
    kmax_kg          = kmax_other_units*18/1000/1000;
    
    z     = 15;
    zr    = 3;
    p1    = -1;
    p2    = -4;
    p50   = -1.5;
    a     = 6;
    param = [kmax,z,p1,p2,p50,a];
    
    %experiment3
    psoil = pp*ones(2880,1);
    x3=[];
    for day=1:60
        [out,p] = oneday(psoil,param,zr,day);
        x3 = [x3;out];
    end
    
    %parameter setup2
    kmax  = kmax_other_units/1e6*18;
    z     = 40;
    zr    = 4;
    p1    = -1;
    p2    = -4;
    p50   = -2.5;
    a     = 6;
    param = [kmax,z,p1,p2,p50,a];
    
    %experiment3
    psoil = pp*ones(2880,1);
    y3=[];
    for day=1:60
        [out,p] = oneday(psoil,param,zr,day);
        y3 = [y3;out];
    end
    
    a = x3(24:48:end,4);
    a(end)-a(1)
    a = y3(24:48:end,4);
    a(end)-a(1)
    
    xdk = figure;
    plot(x3(24:48:end,5),x3(24:48:end,4),'.')
    hold on
    plot(y3(24:48:end,5),y3(24:48:end,4),'.')
    ylim([20,24])
    set(gca,'ytick',20:24)
    xlim([1.6,4.1])
    xlabel('VPD (kPa)')
    ylabel('GPP (\mu mol m^{-2} s^{-1})')
    title('Exp3: midday GPP vs. VPD')
    legend({'Short','Tall'},'location','Southwest')
    
    xdk.Units = 'inches';
    xdk.Position = [2,2,4,3];
    xdk.PaperSize = [4,3];
    xdk.PaperPosition = [0,0,4,3];
    if rr(5)>1
    print(xdk,'figs/fig5','-dpdf')
    end
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
                    [out,psoil] = oneday(psoil,param,zr,1);
                    x((1:48)+48*(dd-1),:)=out;
                end
                Amax = mean(x(1:48,4));
                Amin = mean(x(end-(47:-1:0),4));
                
                out1(i,j)=Amax;
                out2(i,j)=Amin;
            end
        end
    end
    
    xdk = figure;
    imagesc(kvals,zvals,out2./out1)
    xlabel('kmax')
    ylabel('tree height')
    h = colorbar;
    ylabel(h,'% of day1 GPP')
    title('60 day drydown')
    
    xdk.Units = 'inches';
    xdk.Position = [2,2,4,3];
    xdk.PaperSize = [4,3];
    xdk.PaperPosition = [0,0,4,3];
    print(xdk,'figs/fig2','-dpdf')
    
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
        [out,psoil] = oneday(psoil,param,zr,1);
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

