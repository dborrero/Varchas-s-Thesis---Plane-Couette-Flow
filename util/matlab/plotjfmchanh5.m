function plotjfmchanh5(name, smag, uneg, upos, zmax, color,contours);
% function plotjfmchanh5(name, smag, uneg, upos, zmax, color,contours);


% plot high/lo speed streaks and swirling strength from HDF5 file uname and sname

if nargin < 2; smag = 0.2; end
if nargin < 3; uneg = 0.5; end
if nargin < 4; upos = -uneg; end
if nargin < 5; zmax = 0; end
if nargin < 6; color = 1; end
if nargin < 7; contours = 0; end



  %azel = [63.5, 36];
  azel = [52, 34];
  %azel = [0, 90];

  %clf()
  yscale = 1;
  xscale = 1;
  ymax = 1*yscale;
  [z,x,y,u] = loadhdf5(strcat('u', name));
  x = x - max(x)/2;
  z = z - max(z)/2;
  x = x/xscale;

  %
  su = smooth3(u(:,:,:,1));

  xmax = max(x);
  xmin = min(x);
  %contourslice(z,x,y,su(:,:,:),[], [0 xmax/2 xmax], [], [-.15 -0.05 0.05 0.15]) ;   
  %contourslice(z,x,y,su(:,:,:),[], [0 xmax/2 xmax], []);
  %slice(z,x,y,u(:,:,:,1),[], [0 xmax/2 xmax], [],'nearest') ; 
  %slice(z,x,y,u(:,:,:,1),[0], [xmax], [-0.8],'nearest') ; 
  %slice(z,x,y,u(:,:,:,1),[0], [0 1/2*xmax xmax], [-0.9],'linear') ; 
  %set(findobj(gca,'Type','Surface'),'FaceColor','interp','EdgeColor','none');

  %p = patch(isosurface(x,z,y,u(:,:,:,1), 0.5)) ; 
  %set(p, 'FaceColor', scolor, 'EdgeColor', 'none');

  %color = 0;
  if color
    scolor_neg = 0.9*[0.5 0.5 0.9];  % blue
    scolor_pos = 1.1*[0.9 0.5 0.5];  % red
    ucolor_pos = [0.8 0.8 0.3]; % yellow
    ucolor_neg = [0.4 0.6 0.4]; % green

    scolor_neg = [0.3 0.3 0.7];     % dark blue    1.30 total
    scolor_pos = [0.5 0.8 0.5];     % light  green 1.70 1 total
    ucolor_pos = [1   1   0.3];     % light yellow 1.9 total
    ucolor_neg = [1   0.6 0.6];     % light red    2.1 total

    ucolor_pos = [1   1   0.3];     % light yellow 1.9 total
    ucolor_neg = [1   0.6 0.6];     % light red    2.1 total
  else
    ucolor_neg = 0.3*[1 1 1]; 
    ucolor_pos = 0.3*[1 1 1]; 
    scolor_neg = 0.65*[1 1 1]; 
    %scolor_pos = 0.95*[1 1 1]; 
    scolor_pos = 0.87*[1 1 1]; 
  end

  % good for channel flow solutions
  scontours =  0.02*[1 3 5 7 9];        
  ucontours =  0.03*[1 3 5 7 9];    
  ucontours =  0.03*[1:2:15];    

  % good for plane couette solutions
  %scontours =  0.04*[1 3 5 7];    
  %ucontours =  0.03*[1 3 5 7 9];
  %'PLANE COUETTE CONTOUR LEVELS'
  
  % zero out streaks for y > ymax
  %if (ymax < yscale) 
  %  nymax = 1 + floor((length(y)-1)/pi*acos(ymax)); % invert chebyshev dist. with 1-based index
 %   u(:,:,1:nymax) = zeros(size(u(:,:,1:nymax)));
  %end

  % Show low/high-speed streaks
  pl = patch(isosurface(z,x,y*yscale,u(:,:,:,1), upos)) ; 
  set(pl, 'FaceColor', ucolor_neg, 'EdgeColor', 'none');
  isonormals(z,x,y,su,pl);

  ph = patch(isosurface(z,x,y*yscale,u(:,:,:,1),  uneg)) ; 
  set(ph, 'FaceColor', ucolor_pos, 'EdgeColor', 'none');
  isonormals(z,x,y,su,ph);

  if 1 % u contours in backplane 
    pup = contourslice(z,x,y*yscale,su(:,:,:),[], [xmax], [],  ucontours) ;   
    pun = contourslice(z,x,y*yscale,su(:,:,:),[], [xmax], [], -ucontours) ;   
    set(pup, 'LineStyle', '-');
    set(pun, 'LineStyle', '--');
  end	     

  if 0
    ylevel = -0.7; 
    ucontours = 0.03*[1:2:20];
    %pup = contourslice(z,x,y*yscale,su(:,:,:),[], [], [ylevel],  ucontours) ;   
    %pun = contourslice(z,x,y*yscale,su(:,:,:),[], [], [ylevel],  -ucontours) ;   
    pup = slice(z,x,y*yscale,su(:,:,:),[], [], [ylevel]) ;   
    pun = slice(z,x,y*yscale,su(:,:,:),[], [], [ylevel]) ;   
    %set(pup, 'LineStyle', '');
    %set(pun, 'LineStyle', '');
  end	     

  % Show swirling strength
  [z,x,y,s] = loadhdf5(strcat('s', name));
  x = x - max(x)/2;
  z = z - max(z)/2;
  x = x/xscale;

  % zero out swirling for y > ymax
  %if (ymax < 1) 
  %  nymax = 1 + floor((length(y)-1)/pi*acos(ymax)); % invert chebyshev dist. with 1-based index
  %  s(:,:,1:nymax) = zeros(size(s(:,:,1:nymax)));
  %end

  s = smooth3(s);

  hold on
  p = patch(isosurface(z,x,y*yscale,s, smag)) ; 
  set(p, 'FaceColor', scolor_pos, 'EdgeColor', 'none');
  isonormals(z,x,y,s,p);

  p = patch(isosurface(z,x,y*yscale,s, -smag)) ; 
  set(p, 'FaceColor', scolor_neg, 'EdgeColor', 'none');
  isonormals(z,x,y,s,p);

  if 0 % swirling contours
    psn = contourslice(z,x,y*yscale,s(:,:,:),[], [xmin], [], -scontours) ;   
    psp = contourslice(z,x,y*yscale,s(:,:,:),[], [xmin], [],  scontours) ;   
    set(psp, 'LineStyle', '-');
    set(psn, 'LineStyle', '--');
  else     
    psn = contourslice(z,x,y*yscale,s(:,:,:),[], [xmin], [], 100*scontours) ;   
    set(psn, 'LineStyle', '--');
  end

  if 0 % plot windowing function in front plane
    z2 = linspace(min(z), max(z), 200);
    W = zeros(length(x), length(z2), length(y));
    a = 0.3; % 1copy guess params
    b = 1;

    a = 1; % 2copy guess params
    b = 1;

    c = 6/b;
    d = -(3 + 6*a/b);
    for nz=1:length(z2) 
      zp = z2(nz);
      
      for ny=1:length(y)
         for nx=1:length(x) 
             W(nx,nz,ny) =  0.25*(1-tanh(c*zp+d))*(1-tanh(-c*zp+d)) - y(ny);

	     %if abs(z2(nz)) < a
             %  W(nx,nz,ny) = 0.99 - y(ny);
            % else
            %   zp = abs(z2(nz)) - a;
            %   W(nx,nz,ny) = exp(-(zp/b)^2) - y(ny);
            % end
         end
      end
    end

    size(W)
    Ws = contourslice(z2,x,y*yscale,W(:,:,:),[], [xmin], [], [0 0.00001]) ;   
    set(Ws, 'LineWidth', 2);

  end

  if 0 % plot z=0 plane
    Lx = pi;
    Lz = zmax;
    plot3([0 0], [ Lx  Lx], [-1  1], 'k'); 
    plot3([0 0], [-Lx -Lx], [-1  1], 'k'); 
    plot3([0 0], [-Lx  Lx], [-1 -1], 'k'); 
    plot3([0 0], [-Lx  Lx], [ 1  1], 'k'); 
  end    

  if 0 
    Lx = pi;
    Lz = max(z);
    % z x y axis labels
    text(1.0*Lz, -Lx,  0.05,    '- 0', 'fontsize', 30)
    text(1.0*Lz, -Lx,  1.05,    '- 1', 'fontsize', 30)
    text( 0.65*Lz, -Lx,  0.25,  'W(z)', 'fontsize', 30)
    text(-0.05,     -Lx, -1.4,  'z', 'fontsize', 30)
    text(-0.97*Lz,  Lx,  -0.03, 'y', 'fontsize', 30)
    text(-1.1*Lz,    0,  1.0,   'x', 'fontsize', 30)
  end



  %camlight(60, 60)
  %camlight(40, 40)
  %camlight(0, 80)
  camlight headlight
  %lighting gouraud;
  lighting phong;
  material dull

  %plotboxframe(max(x), 6)
  if zmax == 0
    zmax = max(z);
  end
  %plotboxframe(max(x), zmax)

  %max(x)
  %max(z)
  %min(x)
  %min(z)
  %plotboxframe(max(x), zmax,1)
  plotboxframe(20.1, 10.2,1)
  %plotboxframe(20, 10,1)
  %plotboxframe(60, 30,1)
  %plotboxframe(20, 8,1)
  %plotboxframe(15, 8,1)
  %plotaxes(min(x),-1,-4, 1 )
  %plotaxes(min(x),-1,-2.5, 1 )
  %plotaxes(min(x),-1,-1.5, 1 )
  %plotaxes(0,0,0, 1 )
  
  %  text(0,0,3, name, 'fontsize',14);
  axis equal; view(azel); 
  axis off

  %camlight left

  set(gcf, 'PaperUnits', 'inches');
  %set(gcf, 'PaperPosition', [0 0 8 4.3]); % hairpin.tex setting
  %set(gcf, 'PaperPosition', [0 0 9 4]);
  set(gcf, 'PaperPosition', [0 0 3 1.61]); 
  set(gca, 'Units', 'normalized', 'Position', [0.0 0.0 1 1])


