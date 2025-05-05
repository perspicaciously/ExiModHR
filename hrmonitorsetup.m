function [hrmonitor,hrchar] = hrmonitorsetup(timeout)           %need device for the code to exist outside the function and the characteristic could know what to point to
    if isempty(blelist("Name","HRM-Dual","Timeout",timeout))    %all of the bluetoothlowE devices HRM-Dual(mine) timeout-how long to look for
        hrchar = 0;
        hrmonitor = 0;
    else
        hrmonitor = ble("HRM-Dual:348778")                                          %ble - connect
        hrchar = characteristic(hrmonitor,"Heart Rate","Heart Rate Measurement")    %characteristic is a MATLAB object. (Heart Rate - one of the bluetooth services, Heart Rate Measurement - one of the bluetooth characteristics of the Heart Rate service) 
    end
end