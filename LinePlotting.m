times = [1 15 30 43];
Data = DataC3;
welln = 'well9';
jj=1
for jj =1:length(times);
    t=times(1,jj)
    figure();
    plot(Data.(welln).BigObjectCentroids(t).BigObjectCentroids(:,1),Data.(welln).BigObjectCentroids(t).BigObjectCentroids(:,2),'.b','MarkerSize',10)
    whitebg('w');
    xlim([0 2048]);
    ylim([0 2048]);
    hold on 
    for ii=1:Data.(welln).BigObjectNumbers(t);
    plot([Data.(welln).BigObjectCentroids(t).BigObjectCentroids(1,1) Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,1)],[Data.(welln).BigObjectCentroids(t).BigObjectCentroids(1,2) Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,2)], '-y');
    lineLengths(ii)=pdist2([Data.(welln).BigObjectCentroids(t).BigObjectCentroids(1,1) Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,1)],[Data.(welln).BigObjectCentroids(t).BigObjectCentroids(1,2) Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,2)],'euclidean');
    plot([Data.(welln).BigObjectCentroids(t).BigObjectCentroids(end,1) Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,1)],[Data.(welln).BigObjectCentroids(t).BigObjectCentroids(end,2) Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,2)], '-r');
    lineLengths2(ii)=pdist2([Data.(welln).BigObjectCentroids(t).BigObjectCentroids(1,1) Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,1)],[Data.(welln).BigObjectCentroids(t).BigObjectCentroids(1,2) Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,2)],'euclidean');
    end
    hold off
    pointOneMean = mean(lineLengths(:,1));
    pointTwoMean = mean(lineLengths2(:,1));

    allMeansLengths = (pointOneMean+pointTwoMean)/2;
    DistancePoints(jj,1)= t;
    DistancePoints(jj,2)= allMeansLengths;
    DistancePoints(jj,3)= Data.(welln).BigObjectNumbers(t);
end 
% pointOneMean = mean(lineLengths(:,1));
% pointTwoMean = mean(lineLengths2(:,1));

% allMeansLengths = (pointOneMean+pointTwoMean)/2
figure();
plot(DistancePoints(:,1),DistancePoints(:,2));
hold on 
scatter(DistancePoints(:,1),DistancePoints(:,2),'r'); 
scatter(DistancePoints(:,1),DistancePoints(:,2),'.r'); 
xlabel('Time Point')
ylabel('Average Distance (pixels)')
hold off

figure();
scatter(DistancePoints(:,2),DistancePoints(:,3),'r');
hold on
scatter(DistancePoints(:,2),DistancePoints(:,3),'.r');
xlabel('Mean Distance')
ylabel('Aggregate Count')
hold off

%% PLOT ALL THE LINES!
Data = DataC1;
t=20;
welln = 'well9';

figure();
plot(Data.(welln).BigObjectCentroids(t).BigObjectCentroids(:,1),Data.(welln).BigObjectCentroids(t).BigObjectCentroids(:,2),'.b','MarkerSize',10)
whitebg('w');
xlim([0 2048]);
ylim([0 2048]);
hold on 
for ii =1:DataC1.(welln).BigObjectNumbers(t);
    
    FirstPoint = Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,1);
    SecondPoint = Data.(welln).BigObjectCentroids(t).BigObjectCentroids(ii,2);
    for jj=1:Data.(welln).BigObjectNumbers(t);
    plot([FirstPoint Data.(welln).BigObjectCentroids(t).BigObjectCentroids(jj,1)],[SecondPoint Data.(welln).BigObjectCentroids(t).BigObjectCentroids(jj,2)], '-y');
    end
end 
hold off
