%this function takes a song and saves the absolute value spectogram 
%information in a vector and appends it to an array called songlist
function songlist=spectransform(song)
songlist=[];
for j=1:size(song,1)
    s=abs(spectrogram(song(j,:)));
    s=reshape(s,[size(s,1)*size(s,2),1]);
    songlist=[songlist s];
end 