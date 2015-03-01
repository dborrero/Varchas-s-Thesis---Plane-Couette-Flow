function makemovieh5(t0, t1, smag, ymax, azel)
% function makemovieh5(t0, t1, smag, [az el])

if nargin < 5; azel = [80, 30]; end
if nargin < 4; ymax = 0.0; end
if nargin < 3; smag = 0.2; end

%azel = [63.5, 36];
%azel = [52, 34];
%azel = [0, 90];
%azel = [80, 30];

scolor  = [0.6 0.3 0.3]; % red

for n = t0:1:t1
  n
  uname = strcat('u',n2s(n),'.h5');
  sname = strcat('s',n2s(n),'.h5');
  fname = strcat('f',n2s(1000+n),'.png');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % u velocity plot

  [z,x,y,u] = loadhdf5(uname);
  
  clf()
  slice(z,x,y,u(:,:,:,1),[0],[0 max(x)],[-0.95],'linear') ; 
  set(findobj(gca,'Type','Surface'),'EdgeColor','none');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % swirling strength plot

  [z,x,y,s] = loadhdf5(sname);

  % zero out swirling for y > ymax
  if (ymax < 1) 
    nymax = 1 + floor((length(y)-1)/pi*acos(ymax)); % invert chebyshev dist. with 1-based index
    s(:,:,1:nymax) = zeros(size(s(:,:,1:nymax)));
  end

  p = patch(isosurface(z,x,y,s, smag)) ; 
  set(p, 'FaceColor', scolor, 'EdgeColor', 'none');

  camlight(60, 60)
  camlight(40, 40)
  lighting gouraud;
  
  text(0,0,3, strcat('t = ', n2s(n)), 'fontsize',14);
  axis equal; view(azel); 
  axis off
  %  zoom(1.5)
  print('-dpng',fname);
end