%Read in images to create image sequences for analysis 
% clear all;
close all;
clc; 

%%set directory with image files 
cd(uigetdir());
%count number of files for loop 
A = dir('*.tif'); 
n = numel(A);

%Define variable necessary to process images 
prompt = {'Enter number of columns:','Enter number of rows:','Enter number of channels:','Enter date:'};
imagesTitles = 'Please input the following variables:'
definput = {'12','8','3','190212'}; 
imagesInput = inputdlg(prompt,imagesTitles,[1 40],definput);

if isempty(imagesInput);
    return
end

%Calculate plate size based on user input 
NumX = str2double(imagesInput{1,1});
NumY = str2double(imagesInput{2,1});
NumXY = NumX*NumY;  

%Calculate number of channels and step size based on user input 
channels = str2double(imagesInput{3,1});
stepSize = channels*NumXY;
timePoints = n/stepSize; %automatically calculate step size based on user input data and the number of files in the folder

%This date will be used for saving files at last step of the analysis
%module
d = str2double(imagesInput{4,1}); %date: Y,M,D


%ensure that there is not an error in the image series. 
r = mod(timePoints,1);
if r ~= 0; 
    warndlg('CHECK IMAGE SERIES FOR SEQUENCE ERROR!');
    prompt = {'Manual Override Time:'};
    tpTitle = 'Input timepoint number';
    definput = {'1'}; 
    timeInput = inputdlg(prompt,tpTitle,[1 40],definput);
    timePoints = str2double(timeInput{1,1});
else r == 0;
    timePoints = timePoints; 
end

  
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
        AverageArea = numberOfTruePixels/numberOfObject;
        ObjectNums(j) = numberOfObject;
        AvgArea(j) = AverageArea; 
        PosNeg(j) = numberOfTruePixels/numberOfPixels;
        
        Well = strcat('well',num2str(wellNum))
            if strfind(Names(j),'c3'); 
            DataC3.(Well).FileNames = Names;
            DataC3.(Well).Background = ModeArray;
            DataC3.(Well).ObjectNumbers = ObjectNums;
            DataC3.(Well).ObjectAreas = AvgArea;
            DataC3.(Well).PosNegRatio = PosNeg;
            elseif strfind(Names(j),'c1'); 
            DataC1.(Well).FileNames = Names;
            DataC1.(Well).Background = ModeArray;
            DataC1.(Well).ObjectNumbers = ObjectNums;
            DataC1.(Well).ObjectAreas = AvgArea;
            DataC1.(Well).PosNegRatio = PosNeg;    
            elseif strfind(Names(j),'c2'); 
            DataC2.(Well).FileNames = Names;
            DataC2.(Well).Background = ModeArray;
            DataC2.(Well).ObjectNumbers = ObjectNums;
            DataC2.(Well).ObjectAreas = AvgArea;
            DataC2.(Well).PosNegRatio = PosNeg;
            elseif strfind(Names(j),'c4'); 
            DataC4.(Well).FileNames = Names;
            DataC4.(Well).Background = ModeArray;
            DataC4.(Well).ObjectNumbers = ObjectNums;
            DataC4.(Well).ObjectAreas = AvgArea;
            DataC4.(Well).PosNegRatio = PosNeg;
            else strfind(Names(j),'c5'); 
            DataC5.(Well).FileNames = Names;
            DataC5.(Well).Background = ModeArray;
            DataC5.(Well).ObjectNumbers = ObjectNums;
            DataC5.(Well).ObjectAreas = AvgArea;
            DataC5.(Well).PosNegRatio = PosNeg;
            end    
    end
end
toc

%NEED TO CORRECT THIS BIT OF THE CODE!
% SaveFile = strcat(num2str(d),'NKaggregation','MJH');
save('190213Files','DataC1','DataC2','DataC3')