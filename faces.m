%For this task we were asked to perform SVD analysis on a set of cropped
%and uncropped images. 

%Here we are just reading in the cropped faces from my computer
A=dir('C:\Users\ebish\Documents\MATLAB\582 file 4\CroppedYale\*')
croppedfaces=[];
for j=3:length(A)
    d=fullfile(A(j).folder, A(j).name);
    getpictures=dir(d);
    for jj=3:length(getpictures)
        individualpics=fullfile(getpictures(jj).folder,getpictures(jj).name);
        indpicsfiles=double(imread(individualpics));
        makevector=indpicsfiles(:);
        croppedfaces=[croppedfaces makevector];
    end
end

%saving the original images dimesions and saving cropped faces so that way 
%I don't have to run this code everytime and can just load these values 
%since it takes forever to load. 
mc=size(indpicsfiles,1);
nc=size(indpicsfiles,2);
save('croppedfaces.mat', 'croppedfaces');
save('mc.mat', 'mc');
save('nc.mat', 'nc');

%%
%Here we are just reading in the uncropped faces from my computer
B=dir('C:\Users\ebish\Documents\MATLAB\582 file 4\yalefaces\*')
uncropped=[];
for j=3:length(B)
    dd=fullfile(B(j).folder, B(j).name);
    unindpicsfiles=double(imread(dd));
    makevecun=unindpicsfiles(:);
    uncropped=[uncropped makevecun];
end
mu=size(unindpicsfiles,1);
nu=size(unindpicsfiles,2);

%saving the original images dimesions and saving cropped faces so that way 
%I don't have to run this code everytime and can just load these values 
%since it takes forever to load. 
save('uncropped.mat', 'uncropped');
save('mu.mat', 'mu');
save('nu.mat', 'nu');

%%
%Load the values from above. Since I ran this code once all I have to do
%when i rerun this code is start here. It saves a bunch of time
 load('uncropped.mat')
 load('croppedfaces.mat')
 load('mc')
 load('nc')
 load('mu')
 load('nu')
%%
%this I am just looking at an image of the cropped and uncropped data
t=reshape(croppedfaces(:,10),[mc, nc]);
tu=reshape(uncropped(:,10),[mu,nu]);
figure
pcolor(flip(t)), shading interp, colormap(gray)
figure
pcolor(flip(tu)), shading interp, colormap(gray)
%%
%perfomr SVD on cropped images
[uc,sigmac,vc]=svd(croppedfaces, 'econ');
%%
%plot of the modes from most imporant to least important 
figure
plot(diag(sigmac)/max(diag(sigmac)), 'ro', 'Linewidth',[2])
xlabel('mode')
ylabel('normalized value')
title('Diagonal Values for SVD Cropped Faces')
%This tells us how much each mode is contributing in terms of percentage
percentcropped=(diag(sigmac)/max(diag(sigmac)))/sum(diag(sigmac)/max(diag(sigmac)));
 
