%% Project on Opinion Formation for the course
%% "Modelling and Simulating of Social Systems with MATLAB"
%% author: The Opinionators (Elisa Wall, Alexander Stein, Niklas Tidbury)


%% Creating the society

% A society of N SocietyAgents with opinions op in [0,1] 
% that are randomly normal distributed
N = 1000;
op = randn(N,1); %Elisa: Maybe also equal distri.

% We want to guarantee that all opinions are in [0,1]
for i = 1:N
    while (op(i) > 1 || op(i)< -1)
        op(i) = rand;
    end
end

%% Properties of the SocietyAgents

% The threshold u defines when two agents speak/interact with each other
u = 0.4;

% Mu defines the change of opinion when two agents speak with each other
%       --> see function mu

%% A world without extrimists
%{
% The influence of a single agent in a singlte timestep t is defined in the
% funtion SocietyAgent. We raise up the time steps to T. 
% In every time step t, every agent has the chance to speak with another.

% Number of time steps T
T = 100;

for t = 1:T
    for i = 1:N
        [op0, op1, k] = SingleAgent(op(i), op, u, mu, N);
        op(i) = op0;
        op(k) = op1;
    end
end
%}

%% Creating the extremists with opinion 0
% number of extremists
n0 = 15;
ex0 = 0;
% number of agents one extremists can reach
p0 = 5;
% All agents have the same behavior, so we can sum up the influence of all
%       agents in the number of people that get influenced
neff0 = p0 * n0;

% An extremist convinces an agent with probability kappa
kappa0 = 0.2;

%% Creating the extremists with opinion 0
n1 = 15;
% Opinion of the extremists: Since they have all the same opinion, we do
%       not need an array.
ex1 = 1;
% number of agents one extremists can reach
p1 = 5;
% All agents have the same behavior, so we can sum up the influence of all
%       agents in the number of people that get influenced
neff1 = p1 * n1;

% An extremist convince an agent with probability kappa
kappa1 = 0.2;

%%% We have the possibility to define n, p or kappa asymmetrically


%% A world with extremists
% Number of time steps T
T = 100;

for t = 1:T
    % For timestep t; the SoicietyAgents play their game
    for i = 1:N
        [op0, op1, k] = SingleAgent(op(i), op, u, mu, N);
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
end

%%functions

%%% TASK: How should this function look like?
%%%         In the paper they give a reference: Look up there!
function mu = mu(op1, op2)
mu = 0.2/(op1-op2);
end

%% Defining the influence of a single SocietyAgent during one timestep t
% Input: op0 = opinion of a single agent, op = opinion of the society,
%       mu and u as described above
% Output: new opinion of op0 (opnew0), 
%       new opinion of a randomly chosen op1 (opnew1) that interacted with
%       op0 and the position of op1 (pos)
function [opnew0, opnew1, pos] = SingleAgent(op0, op, u, N)
% op0 meets a randomly chosen agent in the society op, called op1
pos = randi(N);
op1 = op(pos);
if abs(op1 - op0) < u
    opnew0 = op0 + mu(op0, op1);
    opnew1 = op1 + mu(op1, op0);
end
end
