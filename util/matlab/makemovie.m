function makemovie(f0, df, f1, T0, dT, fps, filename, title, credit, ...
		   xstride, ystride, zstride, perspect, framedir);
% makemovie(f0, df, f1, T0, dT, fps, filename, title, credit,
% xstride, ystride, zstride, perspect, framedir);
%   make a 3D-box movie of velocity fields from output of movieframes.x
%   f0 : beginning frame number
%   df : frame increment
%   f1 : end frame number
%   T0 : beginning time (time of frame f0)
%   dT : time increment between frames
%   fps : frames per second (10 is decent)
%   filename : filename for movie
%   title    : a title to appear in the movie
%   credit   : credit to appear near bottom of screen
%   xstride  : x-granularity for quiver plots (defaults to 2)
%   ystride  : y-granularity for quiver plots (defaults to 2)
%   zstride  : z-granularity for quiver plots (defaults to 2)
%   perspect : 0 for orthographic, 1 for perspective plots
%   framedir : directory containing data for plotting frames
%   solilequy

if nargin <  1 ; f0 = 0; end
if nargin <  2 ; df = 1; end
if nargin <  3 ; f1 = 100; end
if nargin <  4 ; T0 = 0; end
if nargin <  5 ; dT = 1; end
if nargin <  6 ; fps = 10; end
if nargin <  7 ; filename = 'foo.avi'; end
if nargin <  8 ; title = ''; end
if nargin <  9 ; credit = ''; end
if nargin < 10 ; xstride = 2; end
if nargin < 11 ; ystride = 2; end
if nargin < 12 ; zstride = 2; end
if nargin < 13 ; perspect = 1; end
if nargin < 14 ; framedir = 'frames'; end


baseflow = 1;
quivscale = 0;

x = load(strcat(framedir, '/x.asc'));
y = load(strcat(framedir, '/y.asc'));
z = load(strcat(framedir, '/z.asc'));

savemovie=true;

set(gcf, 'renderer', 'opengl');
%set(gcf, 'renderer', 'zbuffer');

if (savemovie)
  aviobj = avifile(filename, 'fps', fps);
else
  clear avifile;
end

for f = f0:df:f1
  t = T0 + (f-f0)*dT;
  fs = num2str(f);
  ts = num2str(t,'%0.1f');

  us = strcat(framedir, '/u', fs);
  u_xy = load(strcat(us, '_u_xy.asc'));
  v_xy = load(strcat(us, '_v_xy.asc'));
  %w_xy = load(strcat(us, '_w_xy.asc'));
  u_yz = load(strcat(us, '_u_yz.asc'));
  v_yz = load(strcat(us, '_v_yz.asc'));
  w_yz = load(strcat(us, '_w_yz.asc'));
  u_xz = load(strcat(us, '_u_xz.asc'));
  %v_xz = load(strcat(us, '_v_xz.asc'));plotbo
  w_xz = load(strcat(us, '_w_xz.asc'));

  boxframe(x,y,z, u_yz, v_yz, w_yz, u_xy, v_xy, u_xz, w_xz,xstride,ystride,zstride, baseflow, quivscale,perspect);

  if length(title) > 0
    text(0,0,3*max(y), title, 'fontsize', 14); % for big box
    %text(0,0,2.6*max(y), title, 'fontsize', 14);
    %text(-.20,-.20,2.9*max(y), title, 'fontsize', 14);
  end;

  %text(-0,0,2.5*max(y), strcat('t = ', ts), 'fontsize',14); %for
  %big box
  text(-0,0,10*max(y), strcat('t = ', ts), 'fontsize',14); %for big box
  %text(0,0,2.3*max(y), strcat('t = ', ts), 'fontsize',14);
  %text(-.20,-.20,2.6*max(y), strcat('\theta = ', i2s(t/68 * 2*pi), 'fontsize',14);

  %if length(credit) > 0
    %text(0,0,-2.6*max(y), credit, 'fontsize', 12);
    %text(17.8,3.2,-0.5*max(y), credit, 'fontsize', 10);
    %text(17.8,3.2,-1.0*max(y), '         www.channelflow.org', 'fontsize', 10);
  %end;
  %text(17,4,-1.3*max(y), 'John Gibson', 'fontsize', 10);
  %text(17,4,-1.8*max(y), 'Georgia Tech', 'fontsize', 10);

  %fr = getframe(gcf);

  %text(1.2*max(z), 0.0*max(x),  0.5*max(y), ' Gibson, Halcrow, Cvitanovic', 'fontsize', 10);     % bigbox
  %text(1.2*max(z), 0.0*max(x),  0.0*max(y), 'Georgia Institute of Technology', 'fontsize', 10); %bigbox
  %text(1.2*max(z), 0.0*max(x), -0.7*max(y), 'Gibson, Halcrow, Cvitanovic', 'fontsize', 8);
  %text(1.2*max(z), 0.0*max(x), -0.9*max(y), 'Georgia Institute of Technology', 'fontsize', 8);
  %text(1.2*max(z), 0.0*max(x), -0.7*max(y), credit, 'fontsize', 8);
  %text(1.2*max(z), 0.0*max(x), -0.9*max(y), 'www.channelflow.org', 'fontsize', 8);

  %fr = gcf;
  camzoom(1.5)
  fr = getframe(gcf);
  aviobj = addframe(aviobj, fr);

  if (f == f0)
    print('-depsc', strcat('frame', num2str(f), '.eps'));
    print('-dpng',  strcat('frame', num2str(f), '.png'));
  end

  pause(0.1)
end

aviobj = close(aviobj);