close all;
clc; 

%user input variables 
%Select Channel from dropdown data list
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

%Input the number of columns
prompt = {'Enter number of columns:','Enter number of rows:'}; 
titles = 'Plate Input';
definput = {'12','8'};
xy = inputdlg(prompt,titles,[1 40],definput);
if isempty(xy)
    return
end

NumX = str2double(xy{1,1});
NumY = str2double(xy{2,1});

list2 = {'ObjectNumbers','BigObjectNumbers','MeanObjectAreas','MedianObjectAreas','BigMeanObjectAreas','BigMedianObjectAreas','MeanObjectEccen','MedianObjectEccen','BigMeanObjectEccen','BigMedianObjectEccen','MeanObjectDist','BigMeanObjectDist','Background'};
[index2,tf2] = listdlg('ListString',list2);
% Feature = 'ObjectNumbers'; %Call the array of interest

if length(index2) ~=1; 
    warndlg('Select 1 variable...');
    return 
elseif index2(1) == 1; 
    Feature = 'ObjectNumbers'; 
    TitleA = 'Change Object Count' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Object Count' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Object Count'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Object Count'; %titel for h4, which gives the percentage change in values 

elseif index2(1) == 2; 
    Feature = 'BigObjectNumbers';
    TitleA = 'Change Aggregate Count' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Aggregate Count' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Aggregate Count'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Aggregate Count'; %titel for h4, which gives the percentage change in values 

elseif index2(1) == 3; 
    Feature = 'MeanObjectAreas'; 
    TitleA = 'Change Object Mean Area' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Object Mean Area' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Object Mean Area'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Object Mean Area'; %titel for h4, which gives the percentage change in values 

elseif index2(1) == 4; 
    Feature = 'MedianObjectAreas';
    TitleA = 'Change Object Median Area' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Object Median Area' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Object Median Area'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Object Median Area'; %titel for h4, which gives the percentage change in values 

elseif index2(1) == 5; 
    Feature = 'BigMeanObjectAreas';
    TitleA = 'Change Aggregate Mean Area' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Aggregate Mean Area' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Aggregate Mean Area'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Aggregate Mean Area'; %titel for h4, which gives the percentage change in values 

elseif index2(1) == 6; 
    Feature = 'BigMedianObjectAreas';
    TitleA = 'Change Aggregate Median Area' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Aggregate Median Area' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Aggregate Median Area'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Aggregate Median Area'; %titel for h4, which gives the percentage change in values 

elseif index2(1) == 7; 
    Feature = 'MeanObjectEccen';
    TitleA = 'Change Object Mean Ecc.' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Object Mean Ecc.' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Aggregate Mean Ecc.'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Aggregate Mean Ecc.';
    
elseif index2(1) == 8; 
    Feature = 'MedianObjectEccen';
    TitleA = 'Change Object Median Ecc.' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Object Median Ecc.' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Object Median Ecc.'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Object Median Ecc.';
    
elseif index2(1) == 9; 
    Feature = 'BigMeanObjectEccen';
    TitleA = 'Change Aggregate Mean Ecc.' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Aggregate Mean Ecc.' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Aggregate Mean Ecc.'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Aggregate Mean Ecc.';

elseif index2(1) == 10; 
    Feature = 'BigMedianObjectEccen';
    TitleA = 'Change Aggregate Median Ecc.' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Aggregate Median Ecc.' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Aggregate Median Ecc.'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Aggregate Median Ecc.';

elseif index2(1) == 10; 
    Feature = 'MeanObjectDist';
    TitleA = 'Change Object Distance' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Object Distance' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Object Distance'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Object Distance';
    
elseif index2(1) == 11; 
    Feature = 'BigMeanObjectDist';
    TitleA = 'Change Aggregate Distance' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Aggregate Distance' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Aggregate Distance'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Aggregate Distance';

else index2(1) == 12; 
    Feature = 'Background';
    TitleA = 'Change Background' ;% Title for h1, which shows differneces between start point and end point 
    TitleB = 'Start Background' ;% Title for h2, which gives heatmap of initial values 
    TitleC = 'End Background'; % Title for h3, which gives heatmap of final values 
    TitleD = 'Percent Change Background';
end

%Assign titles to heatmaps 
% TitleA = 'Change Aggregate Area' ;% Title for h1, which shows differneces between start point and end point 
% TitleB = 'Start Area Aggregates' ;% Title for h2, which gives heatmap of initial values 
% TitleC = 'End Area Aggregates'; % Title for h3, which gives heatmap of final values 
% TitleD = 'Percent Change in Area'; %titel for h4, which gives the percentage change in values 

%assign count variables 
kk = 1;
k = 1;

NumXY = NumX*NumY; %Calculate plate size 

for k = k:NumXY
    Welln = strcat('well',num2str(k));
    
    areaStart(k) =  Data.(Welln).(Feature)(1);
    areaEnd(k) = Data.(Welln).(Feature)(end);
end 

% 
for kk = kk:NumX
%     areaStartm = zeros(NumY,NumX);
%     areaEndm = zeros(NumY,NumX)
    if kk == 1; 
        NumY1 = NumXY;
        NumY2 = (NumY1 - NumY)+1;
        Row = (areaStart(NumY2:NumY1));
        Row2 = (areaEnd(NumY2:NumY1));
        areaStartm(:,kk) = Row;
        areaEndm(:,kk) = Row2;
    else kk ~= 1;
        NumY1 = NumY2-1;
        NumY2 = (NumY1 - NumY)+1;
        Row = (areaStart(NumY2:NumY1));
        Row2 = (areaEnd(NumY2:NumY1));
        areaStartm(:,kk)= Row;
        areaEndm(:,kk) = Row2;
    end
end    

plateChange = areaEndm - areaStartm; %Calculates change in values between first and last time points of experiment 

plateChangePercent = 100*plateChange./areaStartm;


%plots heatmaps of data 
figure;
h1 = heatmap(plateChange);
h1.Title = TitleA;
h1.Colormap = pink;


figure;
h2 = heatmap(areaStartm);
h2.Title = TitleB;
h2.Colormap = pink;

figure;
h3 = heatmap(areaEndm);
h3.Title = TitleC;
h3.Colormap = pink;

figure; 
h4 = heatmap(plateChangePercent);
h4.Title = TitleD;
h4.Colormap = pink;