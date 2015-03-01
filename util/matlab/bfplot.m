function h = bfplot(Phi,y);

h = cbfplot(Phi,y);

%uvbfplot(Phi,y);
%uwbfplot(Phi,y);
%plot(Phi(:,1),y,'b', Phi(:,2),y,'b--', ...
%     Phi(:,3),y,'r', Phi(:,4),y,'r--', ...
%     Phi(:,5),y,'g', Phi(:,6),y,'g--');
%plot(Phi(:,1),y,'ks', Phi(:,2),y,'kd', ...
%     Phi(:,3),y,'ko', Phi(:,4),y,'kx', ...
%     Phi(:,5),y,'k+', Phi(:,6),y,'k*');
%pmax = 1.1*max(max(abs(Phi)));
%if pmax==0
%  pmax = 1;
%end
%ax = [-pmax pmax min(y) max(y)];
%axis(ax);  bigfont;
