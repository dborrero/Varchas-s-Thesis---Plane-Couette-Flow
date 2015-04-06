function stateSpaceProjection3D(e1,e2,e3,varargin);
fprintf('%d\n',nargin);
fprintf('%s\n',varargin{1});
colors = { [34 139 34]/255,'m','c','r','g','b','k',[134 139 34]/255,[34 139 134]/255};
markersize = 5;
for i = 1:(nargin-3)
	[tempe0,tempe1,tempe2,tempe3] = textread(varargin{i},'%f%f%f%f','headerlines',2);
	if length(tempe0) == 1
		markersize = 50;
	end
	fprintf('%d,%d\n',markersize,length(tempe0));
	if(e1 == 0 && e2 == 1 && e3 == 2)
		scatter3(tempe0,tempe1,tempe2,markersize,colors{i},'filled');
	elseif(e1 == 0 && e2 == 1 && e3 == 3)
		scatter3(tempe0,tempe1,tempe3,markersize,colors{i},'filled');
	elseif(e1 == 0 && e2 == 2 && e3 == 3)
		scatter3(tempe0,tempe2,tempe3,markersize,colors{i},'filled');
	elseif(e1 == 1 && e2 == 2 && e3 == 3)
		scatter3(tempe1,tempe2,tempe3,markersize,colors{i},'filled');
	else
		scatter3(tempe0,tempe1,tempe3,markersize,colors{i},'filled');
	end
	markersize = 5;
	hold on;
end
hold off;