%first 6 eigenfaces
figure
subplot(2,3,1)
face1=reshape(uc(:,1),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,2)
face1=reshape(uc(:,2),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,3)
face1=reshape(uc(:,3),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,4)
face1=reshape(uc(:,4),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,5)
face1=reshape(uc(:,5),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,6)
face1=reshape(uc(:,6),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
sgtitle('6 First Modes for Eigenfaces for Cropped Faces')
%%
%this allows for me to find the number of modes needed to meet my energy
%threshold value of chosing. i chose to do 5 different threehold values
modestotal=[];
for threshold=[.2 .4 .6 .8 .9]
    sumperc=0;
    r=1;
    while sumperc<threshold
        sumperc=sumperc+percentcropped(r);
        r=r+1;
    end
    modestotal=[modestotal r];
end
%%
%reconstructing images based off a given number of modes
vcprime=vc';
modes=modestotal(3);



%%
%reconstructed images only with different number of modes
figure
reconstructedimages=uc*sigmac(:,1:modestotal(1))*vcprime(1:modestotal(1),:);
subplot(2,3,1)
face1=reshape(reconstructedimages(:,10),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
title('Face with 20% energy')

reconstructedimages=uc*sigmac(:,1:modestotal(2))*vcprime(1:modestotal(2),:);
subplot(2,3,2)
face1=reshape(reconstructedimages(:,10),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
title('Face with 40% energy')

reconstructedimages=uc*sigmac(:,1:modestotal(3))*vcprime(1:modestotal(3),:);
subplot(2,3,3)
face1=reshape(reconstructedimages(:,10),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
title('Face with 60% energy')

reconstructedimages=uc*sigmac(:,1:modestotal(4))*vcprime(1:modestotal(4),:);
subplot(2,3,4)
face1=reshape(reconstructedimages(:,10),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
title('Face with 80% energy')

reconstructedimages=uc*sigmac(:,1:modestotal(4))*vcprime(1:modestotal(4),:);
subplot(2,3,5)
face1=reshape(reconstructedimages(:,10),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
title('Face with 90% energy')

subplot(2,3,6)
face1=reshape(croppedfaces(:,10),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
title('Original face')
%%
%orignal image compared to reconstructed images
figure
subplot(3,2,1)
face1=reshape(croppedfaces(:,100),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
title('original face')
subplot(3,2,2)
face1=reshape(reconstructedimages(:,100),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
title('reconstructed face')
subplot(3,2,3)
face1=reshape(croppedfaces(:,200),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(3,2,4)
face1=reshape(reconstructedimages(:,200),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(3,2,5)
face1=reshape(croppedfaces(:,300),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(3,2,6)
face1=reshape(reconstructedimages(:,300),mc,nc); pcolor(flipud(face1)), shading interp, colormap(gray)
sgtitle('Cropped Faces with rank=179')


    
%% UnCropped Section
%taking SVD of uncropped images
[uu, sigmau, vu]=svd(uncropped, 'econ');

%%
%plot of the modes from most imporant to least important 
figure
plot(diag(sigmau)/max(diag(sigmau)), 'ro', 'Linewidth',[2])
xlabel('mode')
ylabel('normalized value')
title('Uncropped Diagonal Values for SVD')
%This tells us how much each mode is contributing in terms of percentage
percentuncropped=(diag(sigmau)/max(diag(sigmau)))/sum(diag(sigmau)/max(diag(sigmau)));
 
%%
%The first 6 eigenfaces 
figure
subplot(2,3,1)
face1=reshape(uu(:,1),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,2)
face1=reshape(uu(:,2),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,3)
face1=reshape(uu(:,3),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,4)
face1=reshape(uu(:,4),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,5)
face1=reshape(uu(:,5),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(2,3,6)
face1=reshape(uu(:,6),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
sgtitle('6 First Modes for Eigenfaces for Uncropped Faces')


%%
%this allows for me to find the number of modes needed to meet my energy
%threshold value of chosing. 
sumpercu=0;
thresholdu=.9;
ru=1;
while sumpercu<thresholdu
    sumpercu=sumpercu+percentuncropped(ru);
    ru=ru+1;
end 
%%reconstructed images only
vuprime=vu';

modes=ru;
reconstructedimagesu=uu*sigmau(:,1:modes)*vuprime(1:modes,:);

%%
%orignal compared to reconstructed
figure
subplot(3,2,1)
face1=reshape(uncropped(:,10),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
title('original face')
subplot(3,2,2)
face1=reshape(reconstructedimagesu(:,10),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
title('reconstructed face')
subplot(3,2,3)
face1=reshape(uncropped(:,20),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(3,2,4)
face1=reshape(reconstructedimagesu(:,20),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(3,2,5)
face1=reshape(uncropped(:,30),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
subplot(3,2,6)
face1=reshape(reconstructedimagesu(:,30),mu,nu); pcolor(flipud(face1)), shading interp, colormap(gray)
sgtitle('Uncropped Faces with rank=94')
