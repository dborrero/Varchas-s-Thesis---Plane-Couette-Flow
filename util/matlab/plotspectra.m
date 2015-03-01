function plotspectra(label, E, Lnormalized, printme);
% plotspectra(label, E, Lnormalized, printme);
%    E : noise floor = 10^E
%    Lnormalized: 0 graph vs kx,kz (default)
%                 1 graph vs 2pikx/Lx, 2pikz/Lz
%    printme : save nice eps files

if nargin < 1, label = ''; end
if nargin < 2, E = -8.1; end
if nargin < 3, Lnormalized = 0; end;
if nargin < 4, printme = 0; end

if length(label) > 0, label = strcat(label, '_'); end

xzspec = load(strcat(label, 'xzspec.asc'));
yspec = load(strcat(label, 'yspec.asc'));

x = load(strcat(label, 'x.asc'));
z = load(strcat(label, 'z.asc'));
Lx = max(x);
Lz = max(z);

flor = 10^E;

[Nx,Kz] = size(xzspec);
Nx 
kx = -Nx/2+1:1:Nx/2;
kx = Nx/2:-1:-Nx/2;
kz = 0:Kz-1;

alpha = 2*pi/Lx;
gamma = 2*pi/Lz;
%alpha = 1;
%gamma = 1;

%kx = -Nx/2+1:1:Nx/2;
%kx = Nx/2:-1:-Nx/2+1;
%kz = 0:Kz;

subplot(1,2,1);
if printme == 0
  subplot(1,2,1);
end

if Lnormalized
  imagesc(gamma*kz,alpha*kx,log10(xzspec+flor), [E, 0.1])
  xlabel('2\pi kz/Lz');
  ylabel('2\pi kx/Lx');
else
  imagesc(kz,kx,log10(xzspec+flor), [E, 0.1])
  xlabel('kz');
  ylabel('kx');
end

colorbar('SouthOutside');
axis xy;
axis tight
if printme == 0
  title('log_{10} fourier magn')
end

if printme ~= 0
  print(gcf, '-depsc', strcat(label, 'fourspec.eps'));
end

subplot(1,2,2);
if printme == 0
  subplot(1,2,2);
end
[M,N] = size(yspec);
yspec = yspec';

plot(log10(abs(yspec)), '.', 'MarkerSize', 10);

axis([-1 N E-2 1]);
xlabel('ky')
if printme == 0
  ylabel('log_{10} chebyshev magn')
end
hold off
%bigfont;

if printme ~= 0
  print(gcf, '-depsc', strcat(label, 'chebspec.eps'));
end
