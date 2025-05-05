%UTD 1 semester project: Emotional modulation (predesigned patterns) through video and
%audio channels quantified by heart rate tracking in real time, relative to
%normalized baseline HR measurements. The program takes into consideration
%HR velocity in response to a stimulus and predictively chooses the next
%stimulus according to given coefficients of excitement (only video or
%video+audio for a stronger effect).
% After the experiment, the program compares the actual data with the
% prediction, then initiates bootstrapping to perform the statistical analysis
% and rejects or fails to reject the null hypothesis.

%MATLAB + bluetooth HR monitor (Garmin HRM-Dual) + library of videos and audios and
%jpegs

% initialize heart rate monitor
clear variables
timeout = 3;             %initial search for the device
basehr_time = 30 ;       %seconds to take the baseline HR of the person tested
start_ind = 1;           %to initialize hrstat(my function) from beginning of HR measurements
dif = inf;               %to start comparing videos to predicted coeffs
vidnum = 4               %number of shown stimuli (videos)
playvidind = zeros(1,vidnum)    %all indicies of vids that will be played
vid_start_ind = zeros(1,vidnum) %start indicies of all the vids that are played
vid_stop_ind = zeros(1,vidnum)  %stop indicies of all the vids that are played
exp_coef = zeros(1,vidnum)      %experiment coefficients
mediatype = "both"              %video and audio
pausetime = 0                   %initialize variable for later use between videos

coeffvec(1) = textread('Data/wingflyData_vidtest.txt','','headerlines',2)        %reading the test coefficients that were created on a basis of real measurements of HR velocity responses (functions vidtest and vidautest) when demonstrated the videos to control group   
coeffvec(2) = textread('Data/polarData_vidtest.txt','','headerlines',2)
coeffvec(3) = textread('Data/wingjumpData_vidtest.txt','','headerlines',2)
coeffvec(4) = textread('Data/lionData_vidtest.txt','','headerlines',2)
coeffvec(5) = textread('Data/tarantulaData_vidtest.txt','','headerlines',2)
coeffvec(6) = textread('Data/parkourData_vidtest.txt','','headerlines',2)
coeffnames = ["wingfly" "polar" "wingjump" "lion" "tarantula" "parkour"]

[sortedcoeffvec,I] = sort(coeffvec)     %creating a vector of sorted velocity coefficients for all the stimuli (where I is a MATLAB argument that retains the order of the places)
sortedcoeffnames = coeffnames(I)        %creating a vector of names of the stimuli in the ascending order of their coefficients 

sortedcoeffvec = sortedcoeffvec*15/max(sortedcoeffvec)   %bringing the coefficients to a 1-15% scale for precise design of excitment curve via GUI setup 
nextexpectedcoeffvec = sortedcoeffvec                    %a vector for auto-determination of the next stimulus to be played

[bootstrap_coefficients,bootstrap_samples,bootstrap_means] = bootstrapsetup   %bootstrap function that simulates a 100 pool of control group participants to calibrate the coefficients
for vid = 1:6
    coeffstderror(vid) = std(bootstrap_samples(vid,:))/sqrt(length(bootstrap_samples(vid)))    %standard deviation for all bootstrapped tests
end

sortedcoeffstderror = coeffstderror(I)                    %using the stderror data based on the 100 simulated participants pool to create the "corridor" of acceptable limits for the further analysis (and plotting)

[guifig,subjname,curtime,pcinc(1),pcinc(2),pcinc(3),pcinc(4),msgpanel] = guisetup        %setting up a basic gui to run the experiment (f.e. by users with no coding experience) - my function guisetup


bhr_num = 0;                                                           %I set the baseline HR to 0 and the fuction readhrTest starts plotting my delta only after the baseline HR is calculated and not at once 
hrchar = 0;                                                            %what it reads in HRM measurement (actual HR in real time, cont. updated)
while hrchar == 0;
    [hrdev,hrchar] = hrmonitorsetup(timeout);                                %how long to serach for the bluetooth device
    if hrchar == 0;
        disp("Heart Rate Monitor not found, will try reconnecting." )        %troubleshooting 
        timeout = 10;                                                        %cz HR monitor slows down the rate it sends out signals at after some time (timeout is an argument to the blelist function that sets how long to look for the device for (my function hrmonitorsetup))
    else
        disp("Heart Rate Monitor connected.")                                %positive feedback in case of success 
    end
end


%display setup
allfig = figure("Position",[25 55 2000 1000], 'MenuBar', 'none', 'ToolBar', 'none') % figure names: f_currenthr_raw, f_currenthr_delta, f_currenthr_velocity, f_video

f_video = subplot('Position',[.4 .31 .500 .6]);         
imshow("Video/breath/breath.001.jpeg")              %dispaying instructions to take deep breaths to stabilize the HR of a participant

drawnow

