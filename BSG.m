function M = BSG(novel, file, epsi,alpha,beta)
     im=im2double(imread(file));
     finalimage = zeros(288,384);
     k = 0;
     for i = 1:288
         for j = 1:384
             xt = [im(i,j,1) im(i,j,2) im(i,j,3)];
             I = xt(1)+xt(2)+xt(3);
             k = k+1;
             CB = novel(k);
             for t = 1: size(CB)
                 CWm = CB(t);
                 if(~isempty(CWm{1}))
                      CWm1 = CWm{1}{1};
                      Vm = CWm1{1}{1};
                      Auxm = CWm1{2}{1};
                      if colordist(xt,Vm) < epsi && (brightness(xt,Auxm(1),Auxm(2), alpha, beta) == 1)
                          finalimage(i,j) = 0;
                      else
                          finalimage(i,j) = 255;
                      end
                 else
                    finalimage(i,j) = 0;
                 end
             end
         end
     end
     M = finalimage;
     imshow(finalimage,[]);
end


function delta = colordist(xt, vm)
xt2 = xt(1)^2 + xt(2)^2 + xt(3)^2;
vm2 = vm(1)^2 + vm(2)^2 + vm(3)^2;
xtvm2 = (xt(1)*vm(1) + xt(2)*vm(2) + xt(3)*vm(3))^2;
p2 = xtvm2 / vm2;
delta = sqrt(double(xt2-p2));
end

function val = brightness(xt,Imin, Imax, alpha, beta)
xt2rt = sqrt(double(xt(1)^2 + xt(2)^2 + xt(3)^2));
Ilow = alpha * Imax;

if ((beta*Imax) > (Imin/alpha))
    Ihigh = (Imin/alpha);
else
    Ihigh = (beta*Imax);
end
if Ilow <= xt2rt && Ihigh >= xt2rt
    val = 1;
else
    val = 0;
end
end