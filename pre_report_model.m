function prereport=pre_report_model(standard,obs,analysis,settings,info)
%
% main programmer : Lin Zhe-Hui
%

% < input variable structure >               < output variable structure >
% info-------------------------------------> prereport.program_info

%                                            prereport.obs.title
% obs.data---------------------------------> x
% obs.filename-----------------------------> prereport.obs.filename
% obs.info---------------------------------> prereport.obs.select
%                                         -> prereport.obs.range 
%                                         -> prereport.obs.number

%                                            prereport.standard.title
% standard.data----------------------------> x
% standard.filename------------------------> prereport.standard.filename
% standard.info----------------------------> prereport.standard.select
%                                         -> prereport.standard.range 
%                                         -> prereport.standard.number

%                                            prereport.settings.title
% settings.degree--------------------------> prereport.settings.degree
% settings.output.txt----------------------> x
% settings.output.html---------------------> x
% settings.output.plot---------------------> x

%                                            prereport.quality.title
% analysis.(degree).before.corr------------> prereport.quality.corr
% analysis.(degree).before.error_range-----> prereport.quality.error_range
% analysis.(degree).before.bias------------> prereport.quality.bias
% analysis.(degree).before.error_stdev-----> prereport.quality.error_stdev
% analysis.(degree).before.meanabserr------> prereport.quality.meanabserr

%                                            prereport.regression.title
%                                            prereport.regression.(degree).title
% analysis.(degree).a----------------------> prereport.regression.(degree).coefficient
%                                         -> prereport.regression.(degree).raw_coefficient
% analysis.(degree).after.corr-------------> prereport.regression.(degree).corr
% analysis.(degree).after.error_range------> prereport.regression.(degree).error_range
% analysis.(degree).after.bias-------------> prereport.regression.(degree).bias
% analysis.(degree).after.error_stdev------> prereport.regression.(degree).error_stdev
% analysis.(degree).after.meanabserr-------> prereport.regression.(degree).meanabserr

    
%__________________________________________________________________________
%   Program Info
%
    prereport.program_info = info;
    
    
%__________________________________________________________________________
%   Data Info
%
    % Obs Data Info
    prereport.obs.title = 'Observation Data Info';
    prereport.obs.filename = ['filename : ',obs.filename];
    a = strfind(obs.info,'range');
    b = strfind(obs.info,'num');
    prereport.obs.select = ['select area : ',obs.info(1:a-1)];
    prereport.obs.range = ['range : ',obs.info(a+6:b-1)];
    prereport.obs.number = ['number : ',obs.info(b+4:end)];
    
    % Standard Data Info
    prereport.standard.title = 'Standard Data Info';
    prereport.standard.filename = ['filename : ',standard.filename];
    a = strfind(standard.info,'range');
    b = strfind(standard.info,'num');
    prereport.standard.select = ['select area : ',standard.info(1:a-1)];
    prereport.standard.range = ['range : ',standard.info(a+6:b-1)];
    prereport.standard.number = ['number : ',standard.info(b+4:end)];
    
    
%__________________________________________________________________________
%   Settings
%
    prereport.settings.title = 'Settings';
    if (settings.degree == 6)
        sdegree = '1~5';
    else
        sdegree = num2str(settings.degree);
    end
    prereport.settings.degree = ['degree : ',sdegree];
    
    
%__________________________________________________________________________
%	Observation Data Quality Analysis
%
    if (settings.degree == 6)
        degree = 'd1';
    else
        degree = ['d',num2str(settings.degree)];
    end
    prereport.quality.title = 'Observation Data Quality Analysis';
        
    prereport.quality.corr = ...
        ['Correlation coefficient : ',num2str(analysis.(degree).before.corr)];
         
    prereport.quality.error_range = ...
        ['Error range : ',num2str(analysis.(degree).before.error_range(1)),...
            ' ~ ',num2str(analysis.(degree).before.error_range(2))];
        
    prereport.quality.bias = ...
        ['Bias : ',num2str(analysis.(degree).before.bias)];
        
    prereport.quality.error_stdev = ...
        ['Error stdev : ',num2str(analysis.(degree).before.error_stdev)];
         
    prereport.quality.meanabserr = ...
        ['Mean(Abs(Error)) : ',num2str(analysis.(degree).before.meanabserr)];
    
