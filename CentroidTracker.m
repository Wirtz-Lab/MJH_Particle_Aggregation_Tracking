prompt = {'Number of directories:'}; 
titles = 'Directory Number';
definput = {'2'};
NumDir = inputdlg(prompt,titles,[1 40],definput);
if isempty(NumDir)
    return
end

for p = 1:str2double(NumDir{1,1});
paths{p} = uigetdir();
end

prompt = {'Enter number of columns:','Enter number of rows:','Enter number of channels:','Enter date:','Debris Threshold:','Size scale factor:'};
imagesTitles = 'Please input the following variables:';
definput = {'12','8','3','190212','25','5'}; 
imagesInput = inputdlg(prompt,imagesTitles,[1 40],definput);

if isempty(imagesInput);
    return
end

NumX = str2double(imagesInput{1,1});
NumY = str2double(imagesInput{2,1});
NumXY = NumX*NumY; % Calculate the plate size based on the column and row data  
sizeThreshold = str2double(imagesInput{5,1}); %Disregard objects below the 'debris filter' size (pixel area)
scaleFactor = str2double(imagesInput{6,1}); %This value can be varied to remove single cell data from the analysis 
LargeThreshold = scaleFactor*sizeThreshold; %Necessary to identify only the largest objects

channels = str2double(imagesInput{3,1}); %User input the number of channels to calculate step size  
stepSize = channels*NumXY; %Step size between sequential well images 

%This date will be used for saving files at last step of the analysis
%module
d = imagesInput{4,1};

tic

for pp = 1:length(paths);
    disp(strcat('Folder_',num2str(pp)))
    cd(paths{pp}) 
    A = dir('*.tif'); 
    n = numel(A);
    
    timePoints = n/stepSize; %automatically calculate step size based on user input data and the number of files in the folder
        
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
    
        for k = 1:stepSize
        wellNum = floor((k-1)/channels)+1;
        disp(wellNum);
        clear Names ModeArray AllCount BigCount meanArea medianArea BigmeanArea BigmedianArea meanEcc medianEcc BigmeanEcc BigmedianEcc meanDist BigmeanDist

        j=0;
        for i = k:stepSize:n  
    %         j= ((i-1)/stepSize)+1;
            j=j+1;
            I = imread((A(i).name)); %Read image file
            Names(j) =  string(A(i).name);
%             figure();
%             subplot(2,4,1);
%             imshow(I);
            J = mat2gray(I);
%             subplot(2,4,2)
%             imshow(J)
            J_eq = imadjust(J);
%             subplot(2,4,3);
%             imshow(J_eq);
            Modes=mode(J_eq);%calculate background based on modal values and set threshold for image
            imgMode=mean(Modes); %correct modes 
            ModeArray(j)= imgMode;
            %create a binary image for the image
            J_eq(J_eq<imgMode) = 0; %Set all values below mode as 
%             subplot(2,4,4);
%             imshow(J_eq);
            BW =  bwareaopen(J_eq,sizeThreshold); %User input debris Threshold gating 
%             subplot(2,4,5);
%             imshow(BW)
            BW(~(BW<imgMode))=255; %Set all values above the threshold as 255
%             subplot(2,4,6);
%             imshow(BW);
            [labeledImage, numberOfObject] = bwlabel(BW);
            numberOfPixels = numel(BW);
            numberOfTruePixels = sum(BW(:));
            ImageProps = regionprops(BW,'Centroid','Area','Eccentricity');

            Areas = cat(1,ImageProps.Area);
            Eccentricity = cat(1,ImageProps.Eccentricity);
            centroids = cat(1,ImageProps.Centroid);

            AxExC = horzcat(Areas,Eccentricity,centroids); %Create Matrix of Properties
            AEClarge = AxExC(AxExC(:,1)>LargeThreshold,:); %Find Largest Objects based on Size Threshold
            AllCount(j) = length(AxExC(:,1));
            BigCount(j) = length(AEClarge(:,1));

            meanSOarea = mean(AxExC(:,1)); %mean area of ALL objects
            medianSOarea = median(AxExC(:,1)); %Median area of ALL objects
            meanArea(j) = meanSOarea;
            medianArea(j) = medianSOarea;

            meanLOarea = mean(AEClarge(:,1)); %Mean area of Large Objects
            medianLOarea = median(AEClarge(:,1)); %Median area of large objects
            BigmeanArea(j) = meanLOarea;
            BigmedianArea(j) = medianLOarea;

            meanSOecc = mean(AxExC(:,2)); %mean eccentricity of ALL objects
            medianSOecc = median(AxExC(:,2)); %Median eccentricity of ALL objects
            meanEcc(j) = meanSOecc;
            medianEcc(j) = medianSOecc;

            meanLOecc = mean(AEClarge(:,2)); %mean eccentricity of large objects
            medianLOecc= median(AEClarge(:,2));%Median eccentricity of large objects
            BigmeanEcc(j) = meanLOecc;
            BigmedianEcc(j) = medianLOecc;

