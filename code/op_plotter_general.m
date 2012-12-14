%%%This is a simple a data-plotter of data generated by main_script.m

N_range = [100 200 300 400];    %Choose curves to be compared to each other
col=hsv(length(N_range));       %Creates as many colors as there are curves to be plotted
j=1;                            %Manually create integer counter for the Phi-loop
legcell=cell(1,length(N_range));%Create string cell for legend in graph

filelisting = dir(fullfile('Data', '*.mat'));   %Create list of .mat files in directory

for N2read = N_range            %Choose curves to be compared
    
    op_local = [];              %Initialize local op-vector
    phi_local = [];             %Initialize local phi-vector
    
    %This loop extracts the order parameter op from each data set and puts
    %it into op_local. It also extracts and builds phi correspondingly.

    for file_idx = 1:length(filelisting)    %Create index running up until the number of files in the directory
 
        load(['Data/' filelisting(file_idx).name]); %Load data of file at this index
        if N == N2read                              %If N is the N we are reading right now, add phi and op to local vectors
            phi_local = [phi_local phi];            %Concatenate current value of phi to previous ones.
            op_local = [op_local op];               %Concatenate current value of order parameter to previous ones.
        end
    end
    
    %%Plot curves into graph that is held open.
    a=0.4; b=0.8;                       %Tune a and b values rescaling the plot.
    plot(phi_local, (N2read^(a))*op_local, 'o','color',col(j,:)) %Plot in which the normal phi is plotted.
    plot(N2read^(b)*(phi_local-0.39)/0.39, (N2read^(a))*op_local, 'o','color',col(j,:)) %Plot in which the REDUCED phi is plotted. Here PHI_crit=0.32.
    legcell{j}=['N = ',num2str(N2read)];%Create cell for data range (e.g. N_range or k_range)
    j=j+1;                              %Manually increment loop counter. This is just for getting different colors in the plot.
    hold on;
end
hold off;   

%%Add labels and legend to graph
%xlabel('Reconnection probability \Phi');   
%ylabel('Order parameter S');
xlabel('Scaled reduced reconnection probability N^b \phi');    
ylabel('Scaled order parameter N^a S');
legend(legcell);
grid on;