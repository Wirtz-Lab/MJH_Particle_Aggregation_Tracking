%Read in images to create image sequences for analysis 
clear all;
close all;
clc; 
%Make changes here  
d = 190205 %date: Y,M,D

channelTitle = 'Please input the number of channels:';
definput = {'1'};
channelInput = inputdlg(prompt,channelTitle,[1 40],definput);
if isempty(channelInput)
    return
end

channels = str2double(channelInput{1,1}); ; % enter the number of channels (e.g. CFSE, PI, Phase)

plateTitle = 'Plate Input';
definput = {'1','1'};
xyInput = inputdlg(prompt,plateTitle,[1 40],definput);
if isempty(xyInput)
    return
end

NumX = str2double(xyInput{1,1});
NumY = str2double(xyInput{2,1});
NumXY = NumX*NumY;  

%%set directory with image files 
cd(uigetdir());
%count number of files for loop 
A = dir('*.tif'); 
n = numel(A);
%organize images by channel, position and time
stepSize = channels*NumXY;
timePoints = n/stepSize;
tic
for k = 1:stepSize
    wellNum = floor((k-1)/channels)+1;
    disp(wellNum);
    clear Names 
    clear ModeArray
    clear ObjectNums
    clear AvgArea
    clear PosNeg
    j=0;
    for i = k:stepSize:n  
%         j= ((i-1)/stepSize)+1;
        j=j+1;
        I = imread((A(i).name)); %Read image file
        Names(j) =  string(A(i).name);
        subplot(2,4,1);
        imshow(I);
        J = mat2gray(I);
        subplot(2,4,2)
        imshow(J)
        J_eq = imadjust(J);
        subplot(2,4,3);
        imshow(J_eq);
        Modes=mode(J_eq);%calculate background based on modal values and set threshold for image
        imgMode=sum(Modes(1,:)/length(Modes)); %correct modes 
        ModeArray(j)= imgMode;
        %create a binary image for the image
        J_eq(J_eq<imgMode) = 0; %Set all values below mode as 
        subplot(2,4,4);
        imshow(J_eq);
        BW =  bwareaopen(J_eq,25); %Need to set pixel size threshold 
        subplot(2,4,5);
        imshow(BW)
        BW(~(BW<imgMode))=255; %Set all values above the threshold as 255
        subplot(2,4,6);
        imshow(BW);
        [labeledImage, numberOfObject] = bwlabel(BW);
        numberOfPixels = numel(BW);
        numberOfTruePixels = sum(BW(:));
        
        cents = regionprops(BW,'Centroid'); %Transfer
        centroids = cat(1,cents.Centroid); %Transfer
        subplot(2,4,7); %Transfer
        imshow(BW); %transfer
        hold on %transfer
        plot(centroids(:,1),centroids(:,2),'c+'); %transfer
        hold off %transfer
        D = pdist2(centroids(:,1),centroids(:,2));%transfer
        avgD = mean2(D);%transfer
        
       
        
        AverageArea = numberOfTruePixels/numberOfObject;
        ObjectNums(j) = numberOfObject;
        AvgArea(j) = AverageArea; 
        PosNeg(j) = numberOfTruePixels/numberOfPixels;
        AvgD(j) = mean2(D)%Transfer       
        
        Well = strcat('well',num2str(wellNum))
            if strfind(Names(j),'c3'); 
            DataC3.(Well).FileNames = Names;
            DataC3.(Well).Background = ModeArray;
            DataC3.(Well).ObjectNumbers = ObjectNums;
            DataC3.(Well).ObjectAreas = AvgArea;
            DataC3.(Well).PosNegRatio = PosNeg;
            DataC3.(Well).ObjectDistances = avgD; %transfer
            elseif strfind(Names(j),'c1');
            DataC1.(Well).FileNames = Names;
            DataC1.(Well).Background = ModeArray;
            DataC1.(Well).ObjectNumbers = ObjectNums;
            DataC1.(Well).ObjectAreas = AvgArea;
            DataC1.(Well).PosNegRatio = PosNeg;
            DataC1.(Well).ObjectDistances = avgD; %transfer
            elseif strfind(Names(j),'c2');
            DataC2.(Well).FileNames = Names;
            DataC2.(Well).Background = ModeArray;
            DataC2.(Well).ObjectNumbers = ObjectNums;
            DataC2.(Well).ObjectAreas = AvgArea;
            DataC2.(Well).PosNegRatio = PosNeg;
            DataC2.(Well).ObjectDistances = avgD; %transfer
            end    
    end
end
toc
SaveFile = strcat(num2str(d),'NKaggregation','MJH');
save('190206Files','DataC1','DataC2','DataC3')