%obs & true are column vector
function report=regression(obs,true,n,plotswitch)
%分析前統計值計算
report.before.corr=corrcoef(obs,true);%相關係數
report.before.corr=report.before.corr(1,2);%相關係數
report.before.error_range=[min(obs-true) max(obs-true)];%誤差範圍
report.before.error_stdev=std(obs-true);%標準差
report.before.bias=mean(obs-true);
report.before.meanabserr=mean(abs(obs-true));%誤差絕對值之平均

%迴歸
z=zeros(n+1,length(obs));
for i=1:n;
    z(1,:)=1;
    z(i+1,:)=(obs').^i;
end
report.a=(inv(z*z'))*(z*true); %A

newobs=report.a(1);
for j=1:n
     newobs=newobs+(report.a(j+1))*obs.^j;
end

xx = linspace(min(obs),max(obs),200);
ideaobs = zeros(1,200)+report.a(1);
for i=1:n
    ideaobs = ideaobs+(report.a(i+1))*xx.^i;
end

%分析後統計值計算
report.after.corr=corrcoef(newobs,true);%相關係數
report.after.corr=report.after.corr(1,2);%相關係數
report.after.error_range=[min(newobs-true) max(newobs-true)];%誤差範圍
report.after.error_stdev=std(newobs-true);%標準差
report.after.bias=mean(newobs-true);
report.after.meanabserr=mean(abs(newobs-true));%誤差絕對值之平均

%plot
if (plotswitch == 1)
	newplot = figure('visible','off');
    
	x=obs; y=x;
	plot(x,y,'r','LineWidth',2);
    hold on;
	plot(xx,ideaobs,'g','LineWidth',1.5);
	plot(obs,true,'b.')
	title('Before');xlabel('Obs');ylabel('Standard');
	print(['-f',num2str(newplot)],'-djpeg',['.\report\plot\obs_true_d',num2str(n),'_before.jpeg'])
    clf(newplot);
    
	plot(obs,obs-true,'b.')
	title('Before');xlabel('Obs');ylabel('Err');
	print(['-f',num2str(newplot)],'-djpeg',['.\report\plot\obs_err_d',num2str(n),'_before.jpeg'])
    clf(newplot);
    
	x=newobs; y=x;
	plot(x,y,'r','LineWidth',2);
    hold on;
	plot(newobs,true,'b.')
	title('After');xlabel('Obs');ylabel('Standard');
	print(['-f',num2str(newplot)],'-djpeg',['.\report\plot\obs_true_d',num2str(n),'_after.jpeg'])
    clf(newplot);
    
	plot(newobs,newobs-true,'b.')
	title('After');xlabel('Obs');ylabel('Err');
	print(['-f',num2str(newplot)],'-djpeg',['.\report\plot\obs_err_d',num2str(n),'_after.jpeg'])
    clf(newplot);
    
    close(newplot);
end
return



