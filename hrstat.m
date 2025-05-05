function [statvec,statmatrix] = hrstat(hrtimer,start_ind,stop_ind)  %inputting the whole chunk of characteristics


statmatrix(1,:) = hrtimer.UserData(1,start_ind:stop_ind);           %heart rate vector output
statvec(1) = mean(statmatrix(1,:)) ;                                %mean
windz_vec = sort(statmatrix(1,:)) ;                                 %set up windsorized mean
windz_vec(1) = windz_vec(2);
windz_vec(end) = windz_vec(end-1);
statvec(2) = mean(windz_vec(:));                                    %windsorized mean
statvec(3) = std(statmatrix(1,:))/sqrt(length(statmatrix(1,:)));    %standard error
statvec(4) = min(statmatrix(1,:)); %minimum
statvec(5) = max(statmatrix(1,:)) ;%maximum
for i = 1:length(statmatrix(1,:))-1  ;                              %for the slope 
    statmatrix(2,i) = statmatrix(1,i+1) - statmatrix(1,i);          %change of each pair of points
end
for i = 1:length(statmatrix(2,:))-1  ;                              %for velocity change
    statmatrix(3,i) = statmatrix(2,i+1) - statmatrix(2,i);          %slope of pair of change of points
end
end
