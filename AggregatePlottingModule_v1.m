%This module plots only single traces for individual wells 

close all 
clear thisWell;
%User defined well-of-interest. Enter a well number to generate plots for
%that well.
prompt = {'Enter number of well that you want to plot:','Enter Time Increment'}; 
promptTitle = 'Figure Input:';
definput = {'1','10'};
plotInputs = inputdlg(prompt,promptTitle,[1 40],definput);
if isempty(plotInputs);
    warndlg('please input a well number...');
    return
end
timeIncrement = str2double(plotInputs{2,1});
thisWell = str2double(plotInputs{1,1}); %Which well are you intersted in plotting? Input here. 


list = {'DataC1','DataC2','DataC3','DataC4','DataC5'};
[index,tf] = listdlg('ListString',list);
if length(index) ~=1 
    warndlg('Select 1 variable...');
    return 
elseif index(1) == 1 
    Data = DataC1; 
elseif index(1) == 2 
    Data = DataC2;
elseif index(1) == 3 
    Data = DataC3; 
elseif index(1) == 4 
    Data = DataC4;
else index(1) == 5
    Data = DataC5;    
end

EndTime = length(Data.well1.FileNames)*timeIncrement;
Times = [1:timeIncrement:EndTime];

whitebg('w');
% DON'T CHANGE CODE BEYOND THIS POINT! 
Welln = strcat('well',num2str(thisWell));
figure() %plot channel 1
title('Channel 1');
subplot(3,2,1);
yyaxis left
title('C1 - Count');
plot(Times,DataC1.(Welln).ObjectNumbers,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC1.(Welln).BigObjectNumbers,'red')
ylabel('Aggregates');


subplot(3,2,2);
yyaxis left
title('C1 - Distance');
plot(Times,DataC1.(Welln).MeanObjectDist,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC1.(Welln).BigMeanObjectDist,'red')
ylabel('Aggregates');

subplot(3,2,3);
yyaxis left
title('C1 - Mean Area');
plot(Times,DataC1.(Welln).MeanObjectAreas,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC1.(Welln).BigMeanObjectAreas,'red')
ylabel('Aggregates');

subplot(3,2,4);
yyaxis left
title('C1 - Median Area');
plot(Times,DataC1.(Welln).MedianObjectAreas,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC1.(Welln).BigMedianObjectAreas,'red')
ylabel('Aggregates');

subplot(3,2,5);
yyaxis left
title('C1 - Mean Eccentricity');
plot(Times,DataC1.(Welln).MeanObjectEccen,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC1.(Welln).BigMeanObjectEccen,'red')
ylabel('Aggregates');

subplot(3,2,6);
yyaxis left
title('C1 - Median Eccentricity');
plot(Times,DataC1.(Welln).MedianObjectEccen,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC1.(Welln).BigMedianObjectEccen,'red')
ylabel('Aggregates');




figure() %plot channel 2
title('Channel 2');
subplot(3,2,1);
yyaxis left
title('C2 - Count');
plot(Times,DataC2.(Welln).ObjectNumbers,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC2.(Welln).BigObjectNumbers,'red')
ylabel('Aggregates');


subplot(3,2,2);
yyaxis left
title('C2 - Distance');
plot(Times,DataC2.(Welln).MeanObjectDist,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC2.(Welln).BigMeanObjectDist,'red')
ylabel('Aggregates');

subplot(3,2,3);
yyaxis left
title('C2 - Mean Area');
plot(Times,DataC2.(Welln).MeanObjectAreas,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC2.(Welln).BigMeanObjectAreas,'red')
ylabel('Aggregates');

subplot(3,2,4);
yyaxis left
title('C2 - Median Area');
plot(Times,DataC2.(Welln).MedianObjectAreas,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC2.(Welln).BigMedianObjectAreas,'red')
ylabel('Aggregates');

subplot(3,2,5);
yyaxis left
title('C2 - Mean Eccentricity');
plot(Times,DataC2.(Welln).MeanObjectEccen,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC2.(Welln).BigMeanObjectEccen,'red')
ylabel('Aggregates');

subplot(3,2,6);
yyaxis left
title('C2 - Median Eccentricity');
plot(Times,DataC2.(Welln).MedianObjectEccen,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC2.(Welln).BigMedianObjectEccen,'red')
ylabel('Aggregates');

