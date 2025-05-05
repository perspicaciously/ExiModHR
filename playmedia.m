function playmedia(type,name,f_video)  %a function i created to enable playing video+audio inside Matlab env. f_video is a figure in the gui 
switch type
    case "both"
        cur_vid = VideoReader("Video/" + name + "_v.mov")              %loading the video
        [curAudData,sampfreq] = audioread("Audio/" + name + "_a.mp3"); %loading the audio
        cur_aud = audioplayer(curAudData,sampfreq)                     %setting up audioplayer
        play(cur_aud)                                                  %playing the audio

        while hasFrame(cur_vid)                                        %hasFrame local function, playing each frame 
            subplot(f_video)                                           %switching to the figure in the gui (updating it back to the frame every second)
            vidFrame = readFrame(cur_vid);
            imshow(vidFrame);
            drawnow
        end

        tic
        while toc < 1
        end

        imshow("Video/breath/breath.001.jpeg",'Parent',f_video)

    case "video"                                               %playing video without audio
        cur_vid = VideoReader("Video/" + name + "_v.mov")
        tic
        while hasFrame(cur_vid)
            subplot(f_video)
            vidFrame = readFrame(cur_vid);
            imshow(vidFrame)
            drawnow
        end
        toc

        tic
        while toc < 1
        end
        
        imshow("Video/breath/breath.001.jpeg",'Parent',f_video)


end

end