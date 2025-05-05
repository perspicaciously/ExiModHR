function readhrTest(~,~,hrchar,hrtimer,bhr_num,f_currenthr_raw,f_currenthr_delta,f_currenthr_velocity,f_cumul_hr)    %callback
%event type & time ~ is used to acknowledge but ignore the input(or output)

htc = hrtimer.TasksExecuted ;        %shortcut for the formula
velocity_smooth = 5;
hrvec = read(hrchar);                %a vector to store the 4 different numbers read form hrchar from bluetooth documentation
hrtimer.UserData(1,htc) = hrvec(2);  %takes the second value , (info about format,hr,energy expendure,timebetween rr waves in eecg) %(times.executed - index for storing the hr)


hhr = 50 ;          %how many hrs to plot within 1 graph   %limiting the scales to not compress, plotting 50 values ago to the current value
hhr2 = 20;
if bhr_num == 0
    subplot(f_currenthr_raw);
    plot(hrtimer.UserData(1,max(htc-hhr,1):htc),'-.b', 'lineWidth',2);    %plotting a vector, uses as Y the vector itself, as x the indicies of the vector - from matlab doc
   
    ylim([min(hrtimer.UserData(1,max(htc-hhr,1):htc))-2 max(hrtimer.UserData(1,max(htc-hhr,1):htc))+2]);  %buffers the limits of y
    set(gca,'XTick',[]);
    title('Heart Rate','FontName','Code Bold','FontSize',20);
    ylabel('Heart Rate (BPM)', 'FontName','Code Bold','FontSize',20);

    subplot(f_cumul_hr);
    plot(hrtimer.UserData(1,1:htc),'-.k','lineWidth', 2);                 %plotting a vector, uses as Y the vector itself, as x the indicies of the vector - from matlab doc
    ylim([min(hrtimer.UserData(1,1:htc))-2 max(hrtimer.UserData(1,1:htc))+2]);  %buffers the limits of y
    xlim([1 175])

  

    set(gca,'XTick',[]);
    title('HR Raw data (full)','FontName','Code Bold','FontSize',20);
    ylabel('Heart Rate (BPM)', 'FontName','Code Bold','FontSize',20);

    hrtimer.UserData(2,1) = htc;
    hrtimer.UserData(3,htc) = 0;
    drawnow;
elseif bhr_num > 0
    hrtimer.UserData(2,htc) = 100*(hrtimer.UserData(1,htc)-bhr_num)/bhr_num;
    hrtimer.UserData(3,htc) = hrtimer.UserData(2,htc)-mean(hrtimer.UserData(2,htc-velocity_smooth:htc-1));
    subplot(f_currenthr_raw);
    plot(hrtimer.UserData(1,max(htc-hhr,1):htc),'-.b','lineWidth', 2); %plotting a vector, uses as Y the vector itself, as x the indicies of the vector - from matlab doc
    ylim([min(hrtimer.UserData(1,max(htc-hhr,1):htc))-2 max(hrtimer.UserData(1,max(htc-hhr,1):htc))+2])  ;  %buffers the limits of y
    set(gca,'XTick',[]);
    title('Heart Rate','FontName','Code Bold','FontSize',20);
    ylabel('Heart Rate (BPM)', 'FontName','Code Bold','FontSize',20);
    
    subplot(f_cumul_hr);
    plot(hrtimer.UserData(1,1:htc),'-.k','lineWidth', 2);               %plotting a vector, uses as Y the vector itself, as x the indicies of the vector - from matlab doc
    ylim([min(hrtimer.UserData(1,1:htc))-2 max(hrtimer.UserData(1,1:htc))+2]);    %buffers the limits of y
    xlim([1 175])
    set(gca,'XTick',[]);
    title('HR Raw Data (full)','FontName','Code Bold','FontSize',20);
    ylabel('Heart Rate (BPM)', 'FontName','Code Bold','FontSize',20);
    
    subplot(f_currenthr_delta);
    plot(hrtimer.UserData(2,max(htc-hhr2,hrtimer.UserData(2,1)+1):htc),'-.r','lineWidth', 2);
    ylim([min(hrtimer.UserData(2,max(htc-hhr2,hrtimer.UserData(2,1)+1):htc))-2 max(hrtimer.UserData(2,max(htc-hhr2,hrtimer.UserData(2,1)+1):htc))+2]) ;            %buffers the limits of y
    set(gca,'XTick',[]);
    title('Normalized Heart Rate','FontName','Code Bold','FontSize',20);
    ylabel('% of baseline', 'FontName','Code Bold','FontSize',20);
    if htc > hrtimer.UserData(2,1) + 3
    subplot(f_currenthr_velocity);
    plot(hrtimer.UserData(3,max(htc-hhr,1):htc),'-.g','lineWidth', 2);
    ylim([min(hrtimer.UserData(3,max(htc-hhr,1):htc))-2 max(hrtimer.UserData(3,max(htc-hhr,1):htc))+2])
    set(gca,'XTick',[]);
    title("Average HR Velocity (Past " + velocity_smooth + " Measurements)",'FontName','Code Bold','FontSize',20);
    ylabel('Change in Heart Rate per second', 'FontName','Code Bold','FontSize',20);
    end
    drawnow;
end