clear
close all

rr = [1];

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

