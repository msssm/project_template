%% Project on Opinion Formation for the course
%% "Modelling and Simulating of Social Systems with MATLAB"
%% author: The Opinionators (Elisa Wall, Alexander Stein, Niklas Tidbury)

%% number of time steps
T = 30;


%% number of iterations
Tg = 1;

%% number of society agents
N = 1000;

%% Properties of the SocietyAgents
% The threshold u defines when two agents speak/interact with each other
u = 0.32;


% Mu defines the change of opinion when two agents speak with each other
%       mu has to be between 0 and 1 to ensure that all opinions are 
%       opinions are between 0 and 1.
mu = 0.1;


%% Properties of the extremists
% number of extremists
n0 = 1;
n1 = 1;
% number of agents one extremist can reach
p0 = 30;
p1 = 30;
% An extremist convinces an agent with probability kappa
kappa0 = 0.2;
kappa1 = 0.2;
% an extremist has a range of people he reaches
%       The extremist with opinion 0 can reach all agents with opinion in 
%       [0,infop0], repectively extremists with opinion 1 to [infop1, 1] 
infop0 = 0.3;
infop1 = 0.7;


%% run the program

op = create(N);
gen_plot("hist", 2, run_simulation("with", op, Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1), "Opinion spread", "Opinion", "Number of Agents", T, N);
gen_plot("line", 1, run_simulation("with", op, Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1), "Percentages", "Time", "Percentage of Extreme", T, N);
gen_plot_interval("line", "Percentage over P", "p", "Percentage", "p", create(N), Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1);


%% Function for generating plots
% plot_type= plot type (hist or line)
% number_of_plots: number of data sets in plot
% data = data from simulation (call run_simulation())
% plot_name = name window of plot
% T = entire time (must be same T as passed to run_simulation())
% N = society size (must be same N as passed to run_simulation())
function [] = gen_plot(plot_type, number_of_plots, data, plot_name, x_axis, y_axis, T, N)
    figure('name', plot_name);
    disp("Running...");
    if plot_type == "hist"
        edges = linspace(0,1,200);
        if number_of_plots > 1
            for i = 1:number_of_plots
                histogram(data(round(i*T/number_of_plots),:), edges, 'DisplayName', ['T = ', num2str(round(i*T/number_of_plots))]);
                hold on;
            end
        else
            histogram(data(T,:), edges, 'DisplayName', ['T = ', num2str(T)]);
        end
        legend('show');
    elseif plot_type == "line"
        tot_perc = zeros(T);
        for i = 1:T
           tot_perc(i) = countPercentage(0,0.1,data(i,:),N);
           if tot_perc(i) == 100
               disp(["100% at T: ", num2str(i)]);
           end
        end
        plot(tot_perc);
    end
    title(plot_name);
    xlabel(x_axis);
    ylabel(y_axis);
    disp("Finished...");
end

%% Function for generating plots over interval of a certain var (can be customized)
% plot_type= plot type (hist or line)
% plot_name = name window of plot
% param = string name of variable to generate and plot over
% other vars same as usual
function [] = gen_plot_interval(plot_type, plot_name, x_axis, y_axis, param, op, Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1)
    figure('name', plot_name);
    disp("Running...");
    if param == "p"
        if plot_type == "line"
            perc_total = zeros(p0, 1);
            for j = 1:p0
                plot(perc_total);
                arr = run_simulation("with", op, Tg, T, N, u, mu, n0, j, kappa0, n1, j, kappa1, infop0, infop1);
                perc_total(j) = countPercentage(0, 0.1, arr(T,:), N);
                if perc_total(j) == 100
                    disp(["100% at p0: ", num2str(j)]);
                end
                pause(0.0001);
                drawnow;
            end
        end
    end
    title(plot_name);
    xlabel(x_axis);
    ylabel(y_axis);
    disp("Finished...");
end


function [data] = run_simulation(param, op, Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1)
    if param == "without"
        data = without(op, T, N, u, mu);
    elseif param == "with"
        data = with(op, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1);
    end