%             subplot(2,4,7); %Plot centroids of all objects over B&W image
%             imshow(J_eq);
%             hold on 
%             plot(AxExC(:,3),AxExC(:,4),'c+'); 
%             plot(AEClarge(:,3),AEClarge(:,4),'mo');
%             hold off 
            miniStructureOne(j).AllobjectCents = AxExC(:,3:4);
            miniStructureTwo(j).BigObjectCentroids = AEClarge(:,3:4);
%             objCents(1:length(AxExC),j*2-1:j*2) = AxExC(:,3:4);
%             bigObjCents(1:length(AEClarge),j*2-1:j*2) = AEClarge(:,3:4);
%             plot(bigObjCents(:,1),bigObjCents(:,2),'mo','MarkerSize',12);
%             xlim([0 2048]);
%             ylim([0 2048]);
%             whitebg('k');
%             hold on
%             plot(objCents(:,1),objCents(:,2),'c+');
            
            SOdist = pdist2(AxExC(:,3),AxExC(:,4));%calculate distances between all objects, including small objects
            meanSOdist = mean2(SOdist);%Mean distance between all objects
            meanDist(j) = meanSOdist;

    %         subplot(2,4,8);
    %         imshow(BW);
    %         hold on
    %         plot(AEClarge(:,3),AEClarge(:,4),'r+'); 
    %         hold off 
            LOdist = pdist2(AEClarge(:,3),AEClarge(:,4));%calculate distances between large objects
            meanLOdist = mean2(LOdist);
            BigmeanDist(j) = meanLOdist;


    %         figure();
    %         subplot(2,2,1);
    %         h = histogram(AxExC(:,1),75);
    %         h.FaceColor = [0 0 0];
    %         title('Area all objects(pixels)');
    %         ylabel('count');
    %         xlabel('area');
    %         set(gca, 'XScale', 'linear');
    %         subplot(2,2,2);
    %         h2 = histogram(AEClarge(:,1),75);
    %         title('Area large objects(pixels)');
    %         ylabel('count');
    %         xlabel('area');
    %         h2.FaceColor = [1 0 0];
    %         set(gca, 'XScale', 'linear');


    %         subplot(2,2,3:4);
    %         h = histogram(AxExC(:,2),75);
    %         h.FaceColor = [0 0 0];
    %         title('Eccentricity');
    %         set(gca, 'XScale', 'linear');
    %         hold on;
    %         subplot(2,2,3:4);
    %         h2 = histogram(AEClarge(:,2),75);
    %         title('Eccentricity');
    %         ylabel('count');
    %         h2.FaceColor = [1 0 0];
    %         set(gca, 'XScale', 'linear');

            Well = strcat('well',num2str(wellNum))
                if strfind(Names(j),'c3'); 
                DataC3.(Well).FileNames = Names;
                DataC3.(Well).Background = ModeArray;
                DataC3.(Well).ObjectNumbers = AllCount;
                DataC3.(Well).BigObjectNumbers = BigCount;
                DataC3.(Well).MeanObjectAreas = meanArea;
                DataC3.(Well).MedianObjectAreas = medianArea;
                DataC3.(Well).BigMeanObjectAreas = BigmeanArea;
                DataC3.(Well).BigMedianObjectAreas = BigmedianArea;
                DataC3.(Well).MeanObjectEccen = meanEcc;
                DataC3.(Well).MedianObjectEccen = medianEcc;
                DataC3.(Well).BigMeanObjectEccen = BigmeanEcc;
                DataC3.(Well).BigMedianObjectEccen = BigmedianEcc;
                DataC3.(Well).MeanObjectDist = meanDist;
                DataC3.(Well).BigMeanObjectDist = BigmeanDist;
                DataC3.(Well).ObjectCentroids = miniStructureOne; 
                DataC3.(Well).BigObjectCentroids = miniStructureTwo;  
                elseif strfind(Names(j),'c1'); 
                DataC1.(Well).FileNames = Names;
                DataC1.(Well).Background = ModeArray;
                DataC1.(Well).ObjectNumbers = AllCount;
                DataC1.(Well).BigObjectNumbers = BigCount;
                DataC1.(Well).MeanObjectAreas = meanArea;
                DataC1.(Well).MedianObjectAreas = medianArea;
                DataC1.(Well).BigMeanObjectAreas = BigmeanArea;
                DataC1.(Well).BigMedianObjectAreas = BigmedianArea;
                DataC1.(Well).MeanObjectEccen = meanEcc;
                DataC1.(Well).MedianObjectEccen = medianEcc;
                DataC1.(Well).BigMeanObjectEccen = BigmeanEcc;
                DataC1.(Well).BigMedianObjectEccen = BigmedianEcc;
                DataC1.(Well).MeanObjectDist = meanDist;
                DataC1.(Well).BigMeanObjectDist = BigmeanDist;
                DataC1.(Well).ObjectCentroids = miniStructureOne; 
                DataC1.(Well).BigObjectCentroids = miniStructureTwo;
                elseif strfind(Names(j),'c2'); 
                DataC2.(Well).FileNames = Names;
                DataC2.(Well).Background = ModeArray;
                DataC2.(Well).ObjectNumbers = AllCount;
                DataC2.(Well).BigObjectNumbers = BigCount;
                DataC2.(Well).MeanObjectAreas = meanArea;
                DataC2.(Well).MedianObjectAreas = medianArea;
                DataC2.(Well).BigMeanObjectAreas = BigmeanArea;
                DataC2.(Well).BigMedianObjectAreas = BigmedianArea;
                DataC2.(Well).MeanObjectEccen = meanEcc;
                DataC2.(Well).MedianObjectEccen = medianEcc;
                DataC2.(Well).BigMeanObjectEccen = BigmeanEcc;
                DataC2.(Well).BigMedianObjectEccen = BigmedianEcc;
                DataC2.(Well).MeanObjectDist = meanDist;
                DataC2.(Well).BigMeanObjectDist = BigmeanDist;  
                DataC2.(Well).ObjectCentroids = miniStructureOne; 
                DataC2.(Well).BigObjectCentroids = miniStructureTwo;
                elseif strfind(Names(j),'c4'); 
                DataC4.(Well).FileNames = Names;
                DataC4.(Well).Background = ModeArray;
                DataC4.(Well).ObjectNumbers = AllCount;
                DataC4.(Well).BigObjectNumbers = BigCount;
                DataC4.(Well).MeanObjectAreas = meanArea;
                DataC4.(Well).MedianObjectAreas = medianArea;
                DataC4.(Well).BigMeanObjectAreas = BigmeanArea;
                DataC4.(Well).BigMedianObjectAreas = BigmedianArea;
                DataC4.(Well).MeanObjectEccen = meanEcc;
                DataC4.(Well).MedianObjectEccen = medianEcc;
                DataC4.(Well).BigMeanObjectEccen = BigmeanEcc;
                DataC4.(Well).BigMedianObjectEccen = BigmedianEcc;
                DataC4.(Well).MeanObjectDist = meanDist;
                DataC4.(Well).BigMeanObjectDist = BigmeanDist;
                DataC4.(Well).ObjectCentroids = miniStructureOne; 
                DataC4.(Well).BigObjectCentroids = miniStructureTwo;
                else strfind(Names(j),'c5'); 
                DataC5.(Well).FileNames = Names;
                DataC5.(Well).Background = ModeArray;
                DataC5.(Well).ObjectNumbers = AllCount;
                DataC5.(Well).BigObjectNumbers = BigCount;
                DataC5.(Well).MeanObjectAreas = meanArea;
                DataC5.(Well).MedianObjectAreas = medianArea;
                DataC5.(Well).BigMeanObjectAreas = BigmeanArea;
                DataC5.(Well).BigMedianObjectAreas = BigmedianArea;
                DataC5.(Well).MeanObjectEccen = meanEcc;
                DataC5.(Well).MedianObjectEccen = medianEcc;
                DataC5.(Well).BigMeanObjectEccen = BigmeanEcc;
                DataC5.(Well).BigMedianObjectEccen = BigmedianEcc;
                DataC5.(Well).MeanObjectDist = meanDist;
                DataC5.(Well).BigMeanObjectDist = BigmeanDist; 
                DataC5.(Well).ObjectCentroids = miniStructureOne; 
                DataC5.(Well).BigObjectCentroids = miniStructureTwo;
                end    
        end
        end
    save(strcat('190423_Day0_NK-Jurkat_Lat-Bleb-Cyt_num2',num2str(pp),'of',num2str(length(paths))),'DataC1','DataC2','DataC3');
end  
toc