tic
while toc < 3
end
%setting up plotting for HR 
f_currenthr_raw = subplot('Position',[.05 .65 .3 .25]);       %%3456 × 2234 - MAC positions resolution
set(gca,'XTick',[]);
set(gca,'YTick',[]);
f_currenthr_delta = subplot('Position',[.05 .35 .3 .25]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
f_currenthr_velocity = subplot('Position',[.05 .05 .3 .25]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
f_cumul_hr = subplot('Position',[.4 .05 .5 .25])




% initialize timer
hrtimer = timer ;                     %matlab variable structure, command to set up a timer (structure of functions and variables that executes with a specified period)   
hrtimer.TimerFcn = {@readhrTest,hrchar,hrtimer,bhr_num, f_currenthr_raw,f_currenthr_delta,f_currenthr_velocity,f_cumul_hr} ;   %timerfunction contains the function that timer will execute every time it is executed
hrtimer.Period = 1 ;                  % seconds,rate at which it executes
hrtimer.TasksToExecute = 2400 ;       %how many times (later set to number of times it has been executed, property to timer "tasksExecuted")        
hrtimer.ExecutionMode = "fixedRate" ; %initiates the function at every period rather than running it once
start(hrtimer);

% take base heart rate

tic
while toc < basehr_time ;
end

[basestatvec,basestatmat] = hrstat(hrtimer,start_ind,hrtimer.TasksExecuted); %format baseline data, from my function hrstat: statvec->basestatvec, statmatrix->basestatmat 

bhr_num = floor(basestatvec(2))                                              %windzorized mean rounded down to the nearest integer 
disp ("baseline heart rate for the object is  " + bhr_num)

hrtimer.TimerFcn = {@readhrTest,hrchar,hrtimer,bhr_num, f_currenthr_raw,f_currenthr_delta,f_currenthr_velocity,f_cumul_hr} ;  %reinitialize the timer function to update the inputs, since the hr baseline is different now
tic 

while toc < 6;
end
%calculating the delta
 

%choosing videos for the for experiment:

for playind = 1:vidnum
    dif = inf     %dif between the vid coeff and desired coef 
    for vidind = 1:6
        if dif > abs(pcinc(playind)-nextexpectedcoeffvec(vidind)) && sum(vidind == playvidind) == 0     %pcinc - what coef u want from sliders, test for presence of a specific character in the array
            dif = abs(pcinc(playind)-nextexpectedcoeffvec(vidind))                                      %measures the dif and searches for the lowest dif and sets the ind for the next vid
            playvidind(playind) = vidind
        end
    end
   
    vid_start_ind(playind) = hrtimer.TasksExecuted;      %recording the start hr value of this vid
    playmedia(mediatype,sortedcoeffnames(playvidind(playind)),f_video)
    drawnow
    vid_stop_ind(playind) = hrtimer.TasksExecuted;  %recording the finish hr value of this vid
    
    %creating a vector of experimental coefficients recorded during
    %experiment
    exp_coef(playind) = (max(hrtimer.UserData(2,vid_start_ind(playind):vid_stop_ind(playind))-hrtimer.UserData(2,vid_start_ind(playind))) + (hrtimer.UserData(2,vid_stop_ind(playind))-hrtimer.UserData(2,vid_start_ind(playind))))
    tic
    while (toc < 3) || (toc < 20 && hrtimer.UserData(hrtimer.TasksExecuted) > 1.05 * bhr_num)      %calculating the pause length, and evaluating based on it the type of the stimulus that will be played next 
        pausetime = toc;
        subplot(f_video)                                            %displaying the "take a deep breath" instruction to help the participant normilize hr
    end
    if(exp_coef(playind) > nextexpectedcoeffvec(playind) || (pausetime > 19 && max(hrtimer.UserData(3,vid_start_ind(playind):vid_stop_ind(playind))) < 3 ) || max(hrtimer.UserData(3,vid_start_ind(playind):vid_stop_ind(playind))) > 5)
        mediatype = "video"
    else
        mediatype = "both"
    end
    nextexpectedcoeffvec = sortedcoeffvec-(exp_coef(playind)*15/max(sortedcoeffvec)-sortedcoeffvec(playvidind(playind)))  %measuring the difference in hr coefficients between control group and the participant, and adjusting the formula based on the difference
end

%writing the data into output file:
fileid = fopen("ExperimentResults/" + subjname + curtime + ".txt","a")                         %creating a file to write the data from the experiment
fprintf(fileid,"Subject: %s\nTime of Experiment: %s\n\nRaw Heart Rate Data:",subjname,curtime) %writing the experimental data 
writematrix(hrtimer.UserData(1,:),"ExperimentResults/" + subjname + curtime + ".txt",'Delimiter',' ','WriteMode','append') %writing the raw hr data 

fprintf(fileid,"\nNormalized Heart Rate Data:")                                                 %writing the normalized hr data title for the section
writematrix(hrtimer.UserData(2,:),"ExperimentResults/" + subjname + curtime + ".txt",'Delimiter',' ','WriteMode','append')  %writing the normalized hr data

fprintf(fileid,"Heart Rate Velocity (over n-5 values):")                                        %writing the hr velocity data title for the section
writematrix(hrtimer.UserData(3,:),"ExperimentResults/" + subjname + curtime + ".txt",'Delimiter',' ','WriteMode','append') %writing the hr velocity data

fprintf(fileid,"\nVideos Played:\n")                                                            %writing the data title for the section of videos played
writematrix(sortedcoeffnames(playvidind),"ExperimentResults/" + subjname + curtime + ".txt",'Delimiter',' ','WriteMode','append')
writematrix(sortedcoeffvec(playvidind),"ExperimentResults/" + subjname + curtime + ".txt",'Delimiter',' ','WriteMode','append')

fprintf(fileid,"\nStart/Stop Indices:")
writematrix(vid_start_ind,"ExperimentResults/" + subjname + curtime + ".txt",'Delimiter',' ','WriteMode','append')
writematrix(vid_stop_ind,"ExperimentResults/" + subjname + curtime + ".txt",'Delimiter',' ','WriteMode','append')

fprintf(fileid,"\nSubject Coefficients:")
writematrix(exp_coef,"ExperimentResults/" + subjname + curtime + ".txt",'Delimiter',' ','WriteMode','append')

fprintf(fileid,"\nDifference in Coefficients:")
writematrix(exp_coef-sortedcoeffvec(playvidind),"ExperimentResults/" + subjname + curtime + ".txt",'Delimiter',' ','WriteMode','append')


figure(guifig)

stop(hrtimer)

%plotting the baseline hr and raw hr data:
f_total = uiaxes(guifig,"Position",[750 650 900 300])

plot(f_total,hrtimer.UserData(1,:),'-k','lineWidth', 2)
hold on
yline(f_total, bhr_num,'-r','lineWidth', 1.5)
ylim([50 170]);
grid on
f_total.GridLineStyle=':'
%legend('raw HR data', 'baseline HR')


%plotting the control group coefficients (with bootstrapped std) vs the experimental coefficients:
f_compare_coeffs = uiaxes(guifig,"Position",[750 50 900 300])
hold(f_compare_coeffs,"on")
errorbar(f_compare_coeffs,sortedcoeffvec(playvidind),sortedcoeffstderror(playvidind),'-g*')
plot(f_compare_coeffs,sortedcoeffvec(playvidind)-sortedcoeffstderror(playvidind),'-.g')
plot(f_compare_coeffs,sortedcoeffvec(playvidind)+sortedcoeffstderror(playvidind),'-.g')
plot(f_compare_coeffs,exp_coef,'-r*','lineWidth', 1.5)


%making input section:
nlbl = uilabel(guifig,'Position',[1375 650 50 28],'Text','N =','FontName','Code Bold','FontSize',20)
nfld = uieditfield(guifig,'numeric','Position',[1405 650 50 28],'FontName','Code Bold','FontSize',20)

nbutton = uibutton(guifig,'state','Position',[1475 650 100 28],'Text','Bootstrap','FontName','Code Bold','FontSize',20)

dflbl = uilabel(guifig,'Position',[1375 600 100 28],'Text','','FontName','Code Bold','FontSize',20)

alphalbl = uilabel(guifig,'Position',[1375 550 100 28],'Text','','FontName','Code Bold','FontSize',20)

plbl = uilabel(guifig,'Position',[1375 500 300 100],'Text','','FontName','Code Bold','FontSize',20)


waitfor(nbutton,'Value')        %number of data samples 
dflbl.Text = "df = " + num2str(100+nfld.Value-2)  %calculating degrees of freedom

%bootstrapping the experimental data to obtain the necessary amount of data points for the statistical analysis:
for vidctr = 1:4
    for btstrpinnum = 1:10
        btstrpcoeffs(vidctr,btstrpinnum) = exp_coef(vidctr)*(.14*rand+.93)
    end
    boot_coef_exp(vidctr,:) = bootstrp(nfld.Value,@mean,btstrpcoeffs(vidctr,:)).'
    btstrpcoeff_mean(vidctr) = mean(boot_coef_exp(vidctr,:))
end


alphalbl.Text = "alpha = .05"   %setting up the standard alpha value

[hypothesis, pvalue] = ttest2(bootstrap_means(playvidind),btstrpcoeff_mean)

plbl.Text = "p-value = " + pvalue

if pvalue > .05
    exp_res = "fails to reject"
else
    exp_res = "rejects"
end

resultmsglbl = uilabel(msgpanel,'Position',[5 75 225 50],'Text',"The experiment " + exp_res + "the null hypothesis.",'FontName','Code Bold','FontSize',20) %

close(allfig)


%to store the data for each video - tests
%vidtest(hrtimer,bhr_num,f_video)
%vidautest(hrtimer,bhr_num,f_video)