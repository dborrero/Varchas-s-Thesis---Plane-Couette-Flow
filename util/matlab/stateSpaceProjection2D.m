function stateSpaceProjection2D(e1,e2,varargin);
fprintf('%d\n',nargin);
fprintf('%s\n',varargin{1});
colors = { [34 139 34]/255,'m','c','r','g','b','k'};
for i = 1:(nargin-2)
	[tempe0,tempe1,tempe2,tempe3] = textread(varargin{i},'%f%f%f%f','headerlines',2);
	if(e1 == 0 && e2 == 1)
		scatter(tempe0,tempe1,10,colors{i},'filled');
	elseif(e1 == 0 && e2 == 2)
		scatter(tempe0,tempe2,10,colors{i},'filled');
	elseif(e1 == 0 && e2 == 3)
		scatter(tempe0,tempe3,10,colors{i},'filled');
	elseif(e1 == 1 && e2 == 2)
		scatter(tempe1,tempe2,10,colors{i},'filled');
	elseif(e1 == 1 && e2 == 3)
		scatter(tempe1,tempe3,10,colors{i},'filled');
	elseif(e1 == 2 && e2 == 3)	
		scatter(tempe2,tempe3,10,colors{i},'filled');
	else
		scatter(tempe0,tempe1,10,colors{i},'filled');
	end
	hold on;
end
hold off;