function plotspectra(label, printme, E);
% plotspectra(label, printme, E);
%    E : noise floor = 10^E

if nargin < 1, label = ''; end
if nargin < 2, printme = 0; end
if nargin < 3, E = -8.1; end

if length(label) > 0, label = strcat(label, '_'); end

xzspec = load(strcat(label, 'xzspec.asc'));
yspec = load(strcat(label, 'yspec.asc'));

load x.asc;
load z.asc;
Lx = max(x);
Lz = max(z);

flor = 10^E;

[Nx,Kz] = size(xzspec);

kx = -Nx/2+1:1:Nx/2;
kx = Nx/2:-1:-Nx/2+1;
kz = 0:Kz-1;

alpha = 2*pi/Lx;
gamma = 2*pi/Lz;
%alpha = 1;
%gamma = 1;

%kx = -Nx/2+1:1:Nx/2;
%kx = Nx/2:-1:-Nx/2+1;
%kz = 0:Kz;

%subplot(1,2,2,'align');
%subplot(1,2,1, 'align');
subplot(1,2,1);
if printme == 0
  subplot(1,2,1);
end
imagesc(gamma*kz,alpha*kx,log10(xzspec+flor), [E, 0.1])
%imagesc(kz,kx,log10(xzspec.^2+flor), [E, 0.1])
axis tight
%axis equal
%contourf(kz,kx,log10(xzspec+flor))
%[C,h] = contourf(kz,kx,log10(xzspec+flor));
%set(h, 'LineStyle', 'none');
colorbar('SouthOutside');
axis xy;
%axis equal
axis tight
xlabel('2\pi kz/Lz');
ylabel('2\pi kx/Lx');
if printme == 0
  title('log_{10} fourier magn')
end
%bigfont;
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
%semilogy(yspec.^2, '.', 'MarkerSize', 10);
axis([-1 N E-2 1]);
%axis square
xlabel('ky')
if printme == 0
  ylabel('log_{10} chebyshev magn')
end
hold off
%bigfont;

if printme ~= 0
  print(gcf, '-depsc', strcat(label, 'chebspec.eps'));
end
