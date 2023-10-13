% Creates binocular rivalry stimuli with fixation spots
function make_binocular_rivalry_stimuli_monkey_training()

clear all
tic
addpath(genpath(pwd))

%Function to define contrasts
make_binocular_rivalry_define_contrasts

% Transparent FP?
fp_transparent = false;

%% Define parameters
%Switch colors
filename1 = 'Face_only.tif';
filename2 = 'Body_only.tif';
filenameMargin = 'Margin.tif';

%Switch colors
% filename1 = 'V3Stimuli\Body_only.tif';
% filename2 = 'V3Stimuli\Face_only.tif';
% filenameMargin = 'V3Stimuli\Margin.tif';


b_writeImages = true;
b_greyImages = true;
FPS = 40;

% OutputFolder = 'BinocularRivalry_jumping_fix_point_V2\\';
% ONTimeMS = 600;
% OFFTimeMS = 200;
%
b_transparent = true;
if b_transparent
    OutputFolder =  'BinocularRivalry_jumping_fix_point_V3_no_off_transparent_contrasts\\';
    ONTimeMS = 1000;
    OFFTimeMS = 000;
else
    OutputFolder = 'test\\'; % 'BinocularRivalry_jumping_fix_point_V3_no_off_contrasts\\';
    ONTimeMS = 1000;
    OFFTimeMS = 000;
end

%ONTimeMS = 1800;
%OFFTimeMS = 200;

%FPS = 20;
%ONTimeMS = 2000;



% mkdir(OutputFolder)
mkdir('BinoRiv_stimuli/monkey_training')
% mkdir('In2PB/BinoRiv')
% mkdir('In2PB/Phys')


NumFramesON = FPS*(ONTimeMS/1000);
NumFramesOFF = FPS*(OFFTimeMS/1000);
FixPointGradualOnset  = 0; %Fix point takes XXX ms to come on.
FixPointGradualOffset  = 0; %Fix point takes XXX ms to come off.
FrameTimes = 1e3*((1:NumFramesON)-1)/FPS;
FixationSpotGradualContrastProportion = ones(size(FrameTimes));
FixationSpotGradualContrastProportion(FrameTimes<FixPointGradualOnset) = FrameTimes(FrameTimes<FixPointGradualOnset)/FixPointGradualOnset;
FixationSpotGradualContrastProportion((ONTimeMS-FrameTimes)<FixPointGradualOffset) = (ONTimeMS-FrameTimes((ONTimeMS-FrameTimes)<FixPointGradualOffset))/FixPointGradualOffset;


RotDegreePerFrame = 180/(NumFramesON-1);
sigmaAng = 0.5;  %deg, bandwidth of frequency to filter
%sigmaAng = 1;  %deg, bandwidth of frequency to filter. Higher value means
%stronger effect
kFourier = 1;
wDeg = 6;  %size of image (in degrees), for fourier units
b_HaveOnlyGratingForBody = false;
BorderSize = 10;
addnoise = false;
ResizeFactor = 23/47;%1;

%% Make stimulus
ImageFace = imread(filename1);
ImageFace = imresize(ImageFace,ResizeFactor);

ImageBody = imread(filename2);
ImageBody = imresize(ImageBody,ResizeFactor);

ImageMargin = imread(filenameMargin);
ImageMargin = imresize(ImageMargin,ResizeFactor);

for i=1:length(ImageMargin)
    for j = 1:length(ImageMargin)
        if ImageMargin(i,j)~=186 && ImageMargin(i,j)~=255
            ImageMargin(i,j) = 254;
        elseif ImageMargin(i,j)==186
            ImageMargin(i,j) = 0;
        end
    end
end
for i=1:length(ImageFace)
    for j = 1:length(ImageFace)
        ImageFace(i,j,:) = 255;
    end
end
for i=1:length(ImageBody)
    for j = 1:length(ImageBody)
        ImageBody(i,j,:) = 255;
    end
end


if size(ImageFace,4)>1
    ImageFace = ImageFace(:,:,:,1);
end
if size(ImageBody,4)>1
    ImageBody = ImageBody(:,:,:,1);
end

ImageMargin3D = repmat(ImageMargin,[1 1 3]);
if size(ImageMargin,4)>1
    ImageMargin3D = ImageMargin(:,:,:,1);
end

ImageFaceBackground = logical((ImageFace(:,:,1)==255).*(ImageFace(:,:,2)==0).*(ImageFace(:,:,3)==255));
ImageBodyBackground = logical((ImageBody(:,:,1)==255).*(ImageBody(:,:,2)==0).*(ImageBody(:,:,3)==255));

if b_transparent
    ImageFaceBackground = and(ImageFaceBackground,ImageBodyBackground);
    ImageBodyBackground = and(ImageFaceBackground,ImageBodyBackground);
end

if b_HaveOnlyGratingForBody
    ImageBodyBackground(:) = true; %Have only body as background
end
%Adjust later
ImageFace = uint8(mean(ImageFace,3));
ImageBody = uint8(mean(ImageBody,3));
%Adjust now
% ImageFace = RedImageContrast*uint8(mean(ImageFace,3));
% ImageBody = CyanImageContrast*uint8(mean(ImageBody,3));

ImageHeight = size(ImageFace,1);
ImageWidth = size(ImageFace,2);


if addnoise
    ImageFace(not(ImageFace)) = 255*rand(size(ImageFace(not(ImageFace))));
    ImageBody(not(ImageBody)) = 255*rand(size(ImageBody(not(ImageBody))));
end

%% Make fixation spot
%FixationSpotProportionOfImage = 6/300;
FixationSpotProportionOfImage = 6/150;

