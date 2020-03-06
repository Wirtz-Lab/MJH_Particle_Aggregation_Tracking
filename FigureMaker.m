

%Select channel of interest 
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

%NEED TO CREATE ERROR MESSAGE IF CHANNEL DOES NOT EXIST IN DATA
%STRUCTURE...
prompt = {'Enter number of columns:','Enter number of rows:','Start Well:','time Increment'}; 
titles = 'Plate Input';
definput = {'12','8','1','10'};
Inputs = inputdlg(prompt,titles,[1 40],definput);
if isempty(Inputs)
    return
end

NumX = str2double(Inputs{1,1});
NumY = str2double(Inputs{2,1});
StartWell = str2double(Inputs{3,1});
timeIncrement = str2double(Inputs{4,1});
Times = [1:timeIncrement:length(Data.well1.FileNames)*timeIncrement];
%Need to update the code to identify relationship between replicate wells
%on the plate! Create user defined tool to state replicates... 
n1 = StartWell;
if 0<n1<9 == true; % This relationship is correct
n2 = (2*NumY+1)-n1; %Correct
n3 = 2*NumY + n1; %Correct
elseif 24<n1<33 == true; %NEED TO FIX THIS SEGMENT OF THE CODE!!
n2 = (2*NumY + StartWell)+3*NumY;
n3 = (2*NumY+1-StartWell)+3*NumY;
elseif 48<n1<57 == true;
n2 = 3*(2*NumY+1)-StartWell;
% n3 = 3*(2*NumY) + StartWell;
else 72<n1<81 == true;
n2 = (4*NumY+1)-StartWell;
n3 = (4*NumY) + StartWell;
end

% DO NOT CHANGE CODE BEYOND THIS POINT 
Welln1 = strcat('well',num2str(n1));
Welln2 = strcat('well',num2str(n2));
Welln3 = strcat('well',num2str(n3));

%Plot the mean pixel area of the objects 
meanObj = mean(vertcat(Data.(Welln1).MeanObjectAreas,Data.(Welln2).MeanObjectAreas, Data.(Welln3).MeanObjectAreas));
stdObj = std(vertcat(Data.(Welln1).MeanObjectAreas,Data.(Welln2).MeanObjectAreas, Data.(Welln3).MeanObjectAreas));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Mean object area (pixels)');
ylabel('Pixels');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-r');

fig1 = figure('Name','Mean Values');
figure(fig1)
subplot(2,2,1);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-m');
title('Mean object area (pixels)');
ylabel('Pixels');
xlabel('t (min)');

%Plot the mean pixel area of the Aggregates 
meanObj = mean(vertcat(Data.(Welln1).BigMeanObjectAreas,Data.(Welln2).BigMeanObjectAreas, Data.(Welln3).BigMeanObjectAreas));
stdObj = std(vertcat(Data.(Welln1).BigMeanObjectAreas,Data.(Welln2).BigMeanObjectAreas, Data.(Welln3).BigMeanObjectAreas));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Mean Aggregate Area (pixels)');
ylabel('Pixels');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops',':r');

figure(fig1);
subplot(2,2,2);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops',':m');
title('Mean aggregate area (pixels)');
ylabel('Pixels');
xlabel('t (min)');


%Plot the median pixel area of the objects 
meanObj = mean(vertcat(Data.(Welln1).MedianObjectAreas,Data.(Welln2).MedianObjectAreas, Data.(Welln3).MedianObjectAreas));
stdObj = std(vertcat(Data.(Welln1).MedianObjectAreas,Data.(Welln2).MedianObjectAreas, Data.(Welln3).MedianObjectAreas));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Median Object Area (pixels)');
ylabel('Pixels');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-b');

fig2 = figure('Name','Median Values');
figure(fig2);
subplot(2,2,1);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-c');
title('Median object area (pixels)');
ylabel('Pixels');
xlabel('t (min)');


meanObj = mean(vertcat(Data.(Welln1).BigMedianObjectAreas,Data.(Welln2).BigMedianObjectAreas, Data.(Welln3).BigMedianObjectAreas));
stdObj = std(vertcat(Data.(Welln1).BigMedianObjectAreas,Data.(Welln2).BigMedianObjectAreas, Data.(Welln3).BigMedianObjectAreas));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Median Aggregate Area (pixels)');
ylabel('Pixels');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops',':b');

