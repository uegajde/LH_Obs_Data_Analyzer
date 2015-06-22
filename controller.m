function handles=controller(trigger,handles)
%
% main programmer : Lin Zhe-Hui
%
%------------------------------------------------------------------------------
% odselect & sdselect
%------------------------------------------------------------------------------
    if (strcmp(trigger,'odselect')||strcmp(trigger,'sdselect'))
        if  (strcmp(trigger,'odselect'))
            TARGET = 'od';
        elseif(strcmp(trigger,'sdselect'))
            TARGET = 'sd';
        end
        % initial
        % read new data
        [filename pathname] = uigetfile({'*.*'},'Select a File');
        fullpathname = strcat(pathname,filename);
        set(handles.(TARGET).name,'String',filename);
        temp = open(fullpathname);
        dot_index = strfind(filename,'.');
        cell_name = filename(1:dot_index(end)-1);
        if  (strcmp(trigger,'odselect'))
            handles.od.alldata = temp.(cell_name);
        elseif(strcmp(trigger,'sdselect'))
            handles.sd.alldata = temp.(cell_name);
        end
%------------------------------------------------------------------------------
% odread & sdread
%------------------------------------------------------------------------------
    elseif (strcmp(trigger,'odread')||strcmp(trigger,'sdread'))
        if  (strcmp(trigger,'odread'))
            TARGET = 'od';
        elseif(strcmp(trigger,'sdread'))
            TARGET = 'sd';
        end
        style = get(handles.(TARGET).style,'Value');
        line = get(handles.(TARGET).line,'String');
        if (style == 1) % cloumn
            sstyle = 'C';
            temp = handles.(TARGET).alldata(:,str2double(line));
            handles.(TARGET).data = temp;
            handles.(TARGET).state = true;
        else % row
            sstyle = 'R';
            temp = handles.(TARGET).alldata(str2double(line),:);
            temp = temp';
            handles.(TARGET).data = temp;
            handles.(TARGET).state = true;
        end
        handles.(TARGET).data = squeeze(handles.(TARGET).data);
        minv = min(temp);
        maxv = max(temp);
        dnum = length(temp);
        info = [sstyle,line,'   range:',num2str(minv),'~',num2str(maxv),'   num:',num2str(dnum)];
        set(handles.(TARGET).info,'String',info);
        if (handles.od.state == true && handles.sd.state == true)
            if (length(handles.od.data)==length(handles.sd.data))
                plot(handles.preview,handles.sd.data,handles.od.data,'g.');
                xlabel(handles.preview,'standard');
                ylabel(handles.preview,'obs');
            else
                plot(handles.preview,zeros(10,1),zeros(10,1),'g.');
                errinfo = 'data do not have same length';
                text(-0.55,0,errinfo);
            end
        end
%------------------------------------------------------------------------------
% output_plot
%------------------------------------------------------------------------------
    elseif (strcmp(trigger,'output_plot'))
        state = get(handles.output_plot,'Value');
        if (state == 0)
            set(handles.output_html,'Value',0);
        end
%------------------------------------------------------------------------------
% output_html
%------------------------------------------------------------------------------
    elseif (strcmp(trigger,'output_html'))
        state = get(handles.output_html,'Value');
        if (state == 1)
            set(handles.output_plot,'Value',1);
        end
        
%------------------------------------------------------------------------------
% analyze
%------------------------------------------------------------------------------
    elseif (strcmp(trigger,'analyze'))
        % package settings and data
        settings.degree = get(handles.degree,'Value');
        settings.output.text = get(handles.output_text,'Value');
        settings.output.plot = get(handles.output_plot,'Value');
        settings.output.html = get(handles.output_html,'Value');
        info = get(handles.info,'String');
        standard.data = handles.sd.data;
        standard.filename = get(handles.sd.name,'String');
        standard.info = get(handles.sd.info,'String');
        obs.data = handles.od.data;
        obs.filename = get(handles.od.name,'String');
        obs.info = get(handles.od.info,'String');
    
        % check data
        breakinfo = 'analyzing is suspend';
        if (handles.sd.state == false || handles.od.state == false)
            errinfo = 'lack data';
            easy_report = {errinfo;breakinfo};
            set(handles.log,'String',easy_report);
            return
        end
        if (length(obs.data) ~= length(standard.data))
            errinfo = 'data do not have same length';
            easy_report = {errinfo;breakinfo};
            set(handles.log,'String',easy_report);
            return
        end
    
        % start to analyze
        set(handles.log,'String','processing...');
        if (settings.degree == 6)
            for i=1:5
                degree = ['d',num2str(i)];
                analysis.(degree) = regression(obs.data,standard.data,i,settings.output.plot);
%                 analysis.(degree) = analyze_model(settings.degree,standard,obs,settings.output.plot);
            end
        else
            degree = ['d',num2str(settings.degree)];
                analysis.(degree) = regression(obs.data,standard.data,settings.degree,settings.output.plot);
%             analysis.(degree) = analyze_model(settings.degree,standard,obs,settings.output.plot);
        end
        prereport = pre_report_model(standard,obs,analysis,settings,info);
        handles.prereport = prereport;
        easy_report = easy_report_model(prereport,settings);
        if (settings.output.html == 1)
            html_report_model(prereport,analysis,settings);
        end
        set(handles.log,'String',easy_report);
        disp('done');
%------------------------------------------------------------------------------
% else
%------------------------------------------------------------------------------
    else
            disp('there is something wrong in controlller');
            disp({'trigger : ',trigger});
    end
return