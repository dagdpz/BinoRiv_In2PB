% Creates binocular rivalry stimuli 

clear all
tic
addpath(genpath(pwd))

%Function to define contrasts
make_binocular_rivalry_define_contrasts

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
b_greyImages = false;
FPS = 40;

% OutputFolder = 'BinocularRivalry_jumping_fix_point_V2\\';
% ONTimeMS = 600;
% OFFTimeMS = 200;
%
b_transparent = false;
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



mkdir(OutputFolder)
mkdir('BinoRiv_stimuli/without_fp')
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
ResizeFactor = 1;


%FixationSpotProportionOfImage = 6/300;
FixationSpotProportionOfImage = 6/150;

FixPointPositions = {};
FixPointPositions{1} = [-50 0];
FixPointPositions{2} = [50 0];
FixPointPositions{3} = [0 -50];
FixPointPositions{4} = [0 50];

FixPointPositions{5} = [-50 -50];
FixPointPositions{6} = [50 -50];
FixPointPositions{7} = [50 50];
FixPointPositions{8} = [-50 50];


Contrasts{1}.FaceContrast = 1;
Contrasts{1}.BodyContrast = 1;
Contrasts{2}.FaceContrast = 0.9;
Contrasts{2}.BodyContrast = 1;
Contrasts{3}.FaceContrast = 0.8;
Contrasts{3}.BodyContrast = 1;
Contrasts{4}.FaceContrast = 0.7;
Contrasts{4}.BodyContrast = 1;
Contrasts{5}.FaceContrast = 0.6;
Contrasts{5}.BodyContrast = 1;
Contrasts{6}.FaceContrast = 0.5;
Contrasts{6}.BodyContrast = 1;
Contrasts{7}.FaceContrast = 0.4;
Contrasts{7}.BodyContrast = 1;
Contrasts{8}.FaceContrast = 0.3;
Contrasts{8}.BodyContrast = 1;
Contrasts{9}.FaceContrast = 0.2;
Contrasts{9}.BodyContrast = 1;
Contrasts{10}.FaceContrast = 0.1;
Contrasts{10}.BodyContrast = 1;
Contrasts{11}.FaceContrast = 0;
Contrasts{11}.BodyContrast = 1;
Contrasts{12}.FaceContrast = 1;
Contrasts{12}.BodyContrast = 0.9;
Contrasts{13}.FaceContrast = 1;
Contrasts{13}.BodyContrast = 0.8;
Contrasts{14}.FaceContrast = 1;
Contrasts{14}.BodyContrast = 0.7;
Contrasts{15}.FaceContrast = 1;
Contrasts{15}.BodyContrast = 0.6;
Contrasts{16}.FaceContrast = 1;
Contrasts{16}.BodyContrast = 0.5;
Contrasts{17}.FaceContrast = 1;
Contrasts{17}.BodyContrast = 0.4;
Contrasts{18}.FaceContrast = 1;
Contrasts{18}.BodyContrast = 0.3;
Contrasts{19}.FaceContrast = 1;
Contrasts{19}.BodyContrast = 0.2;
Contrasts{20}.FaceContrast = 1;
Contrasts{20}.BodyContrast = 0.1;
Contrasts{21}.FaceContrast = 1;
Contrasts{21}.BodyContrast = 0;
Contrasts{22}.FaceContrast = RedImageContrast;
Contrasts{22}.BodyContrast = 0;
Contrasts{23}.FaceContrast = 0;
Contrasts{23}.BodyContrast = CyanImageContrast;
Contrasts{24}.FaceContrast = RedImageContrast;
Contrasts{24}.BodyContrast = CyanImageContrast;

showFixPointRectangleRed = false;
showFixPointRed = false;
showFixPointRectangleCyan = false;
showFixPointCyan = false;

%% Make stimulus
ImageFace = imread(filename1);
ImageFace = imresize(ImageFace,ResizeFactor);

ImageBody = imread(filename2);
ImageBody = imresize(ImageBody,ResizeFactor);

ImageMargin = imread(filenameMargin);
ImageMargin = imresize(ImageMargin,ResizeFactor);


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


b_isImage = ImageMargin==255;
b_isMargin = not(b_isImage);
b_isImage3D = ImageMargin3D==255;
b_isMargin3D = not(b_isImage3D);


OutputImage = uint8(zeros(size(ImageFace,1),size(ImageFace,2),3));
OutputImage_face = uint8(zeros(size(ImageFace,1),size(ImageFace,2),3));
OutputImage_obj = uint8(zeros(size(ImageFace,1),size(ImageFace,2),3));