figure(fig2);
subplot(2,2,2);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops',':c');
title('Median aggregate area (pixels)');
ylabel('Pixels');
xlabel('t (min)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%Plot the object Eccentricities 
%NEED TO UPDATE THIS SECTION OF CODE 
meanObj = mean(vertcat(Data.(Welln1).MeanObjectEccen,Data.(Welln2).MeanObjectEccen, Data.(Welln3).MeanObjectEccen));
stdObj = std(vertcat(Data.(Welln1).MeanObjectEccen,Data.(Welln2).MeanObjectEccen, Data.(Welln3).MeanObjectEccen));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Mean object Eccentricity');
ylabel('Eccentricity');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-r');

figure(fig1)
subplot(2,2,3);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-m');
title('Mean object eccentricity');
ylabel('eccentricity');
xlabel('t (min)');

%Plot the eccentricity of the aggreagates 
meanObj = mean(vertcat(Data.(Welln1).BigMeanObjectEccen,Data.(Welln2).BigMeanObjectEccen, Data.(Welln3).BigMeanObjectEccen));
stdObj = std(vertcat(Data.(Welln1).BigMeanObjectEccen,Data.(Welln2).BigMeanObjectEccen, Data.(Welln3).BigMeanObjectEccen));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Mean Aggregate Eccentricity');
ylabel('Eccentricity');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops',':r');

figure(fig1)
subplot(2,2,4);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops',':m');
title('Mean object eccentricity');
ylabel('eccentricity');
xlabel('t (min)');


%Plot the median pixel area of the objects 
%NEED TO UPDATE THIS SECTION OF CODE! 
meanObj = mean(vertcat(Data.(Welln1).MedianObjectEccen,Data.(Welln2).MedianObjectEccen, Data.(Welln3).MedianObjectEccen));
stdObj = std(vertcat(Data.(Welln1).MedianObjectEccen,Data.(Welln2).MedianObjectEccen, Data.(Welln3).MedianObjectEccen));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Median Object Eccentricity');
ylabel('Eccentricity');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-b');

figure(fig2)
subplot(2,2,3);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-c');
title('Median object eccentricity');
ylabel('eccentricity');
xlabel('t (min)');

meanObj = mean(vertcat(Data.(Welln1).BigMedianObjectEccen,Data.(Welln2).BigMedianObjectEccen, Data.(Welln3).BigMedianObjectEccen));
stdObj = std(vertcat(Data.(Welln1).BigMedianObjectEccen,Data.(Welln2).BigMedianObjectEccen, Data.(Welln3).BigMedianObjectEccen));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Median Aggregate Eccentricity');
ylabel('Eccentricity');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops',':b');

figure(fig2)
subplot(2,2,4);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops',':c');
title('Median aggregate eccentricity');
ylabel('eccentricity');
xlabel('t (min)');
 
%%%%%%%%%%%%%%%%
%PLOT OBJECT NUMBERS AND DISTANCES%

%%%OBJECT COUNTS%%%
meanObj = mean(vertcat(Data.(Welln1).ObjectNumbers,Data.(Welln2).ObjectNumbers, Data.(Welln3).ObjectNumbers));
stdObj = std(vertcat(Data.(Welln1).ObjectNumbers,Data.(Welln2).ObjectNumbers, Data.(Welln3).ObjectNumbers));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Total number of Objects');
ylabel('Count');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-k');

fig3 = figure();
figure(fig3)
subplot(2,2,1);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-k');
title('Total number of objects');
ylabel('count');
xlabel('t (min)');

meanObj = mean(vertcat(Data.(Welln1).BigObjectNumbers,Data.(Welln2).BigObjectNumbers, Data.(Welln3).BigObjectNumbers));
stdObj = std(vertcat(Data.(Welln1).BigObjectNumbers,Data.(Welln2).BigObjectNumbers, Data.(Welln3).BigObjectNumbers));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Number of Aggregates');
ylabel('Count');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-k');

figure(fig3)
subplot(2,2,3);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-k');
title('Number of aggregates');
ylabel('count');
xlabel('t (min)');

%%%OBJECT DISTANCES%%%%
meanObj = mean(vertcat(Data.(Welln1).MeanObjectDist,Data.(Welln2).MeanObjectDist, Data.(Welln3).MeanObjectDist));
stdObj = std(vertcat(Data.(Welln1).MeanObjectDist,Data.(Welln2).MeanObjectDist, Data.(Welln3).MeanObjectDist));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Distance between objects');
ylabel('Distance (pixels)');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-k');

figure(fig3)
subplot(2,2,2);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-k');
title('Distance between objects');
ylabel('Distance (pixels)');
xlabel('t (min)');

meanObj = mean(vertcat(Data.(Welln1).BigMeanObjectDist,Data.(Welln2).BigMeanObjectDist, Data.(Welln3).BigMeanObjectDist));
stdObj = std(vertcat(Data.(Welln1).BigMeanObjectDist,Data.(Welln2).BigMeanObjectDist, Data.(Welln3).BigMeanObjectDist));
serObj = stdObj/sqrt(3);
 
smoothObj = smooth(meanObj,3,'moving');
smoothObjerr = smooth(serObj,3,'moving');

figure();
title('Distance between Aggreagates');
ylabel('Distance (pixels)');
xlabel('t (min)');
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-k');

figure(fig3)
subplot(2,2,4);
shadedErrorBar(Times,smoothObj,smoothObjerr,'lineprops','-k');
title('Distance between Aggreagates');
ylabel('Distance (pixels)');
xlabel('t (min)');