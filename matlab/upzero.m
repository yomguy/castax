function [out]=upzero(i,n)

% Ajoute des z�ros en pr�fixe � i n jusqu'� (n*10-1)

i0=i;
out=num2str(i);

for l=1:1:n-1
        kn=[];
     for j=1:1:l
        kn=[kn '9'];
     end
     if i0 <= str2num(kn)
        out=['0' out];
     end
end
