function vidtest (hrtimer,bhr_num, f_video) %function created to test the HR of a control group for video stimuli and write the data into the files, that will be used for later prediction

for i = 1:6
    switch i 
        case 1
             cur_vid = "wingfly"
        case 2 
             cur_vid = "polar"
        case 3 
             cur_vid = "wingjump"
        case 4
             cur_vid = "lion"
        case 5
             cur_vid = "tarantula"
        case 6
             cur_vid = "parkour"
    end
hr_start_vec(i) = hrtimer.TasksExecuted
playmedia("video",cur_vid,f_video)
hr_end_vec(i) = hrtimer.TasksExecuted

coeff = (max(hrtimer.UserData(2,hr_start_vec(i):hr_end_vec(i))) - hrtimer.UserData(2,hr_start_vec(i))) + (hrtimer.UserData(2,hr_end_vec(i)) - hrtimer.UserData(2,hr_start_vec(i)))

fileID = fopen(sprintf("Data/%sData_vidtest10.txt",cur_vid),"w")
fprintf(fileID,"%.1f ",hrtimer.UserData(1,hr_start_vec(i):hr_end_vec(i)))
fprintf(fileID,"\n")
fprintf(fileID,"%.1f ",hrtimer.UserData(2,hr_start_vec(i):hr_end_vec(i)))
fprintf(fileID,"\n")
fprintf(fileID,"%.10f",coeff)

tic
while toc<20
end



end
fileID = fopen("Data/AllhrData_vidtest.txt","w")   %writing the raw data into a different file too
fprintf(fileID,"%.1f ",hrtimer.UserData(1,:))
fprintf(fileID,"\n")
fprintf(fileID,"%.1f ",hrtimer.UserData(2,:))
end