OutputImageRed = ImageFace;
if b_transparent
    OutputImageRed = 0.3*ImageFace+0.7*ImageBody;
end
if showFixPointRectangleRed
    OutputImageRed = insertShape(OutputImageRed, 'FilledRectangle', [ImageWidth/2 + FixPointPositionFace(1)-ImageHeight*FixationSpotProportionOfImage/2, ImageHeight/2 + FixPointPositionFace(2)-ImageHeight*FixationSpotProportionOfImage/2 ImageHeight*FixationSpotProportionOfImage+1 ImageHeight*FixationSpotProportionOfImage+1], 'LineWidth', 1,'Color','black','Opacity',RedImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
end
if showFixPointRed
    OutputImageRed = insertShape(OutputImageRed, 'FilledCircle', [ImageWidth/2 + FixPointPositionFace(1) ImageHeight/2 + FixPointPositionFace(2) ImageHeight*FixationSpotProportionOfImage/2], 'LineWidth', 1,'Color','white','Opacity',RedImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
end

OutputImageCyan = ImageBody;
if b_transparent
    OutputImageCyan = 0.3*ImageFace+0.7*ImageBody;
end

if showFixPointRectangleCyan
    OutputImageCyan = insertShape(OutputImageCyan, 'FilledRectangle', [ImageWidth/2 + FixPointPositionBody(1)-ImageHeight*FixationSpotProportionOfImage/2, ImageHeight/2 + FixPointPositionBody(2)-ImageHeight*FixationSpotProportionOfImage/2 ImageHeight*FixationSpotProportionOfImage+1 ImageHeight*FixationSpotProportionOfImage+1], 'LineWidth', 1,'Color','black','Opacity',CyanImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
end
if showFixPointCyan
    OutputImageCyan = insertShape(OutputImageCyan, 'FilledCircle', [ImageWidth/2 + FixPointPositionBody(1) ImageHeight/2 + FixPointPositionBody(2) ImageHeight*FixationSpotProportionOfImage/2], 'LineWidth', 1,'Color','white','Opacity',CyanImageFixPointContrast*FixationSpotGradualContrastProportion(iFrame));
end

OutputImageRed1D = OutputImageRed(:,:,1);

nPix = size(OutputImageRed1D,1);
[x,y] = meshgrid(linspace(-wDeg/2,wDeg/2,nPix+1));
x = x(1:end-1,1:end-1);
y = y(1:end-1,1:end-1);

OutputImageRedFourier = myfft2(double(OutputImageRed1D)-mean(double(OutputImageRed1D(:))),x,y,kFourier);
iFrame = 1;
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
    
%     OutputImage_face(:,:,1) = OutputImageRedOrientationFilter;
%     
%     OutputImage_obj(:,:,2) = OutputImageCyanOrientationFilter;
%     OutputImage_obj(:,:,3) = OutputImageCyanOrientationFilter;
    
    %subplot(2,2,3)
    %imshow(OutputImage)
    drawnow
    %                     if iFrame ==1
    %                         warning off;mkdir([OutputFolder 'Face_ ' num2str(Contrasts{iContrast}.FaceContrast) '_Body_ ' num2str(Contrasts{iContrast}.BodyContrast)]) ;warning on
    %                         imwrite(double(OutputImage)/255,[OutputFolder 'Face_ ' num2str(Contrasts{iContrast}.FaceContrast) '_Body_ ' num2str(Contrasts{iContrast}.BodyContrast)  '\\' 'Face_and_Body_binocular_FaceFixPosition' num2str(FixPointPositionsIndexFace) '_BodyFixPosition' num2str(FixPointPositionsIndexBody) '.tif']);
    %                     end

    imwrite(double(OutputImage)/255,['BinoRiv_stimuli/without_fp/Face_' num2str(RedImageContrast) '_Object_' num2str(CyanImageContrast) '.tif']);
%     if RedImageContrast ~= 0
%         imwrite(double(OutputImage_face)/255,['In2PB/Phys/Face_' num2str(RedImageContrast) '.tif']);
%     end
%     if CyanImageContrast ~= 0
%         imwrite(double(OutputImage_obj)/255,['In2PB/Phys/Object_' num2str(CyanImageContrast) '.tif']);
%     end
    if iContrast == 22
        !echo e
    end
end


toc
