lightSource; 
load('Ref_Passport.mat');
REF=R_Pass;
E=D65(:,1:2:61);
CIEXYZ_target=(100/(E*COL(:,2)))*COL'*(diag(E))*REF';


%Reading the image & computing the mean camera response to each patch
I = im2double(imread("Med_A.tif"));
chart = colorChecker(I);
displayChart(chart)
colorTable = measureColor(chart);

%Linearizing the camera photometric response using the equations we fit to 
%luminance factor and normalized digit counts of neutral samples of the
%color chart
R_Linearized_tr = 2.9745*colorTable.Measured_R.^3 -2.7022*colorTable.Measured_R.^2 +1.0882 * colorTable.Measured_R -0.079;
G_Linearized_tr = 3.524*colorTable.Measured_G.^3 -2.4261*colorTable.Measured_G.^2 + 0.9987 * colorTable.Measured_G -0.038;
B_Linearized_tr = 4.2824*colorTable.Measured_B.^3 -2.4411*colorTable.Measured_B.^2 + 1.1623 * colorTable.Measured_B -0.025;

RGB_tr_Linearized = [R_Linearized_tr,G_Linearized_tr,B_Linearized_tr]';

%Find the matrix M that finds the relationship between RGB camera response
%and CIEXYZ of the color chart; in other words, the matrix M that
%colorimetrically characterizes the camera

M=CIEXYZ_target*pinv(RGB_tr_Linearized);

%Now lets apply the M to an image

RGBt=imread('Med_A.tif');
RGBt=im2double(RGBt);
[m,n,c] = size(RGBt);
RGBt = reshape(RGBt(:,:,1:3),[m*n,3]);
x=m*n;
RGBt11_L(1:x,1)=2.9745*RGBt(:,1).^3-2.7022*RGBt(:,1).^2+1.0882 *RGBt(:,1)-0.079;
RGBt11_L(1:x,2)=3.524*RGBt(:,2).^3-2.4261*RGBt(:,2).^2+0.9987*RGBt(:,2)-0.038;
RGBt11_L(1:x,3)=4.2824*RGBt(:,3).^3-2.4411*RGBt(:,3).^2+1.1623*RGBt(:,3)-0.025;

RGB_c=M*RGBt11_L';
SRGB = xyztosrgb(RGB_c);
SRGB = min(max(SRGB,0),1);
rgb = im2uint8(SRGB); 
rgb = reshape(rgb',[m,n,3]);
rgbn = rgb;
figure(1);imshow(rgb)

%Now lets apply the M to an image

RGBt=imread('Med_A_N.tif');
RGBt=im2double(RGBt);
[m,n,c] = size(RGBt);
RGBt = reshape(RGBt(:,:,1:3),[m*n,3]);
x=m*n;
RGBt11_L(1:x,1)=2.9745*RGBt(:,1).^3-2.7022*RGBt(:,1).^2+1.0882 *RGBt(:,1)-0.079;
RGBt11_L(1:x,2)=3.524*RGBt(:,2).^3-2.4261*RGBt(:,2).^2+0.9987*RGBt(:,2)-0.038;
RGBt11_L(1:x,3)=4.2824*RGBt(:,3).^3-2.4411*RGBt(:,3).^2+1.1623*RGBt(:,3)-0.025;

RGB_c=M*RGBt11_L';
SRGB = xyztosrgb(RGB_c);
SRGB = min(max(SRGB,0),1);
rgb = im2uint8(SRGB); 
rgb = reshape(rgb',[m,n,3]);
figure(2);imshow(rgb)

%comparing the characterized cemara and the not characterized one
RGB=imread('Med_D.tif');
rgbn=im2double(rgbn);
RGBn=im2double(RGB);
figure(3);montage({rgbn,RGBn});
