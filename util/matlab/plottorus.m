function faces = plottorus(torus,nx,nz)

faces = zeros((nx-1)*(nz-1),4);
idx = 1;
for x = 1:(nx-1)
    for z = 1:(nz-1)
        i0 = (x-1)*nz + z;
        i1 = i0 + nz;
        faces(idx,:) = [i0, i0+1, i1+1, i1];
        idx = idx+1;
%        p = [torus(i0,:);torus(i0+1,:);torus(i1 + 1,:);torus(i1,:)];
%        patch(p(:,1),p(:,2),p(:,3),'k','FaceAlpha',0.2);
    end
end
patch('Vertices',torus,'Faces',faces,'FaceAlpha',0.2)
        