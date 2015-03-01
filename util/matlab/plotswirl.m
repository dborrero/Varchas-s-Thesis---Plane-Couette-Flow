function plotswirl(uname,sname);

azel = [63.5, 36];
azel = [52, 34];
scolor  = [0 min([1 0.4]) 0];

[z,x,y,u] = loadhdf5(uname);
  
clf()
slice(z,x,y,u(:,:,:,1),0,[0, 6.283],[-0.9],'linear') ; 
set(findobj(gca,'Type','Surface'),'EdgeColor','none');

p = patch(isosurface(z,x,y,s(:,:,:,1), 0.5)) ; 
set(p, 'FaceColor', scolor, 'EdgeColor', 'none');

[z,x,y,s] = loadhdf5(sname);
smag = max(max(max(s)));
sfactor = 0.8;


%p = patch(isosurface(z,x,y,s, 0.08)) ; 
set(p, 'FaceColor', scolor, 'EdgeColor', 'none');

camlight(60, 60)
camlight(40, 40)
lighting gouraud;

%text(0,0,3, strcat('t = ', n2s(n)), 'fontsize',14);
axis equal; view(azel); 
axis off
zoom(1.5)
