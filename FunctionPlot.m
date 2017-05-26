
[v,T,vT]=xlsread('Specimen_RawData_1.xlsx') 
% 'xlsx' for exell 2007
%v: Double
%T and vT : cell
%use v containing numbers 
e=v(:,5);f=v(:,3);
%if u have to plot second colone depending on first:

figure('Position', [500, 500, 650, 500]) % x,y,width,height
x1 = e; y1 = f;

x2 = 0:0.1:30
lnaught = .040 %mm
D = .0050 %mm
P = .135 %MPa
epsilon = 1.-x./lnaught
theta = 18. * pi / 180. 

y2 = pi*D.^2.*P.*(3.*(1.-epsilon).^2. /tan(theta).^2. - 1/sin(theta).^2.)/4.

hold on
plot(x1,y1,'Color','b')
plot(x2,y2,'Color','r','linewidth',4)
hold off

%hl1 = line(x1,y1,'Color','b');
%hl2 = line(x2,y2,'Color','k','Parent',ax2); 

legend('Measured','Predicted','Location','NorthWest')

ax1 = gca;
set(ax1,'XColor','k','YColor','k') 
set(gca,'ylim',[0,50])
set(gca,'xlim',[-3,32])
% set(gca,'xscale','log','yscale','log','ylim',[1e-2,1e3])
xlabel('Extension (mm)')
ylabel('Force (F)')

title('Force Characterization of a Single McKibben Actuator','FontSize',12)
