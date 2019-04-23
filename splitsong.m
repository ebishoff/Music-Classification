%this function takes in the time of the song,tr, the song amplititude
%file,py, and the sample rate, Fsp and chops the song into 5 second clips 
function songs=splitsong(tr,py,Fsp)
songs=[]; %file to hold the 5 second clips
%this tells me how many 5 second clips I can get from the song
totalsongclips=fix(tr/5); 
%initial start and end for the first song
starttemp=1*Fsp;
endtemp=6*Fsp;
%loop that take a song and splits it into 5 second clips and then holds it
%in the array, songs.
for j=1:totalsongclips-1 %I take one less just to avoid complications with
    %how long we have at the end of the song
  segtemp=py(:,starttemp:endtemp);
  songs=[songs; segtemp];
  starttemp=starttemp+5*Fsp;
  endtemp=endtemp+5*Fsp;
end