end



%% functions

%% Creating the society
% Input: number of extremists
% Output: (1xN) opinion matrix of an arbitrary random distribution 
%       (gaussian or uniform distribution)
function [op] = create(N)
%% Creating the society
% A society of N SocietyAgents with opinions op in [0,1] that are randomly 
%       distributed

% uniform distribution
op = rand(1,N);

% Normal distribution with mean=0.5 and sigma=1
%{
op = normrnd(0.5, 1, N, 1);

% We want to guarantee that all opinions are in [0,1]
for i = 1:N
    while (op(i) > 1 || op(i) < 0)
        op(i) = normrnd(0.5, 1);
    end
    %disp(op(i));
end
%}
end


%% The program without extremists as given in the paper
% Input: T, N, u, mu
% Output: updated opinion
function [simulation] = without(op, T, N, u, mu)


simulation = zeros(T, N);

%% A world without extrimists
% The influence of a single agent in a singlte timestep t is defined in the
%       funtion SocietyAgent. We raise up the time steps to T. In every 
%       time step t, every agent has the chance to speak with another.

    for t = 1:T
        for i = 1:N
            [op0, op1, k] = SingleAgent(op(i), op, u, N, mu);
            op(i) = op0;
            op(k) = op1;
        end
        simulation(t, :) = op;
    end
end

%% The program with extremists
% Input: T, N, mu, n0, n1, p0, p1, kappa0, kappa1, infop0, infop1
% Output: histograms
function [simulation] = with(op, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1)
simulation = zeros(T, N);

%% Effective number of influenced people by the extremists

% All agents have the same behavior, so we can sum up the influence of all
%       agents in the number of people that get influenced
neff0 = p0 * n0;
neff1 = p1 * n1;


%% A world with extremists

    for t = 1:T
        % For timestep t; the SocietyAgents play their game
        for i = 1:N
            [op0, op1, k] = SingleAgent(op(i), op, u, N, mu);
            op(i) = op0;
            op(k) = op1;
        end
        % For timestep t; the extremists with opinion 0 play their game
        for i = 1:neff0
            r = rand;
            k = randi(N);
            counter = 0;
            % extremists with opinion 0 only reach agents with similar opinion
            while op(k) > infop0 && counter < N
                k = randi(N);
                counter = counter + 1;
            end
            if r < kappa0
                op(k) = 0;
            end
        end
        % For timestep t; the extremists with opinion 1 play their game
        for i = 1:neff1
            r = rand;
            k = randi(N);
            % extremists with opinion 1 only reach agents with similar opinion
            while op(k) < infop1 && counter < N
                k = randi(N);
                counter = counter + 1;
            end
            if r < kappa1
                op(k) = 1;
            end
        end
        simulation(t, :) = op;
    end
end


%% Defining the influence of a single SocietyAgent during one timestep t
% Input: op0 = opinion of a single agent, op = opinion of the society,
%       mu, u and N as described above
% Output: new opinion of op0 (opnew0), 
%       new opinion of a randomly chosen op1 (opnew1) that interacted with
%       op0 and the position of op1 (pos)
function [opnew0, opnew1, pos] = SingleAgent(op0, op, u, N, mu)
% op0 meets a randomly chosen agent in the society op, called op1
    pos = randi(N);
    op1 = op(pos);
    if abs(op1 - op0) < u
        % weighted difference of opinions, weigh is given by mu
        opnew0 = op0 + mu*(op1-op0);
        opnew1 = op1 + mu*(op0-op1);
    else
        opnew0 = op0;
        opnew1 = op1;
    end
end

%% Calculate percentage of opinions in certain interval

function [perc] = countPercentage(lower, upper, op, N)
  counter = 0;
  for i = 1:N
       if (op(i) >= lower && op(i) <= upper) || (op(i) >= 1-upper && op(i) <= 1-lower)
           counter = counter + 1;
       end
  end
  perc = counter/N*100;
end
