function M = BackgroundSubtraction(N, alpha, beta,drs,epsi)
FileList=dir([drs '/PetsD2TeC1*.*']); 
currentfilename = FileList(1).name;
currentfilename = strcat(drs , '/', currentfilename);
im=imread(currentfilename);
%[row,column]= size(im);
row = 288;
column = 384;
for i = 1: N
     currentfilename = FileList(i).name;
     currentfilename = strcat(drs , '/', currentfilename);
     im=im2double(imread(currentfilename));
     MatNR(:, :, i) = im(:,:,1);
     MatNG(:, :, i) = im(:,:,2);
     MatNB(:, :, i) = im(:,:,3);

end
w = {};
cnt = 0;
for i = 1: 288
    for j = 1: 384
        CB = {};
        counter = 0;
        for t = 1: N
            R = MatNR(:,:,t); 
            G = MatNG(:,:,t); 
            B = MatNB(:,:,t); 
            xt = [R(i,j) G(i,j) B(i,j)];
            I = R(i,j)+ G(i,j)+ B(i,j);
            isMatch =0;
            L = 0;
            for k = 1: counter
                CWm = CB(k);
                CWM1 = CWm{1}{1};
                Vm = CWM1{1};
                CWM2 = CWm{1}{2};
                Auxm = CWM2{1};
                if (colordist(xt,Vm) < epsi && (brightness(xt,Auxm(1),Auxm(2), alpha, beta) == 1))
                    isMatch = 1;
                    L = counter;
                    break;
                end
            end
            if isempty(CB) || isMatch == 0
               V = [R(i,j), G(i,j), B(i,j)];
               Au = [I ,I, 1, t-1 ,t, t];
               CW = {{V},{Au}};
               counter = counter + 1;
               CB(counter) = {CW};
            else
                Vm = [ ((Auxm(3)*Vm(1)+ xt(1))/(Auxm(3)+1)), ((Auxm(3)*Vm(2)+ xt(2))/(Auxm(3)+1)),((Auxm(3)*Vm(3)+ xt(3))/(Auxm(3)+1))];
                Auxm = [ min([I Auxm(1)]), max([I Auxm(2)]), Auxm(3)+1, max([Auxm(4) t-Auxm(6)]), Auxm(5),t]; 
                CWm = {{Vm},{Auxm}};
                CB(L) = {CWm};
            end
        end
        for lk = 1: counter
                CWm = CB(lk);
                CWM1 = CWm{1}{1};
                Vm = CWM1{1};
                CWM2 = CWm{1}{2};
                Auxm = CWM2{1};
                lambda = max([Auxm(4) (N-Auxm(6)+Auxm(5)-1)]);
                Auxm(4)= lambda;
                CWm = {{Vm},{Auxm}};
                CB(lk) = {CWm};
        end
        cnt = cnt + 1;
        w(cnt)= {CB};
    end
end

M = w;
end




function delta = colordist(xt, vm)
xt2 = (xt(1)^2 + xt(2)^2 + xt(3)^2);
vm2 = (vm(1)^2 + vm(2)^2 + vm(3)^2);
xtvm2 = (xt(1)*vm(1) + xt(2)*vm(2) + xt(3)*vm(3))^2;
p2 = xtvm2 / vm2;
delta = sqrt(xt2-p2);

end

function val = brightness(xt,Imin, Imax, alpha, beta)
xt2rt = sqrt((xt(1)* xt(1))+ (xt(2)*xt(2)) + (xt(3)*xt(3)));

Ilow = alpha * Imax;

Ihigh = min([(Imin/alpha) (beta*Imax)]);

if (Ilow <= xt2rt && Ihigh >= xt2rt)
    val = 1;
else
    val = 0;
end
end