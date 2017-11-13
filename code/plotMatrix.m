try
    close all
    hfig = figure ('NumberTitle','off','name','Moshpit simulation','MenuBar','none');
    axis([0,SECTOR_SIZE*width,0,SECTOR_SIZE*height]);
    axis off %do not show the coordinator

while 1   
    for i = 1:matrix.length
        for j = 1:matrix(i).length
            disp('Position: ');
            disp([i, j]);
            list = matrix(i, j);
            itr = list.iterator();
            while itr.hasNext()
                individual = itr.next();
                if(individual(5)==1)
                    %erase mode, if the individual is participating, then
                    %we draw a red dot, otherwise it's black
                    head=line(x0,y0,'color','r','Marker','.','erasemode','xor','markersize',INDIVIDUAL_RADIUS);
                else
                    head=line(x0,y0,'color','k','Marker','.','erasemode','xor','markersize',INDIVIDUAL_RADIUS);
                end
            end
        end
    end
    drawnow;  %refresh the screen
end 
    
catch
return 
end
