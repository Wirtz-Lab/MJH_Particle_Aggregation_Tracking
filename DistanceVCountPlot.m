D1 = DistancePoints;
D2 = DistancePoints;
D3 = DistancePoints;

Points = vertcat(D1,D2,D3);

Ydata = Points(:,3);
Xdata = Points(:,2);
p = fit(Xdata,Ydata,'poly1');

figure();
scatter(D1(:,2),D1(:,3),'r');
hold on
scatter(D1(:,2),D1(:,3),'.r');
scatter(D2(:,2),D2(:,3),'b');
scatter(D2(:,2),D2(:,3),'.b');
scatter(D3(:,2),D3(:,3),'g');
scatter(D3(:,2),D3(:,3),'.g');
xlabel('Mean Distance');
ylabel('Aggregate Count');
plot(p,'-k');
hold off
