function easy_report = easy_report_model(prereport,settings)
    % initialize
    seperate = '______________________________';
    
    % combine easy report
    easy_report = [prereport.program_info;...
                    seperate;...
                    prereport.obs.title;...
                    prereport.obs.filename;...
                    prereport.obs.select;...
                    prereport.obs.range;...
                    prereport.obs.number;...
                    seperate;...
                    prereport.standard.title;...
                    prereport.standard.filename;...
                    prereport.standard.select;...
                    prereport.standard.range;...
                    prereport.standard.number;...
                    seperate;...
                    prereport.settings.title;...
                    prereport.settings.degree;...
                    seperate;...
                    prereport.quality.title;...
                    prereport.quality.corr;...
                    prereport.quality.error_range;...
                    prereport.quality.bias;...
                    prereport.quality.error_stdev;...
                    prereport.quality.meanabserr;...
                    seperate;...
                    seperate;...
                    prereport.regression.title];
    if (settings.degree==6)
        for i=1:5
            degree = ['d',num2str(i)];
            easy_report = [easy_report;seperate;...
                            prereport.regression.(degree).title;...
                            prereport.regression.(degree).coefficient;...
                            prereport.regression.(degree).corr;...
                            prereport.regression.(degree).error_range;...
                            prereport.regression.(degree).bias;...
                            prereport.regression.(degree).error_stdev;...
                            prereport.regression.(degree).meanabserr];
            
        end
    else
        degree = ['d',num2str(settings.degree)];
        easy_report = [easy_report;seperate;...
                            prereport.regression.(degree).title;...
                            prereport.regression.(degree).coefficient;...
                            prereport.regression.(degree).corr;...
                            prereport.regression.(degree).error_range;...
                            prereport.regression.(degree).bias;...
                            prereport.regression.(degree).error_stdev;...
                            prereport.regression.(degree).meanabserr];
    end
                            
    
    % output to a file
    if (settings.output.text == 1)
%         filename = datestr(now,'./report/yyyy-mm-dd-HH-MM');
%         filename = [filename,'.txt'];
%         fid = fopen(filename,'w+');
        [fid,errmsg] = fopen('./report/anayis_report.txt','w+');
        disp(errmsg);
        lines = length(easy_report);
        for i=1:lines
            fprintf(fid,'%s\r\n',easy_report{i});
        end
        fclose(fid);
    end
return