figure()%plot channel 3 
title('Channel 3');
subplot(3,2,1);
yyaxis left
title('C3 - Count');
plot(Times,DataC3.(Welln).ObjectNumbers,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC3.(Welln).BigObjectNumbers,'red')
ylabel('Aggregates');


subplot(3,2,2);
yyaxis left
title('C3 - Distance');
plot(Times,DataC3.(Welln).MeanObjectDist,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC3.(Welln).BigMeanObjectDist,'red')
ylabel('Aggregates');

subplot(3,2,3);
yyaxis left
title('C3 - Mean Area');
plot(Times,DataC3.(Welln).MeanObjectAreas,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC3.(Welln).BigMeanObjectAreas,'red')
ylabel('Aggregates');

subplot(3,2,4);
yyaxis left
title('C3 - Median Area');
plot(Times,DataC3.(Welln).MedianObjectAreas,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC3.(Welln).BigMedianObjectAreas,'red')
ylabel('Aggregates');

subplot(3,2,5);
yyaxis left
title('C3 - Mean Eccentricity');
plot(Times,DataC3.(Welln).MeanObjectEccen,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC3.(Welln).BigMeanObjectEccen,'red')
ylabel('Aggregates');

subplot(3,2,6);
yyaxis left
title('C3 - Median Eccentricity');
plot(Times,DataC3.(Welln).MedianObjectEccen,'blue');
xlabel('Time (min)');
ylabel('All Objects');
yyaxis right 
plot(Times,DataC3.(Welln).BigMedianObjectEccen,'red')
ylabel('Aggregates');

% figure()%plot channel 4 
% title('Channel 4');
% subplot(3,2,1);
% yyaxis left
% title('C4 - Count');
% plot(Times,DataC4.(Welln).ObjectNumbers,'blue');
% xlabel('Time (min)');
% ylabel('All Objects');
% yyaxis right 
% plot(Times,DataC4.(Welln).BigObjectNumbers,'red')
% ylabel('Aggregates');
% 
% 
% subplot(3,2,2);
% yyaxis left
% title('C4 - Distance');
% plot(Times,DataC4.(Welln).MeanObjectDist,'blue');
% xlabel('Time (min)');
% ylabel('All Objects');
% yyaxis right 
% plot(Times,DataC4.(Welln).BigMeanObjectDist,'red')
% ylabel('Aggregates');
% 
% subplot(3,2,3);
% yyaxis left
% title('C4 - Mean Area');
% plot(Times,DataC4.(Welln).MeanObjectAreas,'blue');
% xlabel('Time (min)');
% ylabel('All Objects');
% yyaxis right 
% plot(Times,DataC4.(Welln).BigMeanObjectAreas,'red')
% ylabel('Aggregates');
% 
% subplot(3,2,4);
% yyaxis left
% title('C4 - Median Area');
% plot(Times,DataC4.(Welln).MedianObjectAreas,'blue');
% xlabel('Time (min)');
% ylabel('All Objects');
% yyaxis right 
% plot(Times,DataC4.(Welln).BigMedianObjectAreas,'red')
% ylabel('Aggregates');
% 
% subplot(3,2,5);
% yyaxis left
% title('C4 - Mean Eccentricity');
% plot(Times,DataC4.(Welln).MeanObjectEccen,'blue');
% xlabel('Time (min)');
% ylabel('All Objects');
% yyaxis right 
% plot(Times,DataC4.(Welln).BigMeanObjectEccen,'red')
% ylabel('Aggregates');
% 
% subplot(3,2,6);
% yyaxis left
% title('C4 - Median Eccentricity');
% plot(Times,DataC4.(Welln).MedianObjectEccen,'blue');
% xlabel('Time (min)');
% ylabel('All Objects');
% yyaxis right 
% plot(Times,DataC4.(Welln).BigMedianObjectEccen,'red')
% ylabel('Aggregates');

figure();
plot(Times,DataC1.(Welln).Background,'green');
hold on
plot(Times,DataC2.(Welln).Background,'red');
plot(Times,DataC3.(Welln).Background,'black');
% plot(Times,DataC4.(Welln).Background,'blue');
% plot(Times,DataC5.(Welln).Background,'cyan');
hold off
ylim([0 1]);
ylabel('Background');
xlabel('Time (min)');
