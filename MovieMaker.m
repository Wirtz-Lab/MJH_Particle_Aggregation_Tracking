timePoints = 27
welln = 'well14'
j=1
% u = uicontrol('Style','slider','Position',[10 50 20 340],...
%     'Min',1,'Max',timePoints,'Value',1);
for j = j:timePoints

A = DataC1.(welln).ObjectCentroids(j).AllobjectCents(:,1);
B = DataC1.(welln).ObjectCentroids(j).AllobjectCents(:,2);
C = DataC2.(welln).ObjectCentroids(j).AllobjectCents(:,1);
D = DataC2.(welln).ObjectCentroids(j).AllobjectCents(:,2);
% E = DataC3.(welln).ObjectCentroids(j).AllobjectCents(:,1);
% F = DataC3.(welln).ObjectCentroids(j).AllobjectCents(:,2);
% G = DataC4.(welln).ObjectCentroids(j).AllobjectCents(:,1);
% H = DataC4.(welln).ObjectCentroids(j).AllobjectCents(:,2);

% figure();
plot(A,B,'g.','MarkerSize',10);

hold on 
plot(C,D,'rx','MarkerSize',5);
% plot(E,F,'r.','MarkerSize',5);
% plot(G,H,'m.','MarkerSize',5);
xlim([0, 2048]);
ylim([0, 2048]);
whitebg('k');
hold off
M(j)= getframe;
end

movie(M,15)

