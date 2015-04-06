function plotboxh5(name, smag, ymax);
% function plotboxh5(name, smag);
% plot velocity field and swirling strength from HDF5 file uname and sname
if nargin < 2; smag = 0.2; end
if nargin < 3; ymax = 1.1; end

  %azel = [63.5, 36];
  azel = [52, 34];
  %azel = [0, 90];

  [z,x,y,u] = loadhdf5(name);
  
  clf()
  xmax = max(x);
  slice(z,x,y,u(:,:,:,1),[0], [0 1/2*xmax xmax], [-0.9],'linear') ; 
  set(findobj(gca,'Type','Surface'),'EdgeColor','none');

  %p = patch(isosurface(x,z,y,u(:,:,:,1), 0.5)) ; 
  %set(p, 'FaceColor', scolor, 'EdgeColor', 'none');

  % Show low/high-speed streaks
  %pl = patch(isosurface(z,x,y,u(:,:,:,1), -smag)) ; 
  %ph = patch(isosurface(z,x,y,u(:,:,:,1),  smag)) ; 
  %set(pl, 'FaceColor', [0.2 0.2 0.5], 'EdgeColor', 'none');
  %set(ph, 'FaceColor', [0.5 0.2 0.2], 'EdgeColor', 'none');

  % Show swirling strength
  [z,x,y,s] = loadhdf5(strcat('s', name));

  % zero out swirling for y > ymax
  if (ymax < 1) 
    nymax = 1 + floor((length(y)-1)/pi*acos(ymax)); % invert chebyshev dist. with 1-based index
    s(:,:,1:nymax) = zeros(size(s(:,:,1:nymax)));
  end

  %scolor  = [0 0.4 0];
  scolor_pos  = [0.3 0.5 0.3]; % green
  scolor_neg  = [0.6 0.3 0.3]; % red

  p = patch(isosurface(z,x,y,s, smag)) ; 
  set(p, 'FaceColor', scolor_pos, 'EdgeColor', 'none');

  p = patch(isosurface(z,x,y,s, -smag)) ; 
  set(p, 'FaceColor', scolor_neg, 'EdgeColor', 'none');

  camlight(60, 60)
  camlight(40, 40)
  lighting gouraud;

  text(0,0,3, name, 'fontsize',14);
  axis equal; view(azel); 
  axis off