%__________________________________________________________________________
%   Standardize & Error Analysis
%
    prereport.regression.title = 'Standardized Data Quality Analysis';
    
    if (settings.degree == 6)
        for i=1:5
            degree = ['d',num2str(i)];
            prereport.regression.(degree).title = ['Polynomial  Degree : ',num2str(i)];
            prereport.regression.(degree).raw_coefficient = analysis.(degree).a;
            prereport.regression.(degree).coefficient = {'Polynomial coefficient'};
            for j=1:length(analysis.(degree).a)
                prereport.regression.(degree).coefficient = ...
                    [prereport.regression.(degree).coefficient;...
                        ['    a',num2str(j-1),' : ',num2str(analysis.(degree).a(j))]];
                
            end
            
            prereport.regression.(degree).corr = ...
                ['Correlation coefficient : ',num2str(analysis.(degree).after.corr)];
            
            prereport.regression.(degree).error_range = ...
                ['Error range : ',num2str(analysis.(degree).after.error_range(1)),...
                            ' ~ ',num2str(analysis.(degree).after.error_range(2))];
            
            prereport.regression.(degree).bias = ...
                ['Bias : ',num2str(analysis.(degree).after.bias)];
            
            prereport.regression.(degree).error_stdev = ...
                ['Error stdev : ',num2str(analysis.(degree).after.error_stdev)];
            
            prereport.regression.(degree).meanabserr = ...
                ['Mean(Abs(Error)) : ',num2str(analysis.(degree).after.meanabserr)];
        end
    else
        degree = ['d',num2str(settings.degree)];
        prereport.regression.(degree).title = ['Polynomial Degree : ',num2str(settings.degree)];
        prereport.regression.(degree).raw_coefficient = analysis.(degree).a;
        prereport.regression.(degree).coefficient = {'Polynomial coefficient'};
        for j=1:length(analysis.(degree).a)
            prereport.regression.(degree).coefficient = ...
                [prereport.regression.(degree).coefficient;...
                ['    a',num2str(j-1),' : ',num2str(analysis.(degree).a(j))]];
        end
        
        prereport.regression.(degree).corr = ...
            ['Correlation coefficient : ',num2str(analysis.(degree).after.corr)];
            
        prereport.regression.(degree).error_range = ...
            ['Error range : ',num2str(analysis.(degree).after.error_range(1)),...
                            ' ~ ',num2str(analysis.(degree).after.error_range(2))];
            
        prereport.regression.(degree).bias = ...
            ['Bias : ',num2str(analysis.(degree).after.bias)];
            
        prereport.regression.(degree).error_stdev = ...
            ['Error stdev : ',num2str(analysis.(degree).after.error_stdev)];
            
        prereport.regression.(degree).meanabserr = ...
            ['Mean(Abs(Error)) : ',num2str(analysis.(degree).after.meanabserr)];
    end
    
    if (settings.output.plot == 1)
        newplot = figure('visible','off');
        figure(newplot);
        set(newplot,'visible','off');
        
        plot(standard.data);
        title('standard data');
        print(['-f',num2str(newplot)],'-djpeg',['.\report\plot\standard_data.jpeg'])
        clf(newplot);
        
        plot(obs.data);
        title('observation data');
        print(['-f',num2str(newplot)],'-djpeg',['.\report\plot\observation_data.jpeg'])
        clf(newplot);
        
        plot(obs.data,standard.data,'.');
        title('compare obs and standard data');
        xlabel('observation');
        ylabel('standard');
        print(['-f',num2str(newplot)],'-djpeg',['.\report\plot\compare.jpeg'])
        clf(newplot);
        
        close(newplot);
    end
return