%% Ryo's modification 
manual_positioning = 1;
% distance from centre
FixPointPositionsDistance = 1.5; % deg, distance from centre
dist_scr = 23; % viewing distance (cm), human setup: 47, monkey setup 1: 23
screen_width = 59.5; % human setup: 59.6, monkey setup 1: 59.5
screen_height = 33.3; % human setup: 33.7, monkey setup 1: 33

[FixPointPositionsDistance_x_px, FixPointPositionsDistance_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, FixPointPositionsDistance);

% size of FP
FixPointSize = 0.3; % deg
[FixPointSize_x_px, FixPointSize_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, FixPointSize);
FixPointSize_px = (FixPointSize_x_px + FixPointSize_y_px)/2;

% FP_red = contour_fp_separate(round(FixPointSize_px), RedImageContour, RedImageFixPointContrast);
% FP_blue = contour_fp_separate(round(FixPointSize_px), CyanImageContour, CyanImageFixPointContrast);

FixPointPositions = {};
% FixPointPositions{1} = [-50 0];
% FixPointPositions{2} = [50 0];
% FixPointPositions{3} = [0 -50];
% FixPointPositions{4} = [0 50];
% 
% FixPointPositions{5} = [-50 -50];
% FixPointPositions{6} = [50 -50];
% FixPointPositions{7} = [50 50];
% FixPointPositions{8} = [-50 50];

if manual_positioning == 1
    deg13 = 1.3;
    deg14 = 1.4;
    deg17 = 1.7;
    deg19 = 1.9;
    deg20 = 2.0;
    deg25 = 2.5;
    deg30 = 3.0;
    deg32 = 3.2;
    deg33 = 3.3;
    [deg13_x_px, deg13_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, deg13);
    [deg14_x_px, deg14_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, deg14);
    [deg17_x_px, deg17_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, deg17);
    [deg19_x_px, deg19_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, deg19);
    [deg20_x_px, deg20_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, deg20);
    [deg25_x_px, deg25_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, deg25);
    [deg30_x_px, deg30_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, deg30);
    [deg32_x_px, deg32_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, deg32);
    [deg33_x_px, deg33_y_px] = deg2px(dist_scr, screen_width, screen_height, ImageWidth, ImageHeight, deg33);
    % manual positioning
    FixPointPositions_red{1} = [-deg17_x_px FixPointPositionsDistance_y_px]; % reverse colour of FP
    FixPointPositions_red{2} = [deg13_x_px FixPointPositionsDistance_y_px]; % reverse colour of FP
    FixPointPositions_red{3} = [0 deg33_y_px];
    FixPointPositions_red{4} = [0 -deg13_y_px];
    
    FixPointPositions_blue{1} = [-deg14_y_px -FixPointPositionsDistance_x_px];
    FixPointPositions_blue{2} = [-deg20_x_px 0];
    FixPointPositions_blue{3} = [FixPointPositionsDistance_x_px 0];
    FixPointPositions_blue{4} = [FixPointPositionsDistance_x_px FixPointPositionsDistance_y_px];
else
    FixPointPositions{1} = [-FixPointPositionsDistance_x_px 0];
    FixPointPositions{2} = [FixPointPositionsDistance_x_px 0];
    FixPointPositions{3} = [0 -FixPointPositionsDistance_y_px];
    FixPointPositions{4} = [0 FixPointPositionsDistance_y_px];
    FixPointPositions{5} = [-FixPointPositionsDistance_x_px -FixPointPositionsDistance_y_px];
    FixPointPositions{6} = [FixPointPositionsDistance_x_px -FixPointPositionsDistance_y_px];
    FixPointPositions{7} = [FixPointPositionsDistance_x_px FixPointPositionsDistance_y_px];
    FixPointPositions{8} = [-FixPointPositionsDistance_x_px FixPointPositionsDistance_y_px];
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Contrasts{1}.FaceContrast = 1;
Contrasts{1}.BodyContrast = 0;
Contrasts{2}.FaceContrast = 0.9;
Contrasts{2}.BodyContrast = 0;
Contrasts{3}.FaceContrast = 0.8;
Contrasts{3}.BodyContrast = 0;
Contrasts{4}.FaceContrast = 0.7;
Contrasts{4}.BodyContrast = 0;
Contrasts{5}.FaceContrast = 0.6;
Contrasts{5}.BodyContrast = 0;
Contrasts{6}.FaceContrast = 0.5;
Contrasts{6}.BodyContrast = 0;
Contrasts{7}.FaceContrast = 0.4;
Contrasts{7}.BodyContrast = 0;
Contrasts{8}.FaceContrast = 0.3;
Contrasts{8}.BodyContrast = 0;
Contrasts{9}.FaceContrast = 0.2;
Contrasts{9}.BodyContrast = 0;
Contrasts{10}.FaceContrast = 0.1;
Contrasts{10}.BodyContrast = 0;

Contrasts{11}.FaceContrast = 0;
Contrasts{11}.BodyContrast = 1;
Contrasts{12}.FaceContrast = 0;
Contrasts{12}.BodyContrast = 0.9;
Contrasts{13}.FaceContrast = 0;
Contrasts{13}.BodyContrast = 0.8;
Contrasts{14}.FaceContrast = 0;
Contrasts{14}.BodyContrast = 0.7;
Contrasts{15}.FaceContrast = 0;
Contrasts{15}.BodyContrast = 0.6;
Contrasts{16}.FaceContrast = 0;
Contrasts{16}.BodyContrast = 0.5;
Contrasts{17}.FaceContrast = 0;
Contrasts{17}.BodyContrast = 0.4;
Contrasts{18}.FaceContrast = 0;
Contrasts{18}.BodyContrast = 0.3;
Contrasts{19}.FaceContrast = 0;
Contrasts{19}.BodyContrast = 0.2;
Contrasts{20}.FaceContrast = 0;
Contrasts{20}.BodyContrast = 0.1;
Contrasts{21}.FaceContrast = 0;
Contrasts{21}.BodyContrast = 0;
Contrasts{22}.FaceContrast = 1;
Contrasts{22}.BodyContrast = 1;

