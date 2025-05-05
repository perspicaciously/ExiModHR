function [guifig,subjname,curtime,slider1val,slider2val,slider3val,slider4val,msgpanel] = guisetup

guifig = uifigure('Position',[10 55 1700 1000])


namelbl = uilabel(guifig,'Position',[50 920 400 25],'Text','Name:','FontName','Code Bold','FontSize',20)
namefld = uieditfield(guifig,'Position',[116 916 300 28],'FontName','Code Bold','FontSize',20)

curtime = string(datetime)
datelbl = uilabel(guifig,'Position',[50 950 400 25],'Text','Date:   ' + curtime,'FontName','Code Bold', 'FontSize',20)

sliderlbl = uilabel(guifig,'Position',[125 780 500 150],'WordWrap','on','Text','Heart Rate Modulation (%)','FontName','Code Bold','FontSize',20)
slider1 = uislider(guifig,'Limits',[3 15],'Position',[75 600 225 75],'Orientation','Vertical')
slider2 = uislider(guifig,'Limits',[3 15],'Position',[175 600 225 75],'Orientation','Vertical')
slider3 = uislider(guifig,'Limits',[3 15],'Position',[275 600 225 75],'Orientation','Vertical')
slider4 = uislider(guifig,'Limits',[3 15],'Position',[375 600 225 75],'Orientation','Vertical')

confirmbutton = uibutton(guifig,'state','Position',[125 500 100 40],'Text','Confirm','FontName','Code Bold','FontSize',20)

startbutton = uibutton(guifig,'state','Position',[250 500 100 40],'Text','Start','FontName','Code Bold','FontSize',20)

msgpanel = uipanel(guifig,'Position',[50 25 425 450])

drawnow

waitfor(confirmbutton,'Value')
confirmbutton.Visible = 'off'

slider1val = round(slider1.Value)
slider2val = round(slider2.Value)
slider3val = round(slider3.Value)
slider4val = round(slider4.Value)

namefld.Enable = 'off'
slider1.Enable = 'off'
slider2.Enable = 'off'
slider3.Enable = 'off'
slider4.Enable = 'off'

subjname = namefld.Value

confirmmsg = sprintf("Subject: " + namefld.Value + "\nThe expected HR increases for each stimuli are as follows:\n1st : " + slider1val + "%%\n2nd : " + slider2val + "%%\n3rd : " + slider3val + "%%\n4th : " + slider4val + '%%')
%confirmmsgbx = msgbox(confirmmsg)
confirmmsglbl = uilabel(msgpanel,'Position',[5 250 400 225],'FontName','Code Bold','FontSize',20,'Text',confirmmsg,'WordWrap','on')

waitfor(startbutton,'Value')
startbutton.Visible = 'off'

%confirmmsglbl.Position = [5 150 50 225]
startmsglbl = uilabel(msgpanel,'Position',[5 150 225 50],'Text','Starting Experiment.','FontName','Code Bold','FontSize',20)