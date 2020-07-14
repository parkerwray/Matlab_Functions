function fancy2Dplot(data,x,y)
    
    [Y,X] = meshgrid(y,x);
    contourf(X, Y, data, 200,'edgecolor','none' )

   xlim([600,850])






%data = fliplr(data'); %Unsure if flipLR works for sweep thickness
    %data = data.';
%     imagesc(data);
    %title({strcat(FileName(10:end-4)),'SL Angle for Peak Off-Axis Scattering'},'Interpreter','none');
    %xlabel('Wavelength (nm)');
    %ylabel('Core Radius (nm)');'

%     yticks = linspace(1, size(data, 1), numel(y));
%     set(gca, 'YTick', yticks, 'YTickLabel',y, 'Ydir','normal');
%     xticks = linspace(1, size(data, 2), numel(x));
%     set(gca, 'XTick', xticks, 'XTickLabel', x);
%     %grid on
%     colorbar  
    
%     data = permute(data,[2,1]);
%     imagesc(data)
%     yticks = linspace(1, size(data, 1), numel(y));
%     set(gca, 'YTick', yticks, 'YTickLabel',y, 'Ydir','normal');
%     xticks = linspace(1, size(data, 2), numel(x));
%     set(gca, 'XTick', xticks, 'XTickLabel', x);
%     %grid on
%     colorbar  
%     
    
    
    
    
    
    
    
end




















