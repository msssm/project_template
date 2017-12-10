%% Project on Opinion Formation for the course
%% "Modelling and Simulating of Social Systems with MATLAB"
%% author: The Opinionators (Elisa Wall, Alexander Stein, Niklas Tidbury)

%% number of time steps
T = 10;

%% number of iterations
Tg = 20;

%% number of society agents
N = 10000;

%% Properties of the SocietyAgents
% The threshold u defines when two agents speak/interact with each other
u = 0.4;

% Mu defines the change of opinion when two agents speak with each other
%       mu has to be between 0 and 1 to ensure that all opinions are 
%       opinions are between 0 and 1.
mu = 0.3;

%% Properties of the extremists
% number of extremists
n0 = 10;
n1 = 10;
% number of agents one extremit can reach
p0 = 4;
p1 = 4;
% An extremist convinces an agent with probability kappa
kappa0 = 0.1;
kappa1 = 0.1;
% an extremist has a range of people he reaches
%       The extremist with opinion 0 can reach all agents with opinion in 
%       [0,infop0], repectively extremists with opinion 0 to [infop1, 1] 
infop0 = 0.1;
infop1 = 0.9;

%% run_functions of the program
run_function("with_heat", T, Tg, N, u, mu, n0, n1, p0, p1, kappa0, kappa1, infop0, infop1)

function [] = run_function(option, T, Tg, N, u, mu, n0, n1, p0, p1, kappa0, kappa1, infop0, infop1)
 if option=="with_heat"
     run_with(T, Tg, N, u, mu, n0, n1, p0, p1, kappa0, kappa1, infop0, infop1)
 elseif option=="with_histo"
     run_without(T, Tg, N, u, mu, n0, n1, p0, p1, kappa0, kappa1, infop0, infop1)
 else disp("No valid option...")
 end

end

% Alternatve 1) Without iteration
function [] = run_without()
end

%% Alternative 2) With iteration
function [] = run_with(T, Tg, N, u, mu, n0, n1, p0, p1, kappa0, kappa1, infop0, infop1)

% prepare result matrices
res_with = zeros([Tg, N]);
res_without = zeros([Tg, N]);

% iterate through
disp("Running...");
for k = 1:Tg
    % allocate result vectors to array
    res_without(k,:) = without(T, N, u, mu);
    res_with(k,:) = with(T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1);
    perc = k*(100/Tg);
    disp([num2str(perc),'%']);
end

% calculate average over matrix columns
average_without = mean(res_without);
average_with = mean(res_with);
average_without_matrix = vec2mat(sort(average_without, 'descend'), sqrt(N));
average_with_matrix = vec2mat(sort(average_with, 'descend'), sqrt(N));

% plot settings
edges = linspace (0,1,50);
clims = [0 1];
colormap('hot');

% plot averages as histogram and as heat map
figure('name', 'Hist: Mean average without Extremists');
histogram(average_without, edges);
figure('name', 'Hist: Mean average with Extremists');
histogram(average_with, edges);
figure('name', 'Heat: Mean average without Extremists');
imagesc(average_without_matrix, clims);
colorbar;
figure('name', 'Heat: Mean average with Extremists');
imagesc(average_with_matrix, clims);
colorbar;
end



%% functions

%% Creating the society
% Input: number of extremists
% Output: (1xN) opinion matrix of an arbitrary random distribution 
%       (gaussian or uniform distribution)
function [op] = create(N)
%% Creating the society
% A society of N SocietyAgents with opinions op in [0,1] that are randomly 
%       normal distributed (with mean=0.5 and sigma=1)
op = normrnd(0.5, 1, N, 1);

% We want to guarantee that all opinions are in [0,1]
for i = 1:N
    while (op(i) > 1 || op(i) < 0)
        op(i) = normrnd(0.5, 1);
    end
    %disp(op(i));
end

% Alternatively one can start with a uniform distribution
% op = rand(1,N)

end


%% The prgram without extremists as given in the paper
% Input: T, N, u, mu
% Output: updated opinion
function [op] = without(T, N, u, mu)
%%Creating the society
op = create(N);

%% A world without extrimists
% The influence of a single agent in a singlte timestep t is defined in the
%       funtion SocietyAgent. We raise up the time steps to T. In every 
%       time step t, every agent has the chance to speak with another.
timeGap = 0.01;

for t = 1:T
    for i = 1:N
        [op0, op1, k] = SingleAgent(op(i), op, u, N, mu);
        op(i) = op0;
        op(k) = op1;
    end
    
    %use = vec2mat(op, sqrt(N));
    %colormap('hot');
    %imagesc(use);
    %colorbar;
    %edges = linspace (0,1,50);
    %histogram(op, edges);
    %pause(timeGap);
    %drawnow;
end

end

%% The program with extremists
% Input: T, N, mu, n0, n1, p0, p1, kappa0, kappa1, infop0, infop1
% Output: histograms
function [op] = with(T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1)
%% Creating the society
op = create(N);

%% Effective number of influenced people by the extremists

% All agents have the same behavior, so we can sum up the influence of all
%       agents in the number of people that get influenced
neff0 = p0 * n0;
neff1 = p1 * n1;


%% A world with extremists
timeGap = 0.01;

for t = 1:T
    % For timestep t; the SoicietyAgents play their game
    for i = 1:N
        [op0, op1, k] = SingleAgent(op(i), op, u, N, mu);
        op(i) = op0;
        op(k) = op1;
    end
    % For timestep t; the extremists with opinion 0 play their game
    for i = 1:neff0
        r = rand;
        k = randi(N);
        % extremists with opinion 0 only reach agents with similar opinion
        while op(k) < infop0
            k = randi(N);
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
        while op(k) > infop1
            k = randi(N);
        end
        if r < kappa1
            op(k) = 1;
        end
    end
    
    %use = vec2mat(op, sqrt(N));
    %colormap('hot');
    %imagesc(use);
    %colorbar;
    %edges = linspace (0,1,50);
    %histogram(op, edges);
    %pause(timeGap);
    %drawnow;
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
