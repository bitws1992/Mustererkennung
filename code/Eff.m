function [ effektivwert ] = Eff( s )
% zur Bechrechnung des Effektivwert
effektivwert=sqrt(sum((s).^2)/length(s));
end

