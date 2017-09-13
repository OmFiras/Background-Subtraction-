function novel = temporalFiltering(w, N)
novel = {};
for i = 1: 288*384
    CB = w(i);
    counter = 0;
    NCB = {};
    for j = 1: size(CB)
    CWm = CB(j);
    CWm1 = CWm{1}{1};
    Vm = CWm1{1}{1};
    Auxm = CWm1{2}{1};
    if(Auxm(4) <= N/2)
        counter = counter+1;
        CW = {{Vm},{Auxm}};
        NCB(counter) = {CW};
    end
    end
    novel(i) = {NCB};
end
