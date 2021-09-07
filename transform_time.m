%%提取数据前两列，把时间截取成例如‘18 13:42:13’格式,再转换成第几秒。outnum为去表头以外数据
%如infile='./文件1.xlsx’
%outfile='./shuju1.xlsx'
function [outnum]=transform_time(infile,outfile)
    [num,txt]=xlsread(infile);
    txt1=txt(2:end,1);
    rowtxt1=length(txt1);
    str_long=length(txt1{1});
    for i=1:1:rowtxt1    %截取时间
        txt1{i}=txt1{i}(9:str_long-5);
    end
    txt(2:end,1)=txt1;
    GPS_V=num(:,1);
    %zhuansu=num(:,7);
    TITLE=txt(1,1:2);
     %% 字符串时间改成第几秒
    str_time=txt1;
    n=length(str_time);
    time=zeros(n,1);
    baseday=str2double(str_time{1}(1:2));
    basehour=str2double(str_time{1}(4:5));
    basemin=str2double(str_time{1}(7:8));
    basesec=str2double(str_time{1}(10:11));
    basetime=baseday*24*3600+basehour*3600+basemin*60+basesec;
    for i=1:1:n
        day=str2double(str_time{i}(1:2));
        hour=str2double(str_time{i}(4:5));
        min=str2double(str_time{i}(7:8));
        sec=str2double(str_time{i}(10:11));
        time(i)=day*24*3600+hour*3600+min*60+sec-basetime;
    end
    xlswrite(outfile,TITLE,1,'A1');
    %xlswrite(outfile,{'发动机转速'},1,'C1');
    xlswrite(outfile,time,1,'A2');
    xlswrite(outfile,GPS_V,1,'B2');
    %xlswrite(outfile,zhuansu,1,'C2');
    %outnum=[time,GPS_V,zhuansu];
    outnum=[time,GPS_V];
end
    