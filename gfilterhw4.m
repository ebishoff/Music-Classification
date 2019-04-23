function spc=gfilterhw4(a,b,tslidestep,v2,t,toptslide,k)
%I created this function called gfilter to take in the parameters
%a,b,tslidestep size, v2, time lenght of pice in seconds, and k
%and then implement a gabor filter. Then it also finds the max values
%for each timestep and creates a vector that holds those values.
%tslide is to say how to cut up the time domain, spc is to hold the values
%needed to create the spectogram and maximums hold the max frequency values
tslide=0:tslidestep:toptslide; 
spc=[];
for j=1:length(tslide)
    g=exp(-a*(t-tslide(j)).^b); %gabor filter
    vf=g.*v2; %multiply our piece by the gabor fillter
    vft=fft(vf); %place in  fourier space
    spc=[spc;abs(fftshift(vft))/(max(abs(vft)))]; %place values for spectogram

end