%% 

%signal=audioread('PKBloom.mp3');
%wavFileName='PKBloom.wav';
%audiowrite(wavFileName,signal,44100)
 %record time in seconds
[p1,Fs1]=audioread('pkbloom2.wav'); %read the audiorecording
p1=p1'; %take the transpose
p1=mean(p1);
tr=length(p1)/Fs1;

%Here we plot the time vs amplitude of the piano recording
% figure(1)
% plot((1:length(py))/Fsp,py);
% xlabel('Time [sec]'); ylabel('Amplitude');
% title('Bloom Paper Kites'); drawnow
starttime=1*Fs1;
endtime=6*Fs1;

seg1=p1(:,starttime:endtime);
p8=audioplayer(seg1,Fs1);
playblocking(p8); %plays the song

[p2,Fs2]=audioread('pkfeatherstone.wav');
p2=p2';
p2=mean(p2);
tr2=length(p2)/Fs2;

[p3, Fs3]=audioread('dploseyourselftodance.wav');
p3=p3';
p3=mean(p3);
tr3=length(p3)/Fs3;

[p4,Fs4]=audioread('dpinstantcrush.wav');
p4=p4';
p4=mean(p4);
tr4=length(p4)/Fs4;

[p5, Fs5]=audioread('Beethovenfurelise.wav');
p5=p5';
p5=mean(p5);
tr5=length(p5)/Fs5;

[p6,Fs6]=audioread('Beethoven5thSymphony.wav');
p6=p6';
p6=mean(p6);
tr6=length(p6)/Fs6;

[test1,test1_fs]=audioread('pkwoodland.wav');
test1=test1';
test1=mean(test1);
test1_tr=length(test1)/test1_fs;

[test2,test2_fs]=audioread('dpgetlucky.wav');
test2=test2';
test2=mean(test2);
test2_tr=length(test2)/test2_fs;

[test3, test3_fs]=audioread('MoonlightSonata.wav');
test3=test3';
test3=mean(test3);
test3_tr=length(test3)/test3_fs;

song1=splitsong(tr,p1,Fs1);
song2=splitsong(tr2,p2,Fs2);
song3=splitsong(tr3,p3,Fs3);
song4=splitsong(tr4,p4,Fs4);
song5=splitsong(tr5,p5,Fs5);
song6=splitsong(tr6,p6,Fs6);

testsong1=splitsong(test1_tr,test1,test1_fs);
testsong2=splitsong(test2_tr,test2,test2_fs);
testsong3=splitsong(test3_tr,test3,test3_fs);


%%
specsong1=spectransform(song1);
specsong2=spectransform(song2);
specsong3=spectransform(song3);
specsong4=spectransform(song4);
specsong5=spectransform(song5);
specsong6=spectransform(song6);

test1_spec=spectransform(testsong1);
test2_spec=spectransform(testsong2);
test3_spec=spectransform(testsong3);
%%

allsongs=[specsong1 specsong2 specsong3 specsong4(:,1:37) specsong5 specsong6(:,1:37)];
testsongs=[test1_spec test2_spec test3_spec];

%%
allsongs=allsongs-mean(allsongs,2);
[u, sigma, v]=svd(allsongs, 'econ');

%%
vprime_train=v';
vprime_test=inv(sigma)*u'*testsongs;

%%
%projection of test songs onto the basis for the training songs
Y=u'*testsongs;
input=u'*allsongs;
Y=Y';
input=input';


%%
input_mean=mean(input);
overallmean=[];
%mi=0;
band1=size(song1,1)+size(song2,1);
band2=size(song3,1)+size(song4,1);
band3=size(song5,1)+size(song6,1);
% band1=size(specsong1,2)+size(specsong2,2);
% band2=size(specsong3,2)+size(specsong4,2);
% band3=size(specsong5,2)+size(specsong6,2);
% for j=1:band1
%     mi=mi+input_mean(j);
%     mi=mi/band1;
% end 
%  overallmean=[overallmean mi];
% for j=band1+1:band1+band2+1
%     mi=mi+input_mean(j);
%     mi=mi/band2;
% end 
% overallmean=[overallmean mi];
% for j=band1+band2+2:band1+band2+band3
%     mi=mi+input_mean(j);
%     mi=mi/band3;
% end 
% overallmean=[overallmean mi];
 Y_mean=mean(Y);


%%
actual_values=string(zeros(1, size(testsongs,2)));
predicted_values=zeros(1, length(Y_mean));
for j=1:length(actual_values)
   if j<45
       actual_values(j)='g1';
   elseif j<93
       actual_values(j)='g2';
   else
       actual_values(j)='g3';
   end
end



% for j=1:length(predicted_values)
%     group1=abs(Y_mean(j)-overallmean(1));
%     group2=abs(Y_mean(j)-overallmean(2));
%     group3=abs(Y_mean(j)-overallmean(3));
%     n=min(group1,group2);
%     n=min(n,group3);
%     if n==group1
%         predicted_values(j)=1;
%     elseif n==group2
%         predicted_values(j)=2;
%     else
%         predicted_values(j)=3;
%     end
% end 
%%
% correct=0;
% for j=1:length(predicted_values)
%     if predicted_values(j)==actual_values(j)
%         correct=correct+1;
%     end
% end
%%
actvals_train=string(zeros(1,size(allsongs,2)));
for j=1:length(actvals_train)
    if j<band1+1
        actvals_train(j)='g1';
    elseif j<band1+band2+1
        actvals_train(j)='g2';
    else
        actvals_train(j)='g3';
    end
end
%%
%uprime=u';
subplot(3,1,1), bar(input(2:20)),set(gca,'Xlim',[0,20],'Ylim',[-2000 2000], 'Xtick',[],'Ytick',[],text(12,-1700),'C','Fontsize',[15])
%%
%KNN
vprime_train_normal=vprime_train';
vprime_test_normal=vprime_test';
actvalstrain_prime=actvals_train';
corrarray=[];
for modes=1:200
    model=fitcknn(vprime_train_normal(:,1:modes), actvals_train','NumNeighbors',1);
    label=predict(model,vprime_test_normal(:,1:modes));
    correctknn=0;
    for j=1:length(label)
        if label(j)==actual_values(j)
            correctknn=correctknn+1;
        end
    end
    corrarray=[corrarray correctknn];
end
figure
plot(corrarray,'Linewidth',[2])
%%
corrarray=[];
for modes=1:200
    model=fitcknn(input(:,1:modes), actvals_train','NumNeighbors',1);
    label=predict(model,Y(:,1:modes));
    correctknn=0;
    for j=1:length(label)
        if label(j)==actual_values(j)
            correctknn=correctknn+1;
        end
    end
    corrarray=[corrarray correctknn];
end
figure
plot(corrarray,'Linewidth',[2])


%%

%plot of the actual data normalized
figure
plot(allsongs(:,200), 'Linewidth',[2])
xlabel('time')
ylabel('y-value')
title('The different points extracted at each frame')
%%
%this looks at the diagonal values. This tells
%me what is going on in what direction. If it is big
%a lot is happening and if it is small then not 
%much is happening.
figure
plot(diag(sigma)/max(diag(sigma)), 'ro', 'Linewidth',[2])
xlabel('mode')
ylabel('normalized value')
title('Diagonal Values for SVD')
%This tells us how much each mode is contributing in terms of percentage
percen3=(diag(sigma)/max(diag(sigma)))/sum(diag(sigma)/max(diag(sigma)));
    
