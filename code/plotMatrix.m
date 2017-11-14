global matrix;
global INDIVIDUAL_RADIUS;
global SECTOR_SIZE;
global MATRIX_SIZE;

% try
    close all
    hfig = figure('NumberTitle','off','name','Moshpit simulation','MenuBar','none');
    axis([0, SECTOR_SIZE * MATRIX_SIZE, 0, SECTOR_SIZE * MATRIX_SIZE]);
    axis off %do not show the coordinator

% while 1   
    for i = 1:matrix.length
        for j = 1:matrix(i).length
            disp('Position: ');
            disp([i, j]);
            list = matrix(i, j);
            itr = list.iterator();
            while itr.hasNext()
                individual = itr.next();
                position = getPosition(individual);
                x0 = position(1);
                y0 = position(2);
                if(isParticipating(individual))
                    %erase mode, if the individual is participating, then
                    %we draw a red dot, otherwise it's black
                    head = line(x0, y0, 'color', 'r', 'Marker', '.', 'erasemode', 'xor', 'markersize', INDIVIDUAL_RADIUS * 10);
                else
                    head = line(x0, y0, 'color', 'k', 'Marker', '.', 'erasemode', 'xor', 'markersize', INDIVIDUAL_RADIUS * 10);
                end
            end
        end
    end
    drawnow;  %refresh the screen
% end 
    
% catch
% return 
% end
