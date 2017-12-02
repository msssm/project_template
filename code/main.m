%% Project on Opinion Formation for the course
%% "Modelling and Simulating of Social Systems with MATLAB"
%% author: The Opinionators (Elisa Wall, Alexander Stein, Niklas Tidbury)

% number of time steps
T = 50;

% number of society agents
N = 1000;

% Defining the properties of the society
u = 0.4;
mu = 0.1;

% Defining the properties of the extremists
n0 = 15;
p0 = 5;
kappa0 = 0.3;
n1 = 15;
p1 = 5;
kappa1 = 0.3;

with(T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1)
without(T, N, u, mu)

% The prgram without extremists as given in the paper
% Input: 
% Output: histograms
function without(T, N, u, mu)
%% Creating the society
% A society of N SocietyAgents with opinions op in [0,1] 
% that are randomly normal distributed
op = normrnd(0.5, 1, N, 1); %Elisa: Maybe also equal distri.

% We want to guarantee that all opinions are in [0,1]
for i = 1:N
    while (op(i) > 1 || op(i) < 0)
        op(i) = normrnd(0.5, 1);
    end
    disp(op(i));
end

%% Properties of the SocietyAgents

% The threshold u defines when two agents speak/interact with each other
% u = 0.4; given as an argument

% Mu defines the change of opinion when two agents speak with each other
% mu has to be between 0 and 1 to ensure that all opinions are also
% between 0 and 1
% mu = 0.1; given as an argument

%% A world without extrimists
% The influence of a single agent in a singlte timestep t is defined in the
% funtion SocietyAgent. We raise up the time steps to T. 
% In every time step t, every agent has the chance to speak with another.
timeGap = 0.01;

for t = 1:T
    for i = 1:N
        [op0, op1, k] = SingleAgent(op(i), op, u, N, mu);
        op(i) = op0;
        op(k) = op1;
    end
    edges = [0 0.1:0.1 0.2:0.2 0.3:0.3 0.4:0.4 0.475:0.475 0.525:0.525 0.6:0.6 0.7:0.7 0.8:0.8 0.9:0.9 1];
    nbin = 50;
    histogram(op, edges);
    pause(timeGap)
    drawnow;
end

end

% Input:
% Output: histograms
% The program with extremists
function [op] = with(T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1)
%% Creating the society

% A society of N SocietyAgents with opinions op in [0,1] 
% that are randomly normal distributed
% N = 1000; given as argument
op = normrnd(0.5, 1, N, 1); %Elisa: Maybe also equal distri.

% We want to guarantee that all opinions are in [0,1]
for i = 1:N
    while (op(i) > 1 || op(i) < 0)
        op(i) = normrnd(0.5, 1);
    end
    disp(op(i));
end

%% Properties of the SocietyAgents

% The threshold u defines when two agents speak/interact with each other
% u = 0.4; given as argument

% Mu defines the change of opinion when two agents speak with each other
% mu has to be between 0 and 1 to ensure that all opinions are also
% between 0 and 1
% mu = 0.1; given as argument

%% Creating the extremists with opinion 0

% number of extremists
% n0 = 15; given as an argument
% number of agents one extremist can reach
% p0 = 5; given as an argument
% All agents have the same behavior, so we can sum up the influence of all
%       agents in the number of people that get influenced
neff0 = p0 * n0;

% An extremist convinces an agent with probability kappa
% kappa0 = 0.3; given as an argument

%% Creating the extremists with opinion 0
% n1 = 15; given as an argument
% number of agents one extremist can reach
% p1 = 5; given as an argument
% All agents have the same behavior, so we can sum up the influence of all
%       agents in the number of people that get influenced
neff1 = p1 * n1;

% An extremist convince an agent with probability kappa
% kappa1 = 0.3; given as an argument

%%% We have the possibility to define n, p or kappa asymmetrically


%% A world with extremists
% Number of time steps T
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
        while op(k) < 0.4
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
        while op(k) > 0.6
            k = randi(N);
        end
        if r < kappa1
            op(k) = 1;
        end
    end
    
    edges = [0 0.1:0.1 0.2:0.2 0.3:0.3 0.4:0.4 0.475:0.475 0.525:0.525 0.6:0.6 0.7:0.7 0.8:0.8 0.9:0.9 1];
    nbin = 50;
    histogram(op, nbin);
    pause(timeGap)
    drawnow; 
    
end
end


% Defining the influence of a single SocietyAgent during one timestep t
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
