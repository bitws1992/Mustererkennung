clear ;
%% 提取数据信息
info_3 = hdf5info('../m2_176-400.hdf5');
load('../../conv_tdms/m2_176-400.mat');
%% analog data import
L=length(info_3.GroupHierarchy.Groups);%数据的个数或者长度
data=can_vmps_yawrate_chassis.data;% original signal
time=can_vmps_yawrate_chassis.time;% original time
Label(88,1)=0;
Target=Label;
sumlabel(:)=0;
for i=1:L
    label = hdf5read(info_3.GroupHierarchy.Groups(i).Datasets(1));
    %time_3 = hdf5read(info_3.GroupHierarchy.Groups(i).Datasets(2));
    %name_3 = info_3.GroupHierarchy.Groups(i).Name;
    
    if  ~all(label==0)
        index=find(label>0);
        sumlabel(index)=label(index);
        %ss=time_3(index);
        %eval(['time_value',num2str(i),'=','ss',';'])
          
    end
end
sumlabel(1,length(label))=0;
sumlabel=sumlabel';

time_3 = hdf5read(info_3.GroupHierarchy.Groups(1).Datasets(2)); % time of label
fre=round(length(data)/(time_3(end)-time_3(1)));
%N=round(time_3(end)-time_3(1));
        for ii=round(time_3(1))+1:round(time_3(end))                                        %every 1 second
            index=find((time<(ii))&(time>=(ii-1)));
            aa=data(index);
            index_3=find((time_3<(ii))&(time_3>=(ii-1)));
            
           if ~all(sumlabel(index_3)==0)
                eval(['data_bad',num2str(ii),'=','aa',';']);
                Effwert(ii-round(time_3(1)),1:2)=[Eff(aa),1];
                varianz(ii-round(time_3(1)),1:2)=[var(aa),1];
                schiefe(ii-round(time_3(1)),1:2)=[skewness(aa),1];
                %statismerkmale(ii,4)=mean(aa);
               [Fre,Amp] = frequencySpectrum(aa,fre);
                FFTwert_mean(ii-round(time_3(1)),1:2)=[mean(Amp(2:end)),1];
                FFTwert_varianz(ii-round(time_3(1)),1:2)=[var(Amp(2:end)),1];
                FFTwert_max(ii-round(time_3(1)),1:2)=[max(Amp(2:end)),1];
                %statismerkmale(ii,5)=kurtosis(aa);
                %statismerkmale(ii,6)=max(aa);
                %Varianz(ii,3)=var(aa);
                %Schiefe(ii,3)=skewness(aa);
                Woelbung(ii-round(time_3(1)),1:2)=[kurtosis(aa),1];
                Target(ii-round(time_3(1)),1)=1;
           else 
                eval(['data_gut',num2str(ii),'=','aa',';']);
                Effwert(ii-round(time_3(1)),1:2)=[Eff(aa),0];
                varianz(ii-round(time_3(1)),1:2)=[var(aa),0];
                schiefe(ii-round(time_3(1)),1:2)=[skewness(aa),0];
                [Fre,Amp] = frequencySpectrum(aa,fre);
                FFTwert_mean(ii-round(time_3(1)),1:2)=[mean(Amp(2:end)),0];
                FFTwert_varianz(ii-round(time_3(1)),1:2)=[var(Amp(2:end)),0];
                FFTwert_max(ii-round(time_3(1)),1:2)=[max(Amp(2:end)),0];
                %statismerkmale(ii,4)=mean(aa);
                %[Fre,Amp] = frequencySpectrum(aa,200);
                % FFTwert(ii,1)=Amp(48);
                %statismerkmale(ii,5)=kurtosis(aa);
                %statismerkmale(ii,6)=max(aa);
                %Varianz(ii,3)=var(aa);
                %Schiefe(ii,3)=skewness(aa);
                Woelbung(ii-round(time_3(1)),1:2)=[kurtosis(aa),0];
                Target(ii-round(time_3(1)),1)=0;
          
   % figure()
    %plot(time(index(1):index(end)),ss);
    %hold on
    %plot(time_3(index_3(1)-100:index_3(end)+100),data_3(index_3(1)-100:index_3(end)+100))
    %legend('analog','label')
           end    
           Label=Target|Label;
        end
          % save Varianz Varianz      
   
Label=Label+0;
% save Label Label
close all
figure()
plot(time,data)
hold on 
plot(time_3,sumlabel)
save can_vmps_yawrate_chassis
