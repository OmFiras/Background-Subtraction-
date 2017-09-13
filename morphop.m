function morphop(M)
se = strel('rectangle',[2 2]);
F = imopen(M,se);
subplot(2,1,1);
imshow(F, []);
title('imopen 2*2 rectangle');
se = strel('rectangle',[4 4]);
F2 = imclose(F,se);
subplot(2,1,2);
imshow(F2, []);
title('imclose 4*4 rectangle');

end