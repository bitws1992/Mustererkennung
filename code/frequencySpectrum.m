function [Fre,Amp,Ph,Fe] = frequencySpectrum( data,Fs,varargin)
    %����Ҷ�任
    % data:��������
    % Fs:������
    % varargin:
    % isaddzero->�Ƿ��㣬Ĭ��Ϊ1������ᰴ��data�ĳ��Ƚ���fft
    % scale->��ֵ�ĳ߶ȣ�'amp'Ϊ��ֵ�ף�'ampDB'Ϊ�ֱ���ʾ�ķ�ֵ��,'mag'Ϊ�����׾���fft֮��ֱ��ȡģ,'magDB'Ϊ'mag'��Ӧ�ķֱ�
    % isdetrend->�Ƿ����ȥ��ֵ����Ĭ��Ϊ1
    % �õ�����[fre:Ƶ��,Amp:��ֵ,Ph:��λ,Fe:ԭʼ�ĸ���]
    %http://www.voidcn.com/article/p-yxrqcoxu-bev.html
    isAddZero = 1;
    scale = 'amp';
    isDetrend = 1;
    while length(varargin)>=2
        prop =varargin{1};
        val=varargin{2};
        data_length=varargin{3};% Ϊ��ʹ�ù涨�ĳ���
        varargin=varargin(4:end);
        switch lower(prop)
            case 'isaddzero' %�Ƿ�����0
                isAddZero = val;
            case 'scale'
                scale = val;
            case 'isdetrend'
                isDetrend = val;
        end
    end

    n=length(data);
    if isAddZero
        N=2^nextpow2(n);
    else
        N =data_length;
    end

    if isDetrend
        Y = fft(detrend(data),N);
    else
        Y = fft(data,N);
    end

    Fre=(0:N-1)*Fs/N;%Ƶ��
    Fre = Fre(1:N/2);
    Amp = dealMag(Y,N,scale);
    ang=angle(Y(1:N/2));
    Ph=ang*180/pi;
    Fre = Fre';
    Fe = Amp.*exp(1i.*ang);
end

function amp = dealMag(fftData,fftSize,scale)
    switch lower(scale)
        case 'amp'
            amp=abs(fftData);
            amp(1)=amp(1)/fftSize;
            amp(2:fftSize/2-1)=amp(2:fftSize/2-1)/(fftSize/2);
            amp(fftSize/2)=amp(fftSize/2)/fftSize;
            amp=amp(1:fftSize/2);
        case 'ampdb'
            amp=abs(fftData);
            amp(1)=amp(1)/fftSize;
            amp(2:fftSize/2-1)=amp(2:fftSize/2-1)/(fftSize/2);
            amp(fftSize/2)=amp(fftSize/2)/fftSize;
            amp=amp(1:fftSize/2);
            amp = 20*log(amp);
        case 'mag'
            amp=abs(fftData(1:fftSize/2));
        case 'magdb'
            amp=abs(fftData(1:fftSize/2));
            amp = 20*log(amp);
        otherwise
            error('unknow scale type');
    end
end