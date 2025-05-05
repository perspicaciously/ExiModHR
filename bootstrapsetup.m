function [bootstrap_in,bootstrap_out,bootstrapmeans] = bootstrapsetup

for vid = 1:6
    switch vid
        case 1
            curvid = "wingfly"
        case 2
            curvid = "polar"
        case 3
            curvid = "wingjump"
        case 4
            curvid = "lion"
        case 5
            curvid = "tarantula"
        case 6
            curvid = "parkour"
    end
    for coeffnum = 1:10
        bootstrap_in(vid,coeffnum) = textread("Data/" + curvid + "Data_vidtest" + coeffnum + ".txt",'','headerlines',2)
    end
    bootstrap_out(vid,:) = bootstrp(100,@mean,bootstrap_in(vid,:)).'

    bootstrapmeans(vid) = mean(bootstrap_out(vid,:))

end