showFixPointRectangleRed = false;
showFixPointRed = false;
showFixPointRectangleCyan = false;
showFixPointCyan = false;


b_isImage = ImageMargin==255;
b_isMargin = not(b_isImage);
b_isImage3D = ImageMargin3D==255;
b_isMargin3D = not(b_isImage3D);

if manual_positioning == 1
else
    % calculate entropy for each FP location
    ImageRed = ImageFace;
    ImageRed(:,:,2) = 0;
    ImageRed(:,:,3) = 0;
    ent_1_red = entropy(ImageRed(ImageHeight/2 + FixPointPositions{1}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{1}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{1}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{1}(1)+FixPointSize_px/2, 1));
    ent_2_red = entropy(ImageRed(ImageHeight/2 + FixPointPositions{2}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{2}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{2}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{2}(1)+FixPointSize_px/2, 1));
    ent_3_red = entropy(ImageRed(ImageHeight/2 + FixPointPositions{3}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{3}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{3}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{3}(1)+FixPointSize_px/2, 1));
    ent_4_red = entropy(ImageRed(ImageHeight/2 + FixPointPositions{4}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{4}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{4}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{4}(1)+FixPointSize_px/2, 1));
    ent_5_red = entropy(ImageRed(ImageHeight/2 + FixPointPositions{5}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{5}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{5}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{5}(1)+FixPointSize_px/2, 1));
    ent_6_red = entropy(ImageRed(ImageHeight/2 + FixPointPositions{6}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{6}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{6}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{6}(1)+FixPointSize_px/2, 1));
    ent_7_red = entropy(ImageRed(ImageHeight/2 + FixPointPositions{7}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{7}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{7}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{7}(1)+FixPointSize_px/2, 1));
    ent_8_red = entropy(ImageRed(ImageHeight/2 + FixPointPositions{8}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{8}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{8}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{8}(1)+FixPointSize_px/2, 1));
    max_ent_red = max([ent_1_red ent_2_red ent_3_red ent_4_red ent_5_red ent_6_red ent_7_red ent_8_red]);
    relative_ent_red = [ent_1_red ent_2_red ent_3_red ent_4_red ent_5_red ent_6_red ent_7_red ent_8_red]/max_ent_red;

    ImageCyan = ImageBody;
    ent_1_blue = entropy(ImageCyan(ImageHeight/2 + FixPointPositions{1}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{1}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{1}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{1}(1)+FixPointSize_px/2));
    ent_2_blue = entropy(ImageCyan(ImageHeight/2 + FixPointPositions{2}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{2}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{2}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{2}(1)+FixPointSize_px/2));
    ent_3_blue = entropy(ImageCyan(ImageHeight/2 + FixPointPositions{3}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{3}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{3}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{3}(1)+FixPointSize_px/2));
    ent_4_blue = entropy(ImageCyan(ImageHeight/2 + FixPointPositions{4}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{4}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{4}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{4}(1)+FixPointSize_px/2));
    ent_5_blue = entropy(ImageCyan(ImageHeight/2 + FixPointPositions{5}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{5}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{5}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{5}(1)+FixPointSize_px/2));
    ent_6_blue = entropy(ImageCyan(ImageHeight/2 + FixPointPositions{6}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{6}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{6}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{6}(1)+FixPointSize_px/2));
    ent_7_blue = entropy(ImageCyan(ImageHeight/2 + FixPointPositions{7}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{7}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{7}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{7}(1)+FixPointSize_px/2));
    ent_8_blue = entropy(ImageCyan(ImageHeight/2 + FixPointPositions{8}(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositions{8}(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositions{8}(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositions{8}(1)+FixPointSize_px/2));
    max_ent_blue = max([ent_1_blue ent_2_blue ent_3_blue ent_4_blue ent_5_blue ent_6_blue ent_7_blue ent_8_blue]);
    relative_ent_blue = [ent_1_blue ent_2_blue ent_3_blue ent_4_blue ent_5_blue ent_6_blue ent_7_blue ent_8_blue]/max_ent_blue;
end

for b_diagonal = [0 1]
    if ~b_diagonal
%         FixPointPositionsToUse = 1:4;
        if manual_positioning == 0
            FixPointPositionsToUse = 1:8;
        elseif manual_positioning == 1
            FixPointPositionsToUse = 1:4;
        end
    else
%         FixPointPositionsToUse = 5:8;
        if manual_positioning == 0
            FixPointPositionsToUse = 1:8;
        elseif manual_positioning == 1
            FixPointPositionsToUse = 1:4;
        end
    end
    for FixPointPositionsIndexFace = FixPointPositionsToUse
        for FixPointPositionsIndexBody = FixPointPositionsToUse

            if manual_positioning == 0
                % Place FPs further
                if FixPointPositionsIndexFace == 1 
                    if FixPointPositionsIndexBody~=6 && FixPointPositionsIndexBody~=2 && FixPointPositionsIndexBody~=7
                        continue
                    end
                elseif FixPointPositionsIndexFace == 2 
                    if FixPointPositionsIndexBody~=5 && FixPointPositionsIndexBody~=1 && FixPointPositionsIndexBody~=8
                        continue
                    end
                elseif FixPointPositionsIndexFace == 3 
                    if FixPointPositionsIndexBody~=8 && FixPointPositionsIndexBody~=4 && FixPointPositionsIndexBody~=7
                        continue
                    end
                elseif FixPointPositionsIndexFace == 4 
                    if FixPointPositionsIndexBody~=5 && FixPointPositionsIndexBody~=3 && FixPointPositionsIndexBody~=6
                        continue
                    end
                elseif FixPointPositionsIndexFace == 5 
                    if FixPointPositionsIndexBody~=2 && FixPointPositionsIndexBody~=7 && FixPointPositionsIndexBody~=4
                        continue
                    end
                elseif FixPointPositionsIndexFace == 6 
                    if FixPointPositionsIndexBody~=1 && FixPointPositionsIndexBody~=8 && FixPointPositionsIndexBody~=4
                        continue
                    end
                elseif FixPointPositionsIndexFace == 7 
                    if FixPointPositionsIndexBody~=1 && FixPointPositionsIndexBody~=5 && FixPointPositionsIndexBody~=3
                        continue
                    end
                elseif FixPointPositionsIndexFace == 8 
                    if FixPointPositionsIndexBody~=3 && FixPointPositionsIndexBody~=6 && FixPointPositionsIndexBody~=2
                        continue
                    end
                end
                if FixPointPositionsIndexBody == 1 
                    if FixPointPositionsIndexFace~=6 && FixPointPositionsIndexFace~=2 && FixPointPositionsIndexFace~=7
                        continue
                    end
                elseif FixPointPositionsIndexBody == 2 
                    if FixPointPositionsIndexFace~=5 && FixPointPositionsIndexFace~=1 && FixPointPositionsIndexFace~=8
                        continue
                    end
                elseif FixPointPositionsIndexBody == 3 
                    if FixPointPositionsIndexFace~=8 && FixPointPositionsIndexFace~=4 && FixPointPositionsIndexFace~=7
                        continue
                    end
                elseif FixPointPositionsIndexBody == 4 
                    if FixPointPositionsIndexFace~=5 && FixPointPositionsIndexFace~=3 && FixPointPositionsIndexFace~=6
                        continue
                    end
                elseif FixPointPositionsIndexBody == 5 
                    if FixPointPositionsIndexFace~=2 && FixPointPositionsIndexFace~=7 && FixPointPositionsIndexFace~=4
                        continue
                    end
                elseif FixPointPositionsIndexBody == 6 
                    if FixPointPositionsIndexFace~=1 && FixPointPositionsIndexFace~=8 && FixPointPositionsIndexFace~=4
                        continue
                    end
                elseif FixPointPositionsIndexBody == 7 
                    if FixPointPositionsIndexFace~=1 && FixPointPositionsIndexFace~=5 && FixPointPositionsIndexFace~=3
                        continue
                    end
                elseif FixPointPositionsIndexBody == 8 
                    if FixPointPositionsIndexFace~=3 && FixPointPositionsIndexFace~=6 && FixPointPositionsIndexFace~=2
                        continue
                    end
                end
            elseif manual_positioning == 1
                 if FixPointPositionsIndexFace == 1 
                    if FixPointPositionsIndexBody~=3 && FixPointPositionsIndexBody~=4
                        continue
                    end
                 elseif FixPointPositionsIndexFace == 2 
                    if FixPointPositionsIndexBody~=2
                        continue
                    end
                 elseif FixPointPositionsIndexFace == 3 
                    if FixPointPositionsIndexBody~=1
                        continue
                    end
                 elseif FixPointPositionsIndexFace == 4
                    if FixPointPositionsIndexBody~=4
                        continue
                    end
                 end
                 if FixPointPositionsIndexBody == 1 
                    if FixPointPositionsIndexFace~=3
                        continue
                    end
                 elseif FixPointPositionsIndexBody == 2 
                    if FixPointPositionsIndexFace~=2
                        continue
                    end
                 elseif FixPointPositionsIndexBody == 3 
                    if FixPointPositionsIndexFace~=1
                        continue
                    end
                 elseif FixPointPositionsIndexBody == 4
                    if FixPointPositionsIndexFace~=1 && FixPointPositionsIndexFace~=4
                        continue
                    end
                 end
            end
                
            if FixPointPositionsIndexFace == FixPointPositionsIndexBody && manual_positioning == 0
                continue
            else

                if manual_positioning == 1
                    FixPointPositionFace = FixPointPositions_red{FixPointPositionsIndexFace};
                    FixPointPositionBody = FixPointPositions_blue{FixPointPositionsIndexBody};
                else
                    FixPointPositionFace = FixPointPositions{FixPointPositionsIndexFace};
                    FixPointPositionBody = FixPointPositions{FixPointPositionsIndexBody};
                end


                OutputImage = uint8(zeros(size(ImageFace,1),size(ImageFace,2),3));
                OutputImage_face = uint8(zeros(size(ImageFace,1),size(ImageFace,2),3));
                OutputImage_obj = uint8(zeros(size(ImageFace,1),size(ImageFace,2),3));

                OutputImageRed = ImageFace;
                if b_transparent
                    OutputImageRed = 0.3*ImageFace+0.7*ImageBody;
                end
                iFrame = 1;
                OutputImageRed(:,:,2) = 0;
                OutputImageRed(:,:,3) = 0;
%                 OutputImageRed= OutputImageRed.*1.25; % RS
                if showFixPointRectangleRed
                    if manual_positioning == 0
                        if fp_transparent
        %                     OutputImageRed = insertShape(OutputImageRed, 'FilledRectangle', [ImageWidth/2 + FixPointPositionFace(1)-ImageHeight*FixationSpotProportionOfImage/2, ImageHeight/2 + FixPointPositionFace(2)-ImageHeight*FixationSpotProportionOfImage/2, ImageHeight*FixationSpotProportionOfImage+1, ImageHeight*FixationSpotProportionOfImage+1], 'LineWidth', 1,'Color','black','Opacity',RedImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
                            OutputImageRed = insertShape(OutputImageRed, 'FilledRectangle', [ImageWidth/2 + FixPointPositionFace(1)-FixPointSize_px/2, ImageHeight/2 + FixPointPositionFace(2)-FixPointSize_px/2, FixPointSize_x_px+1, FixPointSize_y_px+1], 'LineWidth', 1,'Color','black','Opacity',RedImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
        %                     image_median = median(OutputImageRed(:,:,1),'all');
        %                     area_median = median(OutputImageRed(ImageHeight/2 + FixPointPositionFace(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositionFace(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositionFace(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositionFace(1)+FixPointSize_px/2, 1), 'all');
        %                     area_mean = mean(OutputImageRed(ImageHeight/2 + FixPointPositionFace(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositionFace(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositionFace(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositionFace(1)+FixPointSize_px/2, 1), 'all');
        %                     if area_mean < image_median % if ROI is darker than median of image, contour gets bright
        % %                         OutputImageRed = insertShape(OutputImageRed, 'FilledRectangle', [ImageWidth/2 + FixPointPositionFace(1)-FixPointSize_px/2, ImageHeight/2 + FixPointPositionFace(2)-FixPointSize_px/2, FixPointSize_x_px+1, FixPointSize_y_px+1], 'LineWidth', 1,...
        % %                             'Color',[(area_mean+(area_mean*RedImageContour))*relative_ent_red(FixPointPositionsIndexFace) (area_mean+(area_mean*RedImageContour))*relative_ent_red(FixPointPositionsIndexFace) (area_mean+(area_mean*RedImageContour))*relative_ent_red(FixPointPositionsIndexFace)],'Opacity',RedImageContour*FixationSpotGradualContrastProportion(iFrame));
        %                         OutputImageRed = insertShape(OutputImageRed, 'FilledRectangle', [ImageWidth/2 + FixPointPositionFace(1)-FixPointSize_px/2, ImageHeight/2 + FixPointPositionFace(2)-FixPointSize_px/2, FixPointSize_x_px+1, FixPointSize_y_px+1], 'LineWidth', 1,...
        %                             'Color',[255*relative_ent_red(FixPointPositionsIndexFace) 255*relative_ent_red(FixPointPositionsIndexFace) 255*relative_ent_red(FixPointPositionsIndexFace)],'Opacity',RedImageContour*FixationSpotGradualContrastProportion(iFrame));
        %                     elseif area_mean > image_median % if ROI is brigher than median of image, contour gets dark
        %                         OutputImageRed = insertShape(OutputImageRed, 'FilledRectangle', [ImageWidth/2 + FixPointPositionFace(1)-FixPointSize_px/2, ImageHeight/2 + FixPointPositionFace(2)-FixPointSize_px/2, FixPointSize_x_px+1, FixPointSize_y_px+1], 'LineWidth', 1,...
        %                             'Color',[255-255*relative_ent_red(FixPointPositionsIndexFace) 255-255*relative_ent_red(FixPointPositionsIndexFace) 255-255*relative_ent_red(FixPointPositionsIndexFace)],'Opacity',RedImageContour*FixationSpotGradualContrastProportion(iFrame));
        %                     end
                        end
                    elseif manual_positioning == 1
                        if fp_transparent
                            OutputImageRed = insertShape(OutputImageRed, 'FilledRectangle', [ImageWidth/2+FixPointPositionFace(1)-FixPointSize_px/2-0.5, ImageHeight/2+FixPointPositionFace(2)-FixPointSize_px/2-0.5, FixPointSize_px+2, FixPointSize_px+2], 'LineWidth', 1,'Color','black','Opacity',RedImageContour*FixationSpotGradualContrastProportion(iFrame));
                        end
                    end
                end
                if showFixPointRed
                    if manual_positioning == 0
                        if fp_transparent
        %                     OutputImageRed = insertShape(OutputImageRed, 'FilledCircle', [ImageWidth/2 + FixPointPositionFace(1), ImageHeight/2 + FixPointPositionFace(2), ImageHeight*FixationSpotProportionOfImage/2], 'LineWidth', 1,'Color','white','Opacity',RedImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
                            OutputImageRed = insertShape(OutputImageRed, 'FilledCircle', [ImageWidth/2+FixPointPositionFace(1), ImageHeight/2+FixPointPositionFace(2), FixPointSize_px/2], 'LineWidth', 1,'Color','white','Opacity',RedImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
        %                     if area_mean < image_median % if ROI is darker than median of image, FP gets dark                    
        %                         OutputImageRed = insertShape(OutputImageRed, 'FilledCircle', [ImageWidth/2+FixPointPositionFace(1), ImageHeight/2+FixPointPositionFace(2), FixPointSize_px/2], 'LineWidth', 1,...
        %                             'Color',[(area_mean-(area_mean*RedImageContour))*relative_ent_red(FixPointPositionsIndexFace) (area_mean-(area_mean*RedImageContour))*relative_ent_red(FixPointPositionsIndexFace) (area_mean-(area_mean*RedImageContour))*relative_ent_red(FixPointPositionsIndexFace)],'Opacity',RedImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
        %                     elseif area_mean > image_median % if ROI is brigher than median of image, FP gets bright
        %                         OutputImageRed = insertShape(OutputImageRed, 'FilledCircle', [ImageWidth/2+FixPointPositionFace(1), ImageHeight/2+FixPointPositionFace(2), FixPointSize_px/2], 'LineWidth', 1,...
        %                             'Color',[(area_mean+(area_mean*RedImageContour))*relative_ent_red(FixPointPositionsIndexFace) (area_mean+(area_mean*RedImageContour))*relative_ent_red(FixPointPositionsIndexFace) (area_mean+(area_mean*RedImageContour))*relative_ent_red(FixPointPositionsIndexFace)],'Opacity',RedImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
        %                     end
                        end
                    elseif manual_positioning == 1
                        if fp_transparent
                            OutputImageRed = insertShape(OutputImageRed, 'FilledCircle', [ImageWidth/2+FixPointPositionFace(1), ImageHeight/2+FixPointPositionFace(2), FixPointSize_px/2], 'LineWidth', 1,'Color','white','Opacity',RedImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
                        end
                    end
                end

                OutputImageCyan = ImageBody;
%                 OutputImageCyan = OutputImageCyan.*1.25;
                if b_transparent
                    OutputImageCyan = 0.3*ImageFace+0.7*ImageBody;
                end

                if showFixPointRectangleCyan
                    if manual_positioning == 0
%                     OutputImageCyan = insertShape(OutputImageCyan, 'FilledRectangle', [ImageWidth/2 + FixPointPositionBody(1)-ImageHeight*FixationSpotProportionOfImage/2, ImageHeight/2 + FixPointPositionBody(2)-ImageHeight*FixationSpotProportionOfImage/2, ImageHeight*FixationSpotProportionOfImage+1, ImageHeight*FixationSpotProportionOfImage+1], 'LineWidth', 1,'Color','black','Opacity',CyanImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
                      OutputImageCyan = insertShape(OutputImageCyan, 'FilledRectangle', [ImageWidth/2 + FixPointPositionBody(1)-FixPointSize_px/2, ImageHeight/2 + FixPointPositionBody(2)-FixPointSize_px/2, FixPointSize_x_px+1, FixPointSize_y_px+1], 'LineWidth', 1,'Color','black','Opacity',CyanImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
%                       image_median = median(OutputImageCyan,'all');
%                       area_median = median(OutputImageCyan(ImageHeight/2 + FixPointPositionBody(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositionBody(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositionBody(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositionBody(1)+FixPointSize_px/2), 'all');
%                       area_mean = mean(OutputImageCyan(ImageHeight/2 + FixPointPositionBody(2)-FixPointSize_px/2:ImageHeight/2 + FixPointPositionBody(2)+FixPointSize_px/2, ImageWidth/2 + FixPointPositionBody(1)-FixPointSize_px/2:ImageWidth/2 + FixPointPositionBody(1)+FixPointSize_px/2), 'all');
%                       if area_mean < image_median % if ROI is darker than median of image, contour gets bright
% %                             OutputImageCyan = insertShape(OutputImageCyan, 'FilledRectangle', [ImageWidth/2 + FixPointPositionBody(1)-FixPointSize_px/2, ImageHeight/2 + FixPointPositionBody(2)-FixPointSize_px/2, FixPointSize_x_px+1, FixPointSize_y_px+1], 'LineWidth', 1,...
% %                                 'Color', [(area_mean+(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody) (area_mean+(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody) (area_mean+(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody)],'Opacity',CyanImageContour*FixationSpotGradualContrastProportion(iFrame));
%                           OutputImageCyan = insertShape(OutputImageCyan, 'FilledRectangle', [ImageWidth/2 + FixPointPositionBody(1)-FixPointSize_px/2, ImageHeight/2 + FixPointPositionBody(2)-FixPointSize_px/2, FixPointSize_x_px+1, FixPointSize_y_px+1], 'LineWidth', 1,...
%                                     'Color', [255*relative_ent_blue(FixPointPositionsIndexBody) 255*relative_ent_blue(FixPointPositionsIndexBody) 255*relative_ent_blue(FixPointPositionsIndexBody)],'Opacity',CyanImageContour*FixationSpotGradualContrastProportion(iFrame));
%                       elseif area_mean > image_median % if ROI is brigher than median of image, contour gets dark
% %                             OutputImageCyan = insertShape(OutputImageCyan, 'FilledRectangle', [ImageWidth/2 + FixPointPositionBody(1)-FixPointSize_px/2, ImageHeight/2 + FixPointPositionBody(2)-FixPointSize_px/2, FixPointSize_x_px+1, FixPointSize_y_px+1], 'LineWidth', 1,...
% %                                 'Color', [(area_mean-(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody) (area_mean-(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody) (area_mean-(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody)],'Opacity',CyanImageContour*FixationSpotGradualContrastProportion(iFrame));
%                             OutputImageCyan = insertShape(OutputImageCyan, 'FilledRectangle', [ImageWidth/2 + FixPointPositionBody(1)-FixPointSize_px/2, ImageHeight/2 + FixPointPositionBody(2)-FixPointSize_px/2, FixPointSize_x_px+1, FixPointSize_y_px+1], 'LineWidth', 1,...
%                                 'Color', [255-255*relative_ent_blue(FixPointPositionsIndexBody) 255-255*relative_ent_blue(FixPointPositionsIndexBody) 255-255*relative_ent_blue(FixPointPositionsIndexBody)],'Opacity',CyanImageContour*FixationSpotGradualContrastProportion(iFrame));
%                       end
                    elseif manual_positioning == 1
                       OutputImageCyan = insertShape(OutputImageCyan, 'FilledRectangle', [ImageWidth/2+FixPointPositionBody(1)-FixPointSize_px/2-0.5, ImageHeight/2+FixPointPositionBody(2)-FixPointSize_px/2-0.5, FixPointSize_px+2, FixPointSize_px+2], 'LineWidth', 1,'Color','black','Opacity',CyanImageContour*FixationSpotGradualContrastProportion(iFrame));
                    end
                end
                if showFixPointCyan
                    if manual_positioning == 0
    %                     OutputImageCyan = insertShape(OutputImageCyan, 'FilledCircle', [ImageWidth/2 + FixPointPositionBody(1), ImageHeight/2 + FixPointPositionBody(2), ImageHeight*FixationSpotProportionOfImage/2], 'LineWidth', 1,'Color','white','Opacity',CyanImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
                        OutputImageCyan = insertShape(OutputImageCyan, 'FilledCircle', [ImageWidth/2 + FixPointPositionBody(1), ImageHeight/2 + FixPointPositionBody(2), FixPointSize_px/2], 'LineWidth', 1,'Color','white','Opacity',CyanImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
    %                     if area_mean < image_median % if ROI is darker than median of image, FP gets dark                    
    %                         OutputImageCyan = insertShape(OutputImageCyan, 'FilledCircle', [ImageWidth/2 + FixPointPositionBody(1), ImageHeight/2 + FixPointPositionBody(2), FixPointSize_px/2], 'LineWidth', 1,...
    %                             'Color',[(area_mean-(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody) (area_mean-(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody) (area_mean-(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody)],'Opacity',CyanImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
    %                     elseif area_mean > image_median % if ROI is brigher than median of image, FP gets bright
    %                         OutputImageCyan = insertShape(OutputImageCyan, 'FilledCircle', [ImageWidth/2 + FixPointPositionBody(1), ImageHeight/2 + FixPointPositionBody(2), FixPointSize_px/2], 'LineWidth', 1,...
    %                             'Color',[(area_mean+(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody) (area_mean+(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody) (area_mean+(area_mean*CyanImageContour))*relative_ent_blue(FixPointPositionsIndexBody)],'Opacity',CyanImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame)); 
    %                     end
                    elseif manual_positioning == 1
                        OutputImageCyan = insertShape(OutputImageCyan, 'FilledCircle', [ImageWidth/2 + FixPointPositionBody(1), ImageHeight/2 + FixPointPositionBody(2), FixPointSize_px/2], 'LineWidth', 1,'Color','white','Opacity',CyanImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
                    end
                end

                OutputImageRed1D = OutputImageRed(:,:,1);

                nPix = size(OutputImageRed1D,1);
                [x,y] = meshgrid(linspace(-wDeg/2,wDeg/2,nPix+1));
                x = x(1:end-1,1:end-1);
                y = y(1:end-1,1:end-1);

                OutputImageRedFourier = myfft2(double(OutputImageRed1D)-mean(double(OutputImageRed1D(:))),x,y,kFourier);
                AngleRed = RotDegreePerFrame*(iFrame-1); %c/deg
                %AngleRed = 0; %c/deg
                %vonMises function
                VonMises = exp(-sigmaAng*cos(pi*(2*(OutputImageRedFourier.angle-AngleRed))/180));
                OutputImageRedFourier.amp = OutputImageRedFourier.amp.*VonMises;
                OutputImageRedOrientationFilter = myifft2(OutputImageRedFourier);
                %plotFFT2(OutputImageRedOrientationFilter,x,y,kFourier);
                %imagesc(OutputImageRedOrientationFilter)
                OutputImageRedOrientationFilter = uint8(255*((OutputImageRedOrientationFilter - min(OutputImageRedOrientationFilter(:)))/(max(OutputImageRedOrientationFilter(:)) - min(OutputImageRedOrientationFilter(:)))));
                OutputImageRedOrientationFilter = imhistmatch(OutputImageRedOrientationFilter,OutputImageRed1D);

                orientation = AngleRed;  %deg (counter-clockwise from horizontal)
                sfgrating = 1; %spatial frequency (cycles/deg)
                ramp = sin(orientation*pi/180)*x-cos(orientation*pi/180)*y;
                grating = uint8(255*((sin(2*pi*sfgrating*ramp)+1)/2));
                OutputImageRedOrientationFilter(ImageFaceBackground)=RedImageContrast*grating(ImageFaceBackground);
                if iFrame>NumFramesON %Grey
                    OutputImageRedOrientationFilter = OutputImageRedOrientationFilter*0+128;
                end


                OutputImageCyan1D = OutputImageCyan(:,:,1);

                nPix = size(OutputImageCyan1D,1);
                [x,y] = meshgrid(linspace(-wDeg/2,wDeg/2,nPix+1));
                x = x(1:end-1,1:end-1);
                y = y(1:end-1,1:end-1);

                OutputImageCyanFourier = myfft2(double(OutputImageCyan1D)-mean(double(OutputImageCyan1D(:))),x,y,kFourier);
                AngleCyan = RotDegreePerFrame*(iFrame-1)+90; %c/deg
                if b_transparent
                    AngleCyan = AngleRed; %c/deg
                end
                %vonMises function
                VonMises = exp(-sigmaAng*cos(pi*(2*(OutputImageCyanFourier.angle-AngleCyan))/180));
                %VonMises = (1/exp(1))*exp(-sigmaAng*cos(pi*(2*(OutputImageCyanFourier.angle-AngleCyan))/180));
                OutputImageCyanFourier.amp = OutputImageCyanFourier.amp.*VonMises;
                OutputImageCyanOrientationFilter = myifft2(OutputImageCyanFourier);
                %plotFFT2(OutputImageCyanOrientationFilter,x,y,kFourier);
                %imagesc(OutputImageCyanOrientationFilter)
                OutputImageCyanOrientationFilter = uint8(255*((OutputImageCyanOrientationFilter - min(OutputImageCyanOrientationFilter(:)))/(max(OutputImageCyanOrientationFilter(:)) - min(OutputImageCyanOrientationFilter(:)))));
                OutputImageCyanOrientationFilter = imhistmatch(OutputImageCyanOrientationFilter,OutputImageCyan1D);

                %OutputImageCyanOrientationFilter = uint8(OutputImageCyanOrientationFilter +mean(OutputImageCyanOrientationFilter(:)) + mean(double(OutputImageCyan1D(:))));

                orientation = AngleCyan;  %deg (counter-clockwise from horizontal)
                sfgrating = 1; %spatial frequency (cycles/deg)
                ramp = sin(orientation*pi/180)*x-cos(orientation*pi/180)*y;
                grating = uint8(255*((sin(2*pi*sfgrating*ramp)+1)/2));
                OutputImageCyanOrientationFilter(ImageBodyBackground)=grating(ImageBodyBackground);

                if iFrame>NumFramesON %Grey
                    OutputImageCyanOrientationFilter = OutputImageCyanOrientationFilter*0+128;
                end

                OutputImageRedOrientationFilterBeforeAdjustment = OutputImageRedOrientationFilter;
                OutputImageCyanOrientationFilterBeforeAdjustment = OutputImageCyanOrientationFilter;
                %Adjust image now


                
                for iContrast = 1:length(Contrasts)
                    RedImageContrast = Contrasts{iContrast}.FaceContrast;
                    CyanImageContrast = Contrasts{iContrast}.BodyContrast;
                    OutputImageRedOrientationFilter = 128 + RedImageContrast*(OutputImageRedOrientationFilterBeforeAdjustment-128);
                    OutputImageRedOrientationFilter(b_isMargin) = ImageMargin(b_isMargin);
                    OutputImageCyanOrientationFilter = 128 + CyanImageContrast*(OutputImageCyanOrientationFilterBeforeAdjustment-128);
                    OutputImageCyanOrientationFilter(b_isMargin) = ImageMargin(b_isMargin);
                    
                    
                    OutputImage(:,:,1) = OutputImageRedOrientationFilter;
                    OutputImage(:,:,2) = OutputImageCyanOrientationFilter;
                    OutputImage(:,:,3) = OutputImageCyanOrientationFilter;
                    
                    

%                     OutputImage_face(:,:,1) = OutputImageRedOrientationFilter;
% 
%                     OutputImage_obj(:,:,2) = OutputImageCyanOrientationFilter;
%                     OutputImage_obj(:,:,3) = OutputImageCyanOrientationFilter;

                    %subplot(2,2,3)
                    %imshow(OutputImage)
                    drawnow
                    %                     if iFrame ==1
                    %                         warning off;mkdir([OutputFolder 'Face_ ' num2str(Contrasts{iContrast}.FaceContrast) '_Body_ ' num2str(Contrasts{iContrast}.BodyContrast)]) ;warning on
                    %                         imwrite(double(OutputImage)/255,[OutputFolder 'Face_ ' num2str(Contrasts{iContrast}.FaceContrast) '_Body_ ' num2str(Contrasts{iContrast}.BodyContrast)  '\\' 'Face_and_Body_binocular_FaceFixPosition' num2str(FixPointPositionsIndexFace) '_BodyFixPosition' num2str(FixPointPositionsIndexBody) '.tif']);
                    %                     end

                    mkdir(['BinoRiv_stimuli/monkey_training/RedContour_' num2str(RedImageContour) '_RedFP_' num2str(RedImageFixPointContrast) ...
                        '_BlueContour_' num2str(CyanImageContour) '_BlueFP_' num2str(CyanImageFixPointContrast) '/Face_' num2str(RedImageContrast) '_Object_' num2str(CyanImageContrast)])
                    OutputFolder = ['BinoRiv_stimuli/monkey_training/RedContour_' num2str(RedImageContour) '_RedFP_' num2str(RedImageFixPointContrast) '_BlueContour_' num2str(CyanImageContour) '_BlueFP_' num2str(CyanImageFixPointContrast) '/Face_' num2str(RedImageContrast) '_Object_' num2str(CyanImageContrast)];
                    imwrite(double(OutputImage)/255,[OutputFolder '/Face_and_Body_binocular_FaceFixPosition' num2str(FixPointPositionsIndexFace) '_BodyFixPosition' num2str(FixPointPositionsIndexBody) '.tif']);
                %     if RedImageContrast ~= 0
                %         imwrite(double(OutputImage_face)/255,['In2PB/Phys/Face_' num2str(RedImageContrast) '.tif']);
                %     end
                %     if CyanImageContrast ~= 0
                %         imwrite(double(OutputImage_obj)/255,['In2PB/Phys/Object_' num2str(CyanImageContrast) '.tif']);
                %     end
                end
            end
        end
    end
end

toc



% function fp = contour_fp_separate(side, contour_contrast, fp_contrast)
% % Initial array
% fp = repmat(NaN, side+1, side+1, 2);
% 
% % centre (side/2, side/2), rad side/2 ã?®å††å†…ã?®ã‚°ãƒªãƒƒãƒ‰ç‚¹ã‚’ç¤ºã?™ã‚¤ãƒ³ãƒ‡ãƒƒã‚¯ã‚¹ã‚’ä½œæˆ?
% [xg, yg] = meshgrid(1:(side+1), 1:(side+1));
% idx = sqrt((xg-(side+1)/2).^2 + (yg-(side+1)/2).^2) <= side/2;
% 
% fp(:,:,1) = 255 .* idx;
% fp(:,:,2) = fp_contrast .* idx;
% 
% Contour = fp(:,:,2)~=fp_contrast;
% Contour = Contour .* contour_contrast;
% fp(:,:,2) = fp(:,:,2) + Contour;
% 
% end
% 
function [x_px, y_px] = deg2px(distanceFromScreen, screen_width, screen_height, ImageWidth, ImageHeight, deg)
% from deg to px
diameter = distanceFromScreen*tan(deg*pi/180); % cm
% x = atan(x*30/SETTINGS.vd*pi/180)*180/pi;
% from cm to px
r = groot;
monitor = r.MonitorPositions;
monitor_x = 2560;%monitor(2,3);
monitor_y = 1440;%monitor(2,4);
screen_width_normalised = screen_width*(ImageWidth/monitor_x); % normalisation to the image size
screen_height_normalised = screen_height*(ImageHeight/monitor_y); % normalisation to the image size
width_pxpercm = ImageWidth/screen_width_normalised;
height_pxpercm = ImageHeight/screen_height_normalised;
x_px = diameter * width_pxpercm; % px
y_px = diameter * height_pxpercm; % px
