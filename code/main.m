%% Project on Opinion Formation for the course
%% "Modelling and Simulating of Social Systems with MATLAB"
%% author: The Opinionators (Elisa Wall, Alexander Stein, Niklas Tidbury)


%% Creating the society

% A society of N SocietyAgents with opinions op in [0,1] 
% that are randomly normal distributed
N = 1000;
op = randn(N,1);

% number of time steps
T = 100;

% We want to guarantee that all opinions are in [0,1]
for i = 1:N
    while (op(i) > 1 || op(i)< -1)
        op(i) = rand;
    end
end

%% Properties of the SocietyAgents

% The threshold u defines when two agents speak with each other
u = 0.4;

% Mu defines the change of opinion when two agents speak with each other
% TASK: How should this function look like?
function mu = mu(op1, op2)  
mu = 0.2/(op1-op2);
end


%% Defining the influence of a single SocietyAgent during one timestep t
% Input: op0 = opinion of a single agent, op = opinion of the society, 
%       mu and u as described above
% Output: new opinion of op0 (opnew0), 
%       new opinion of a randomly chosen op1 (opnew1) that interacted with
%       op0 and the position of op1 (pos)
function [opnew0, opnew1, pos] = SingleAgent(op0, op, u)
% op0 meets a randomly chosen agent in the society op, called op1
pos = randi(N);
op1 = op(pos);
if abs(op1 - op0) < u
    opnew0 = op0 + mu(op0, op1);
    opnew1 = op1 + mu(op1, op0);
end
end

%% A world without extrimists
% We raise up the time steps to T
% In every time step t, every agent has the chance to speak with another
for t = 1:T
    for i = 1:N
        op0, op1, k = SingleAgent(op(i), op, u);
        op(i) = op0;
        op(k) = op1;
    end
end

%% Creating the extremists
%{
n = 10;      % number of extremists with opinion 0 and 1 splitted symmetrically and must be even therefore!
ex0 = 0;
nex0 = n/2;
ex1 = 1;
nex1 = n/2;

% Defining the properties of the extremists
p = 5;           % number of people the extremists can influence
kappa = 0.2;     % the probability "to get the opinion" for the extremist
%}
%% Now we raise up the time steps
%{
T = 100;    % number time steps
for t = 1:T
    % Every SocietyAgent is doing his job
  for i = 1:N
	  op0, op1, k = SingleAgent(op(i), op, u);
	  op(i) = op0;
	  op(k) = op1
  end
	% The extremists are also doing their job
	for i = 1:n/2
	  r = rand;
	  for j = 1:p           % fuck, p und anzahl agenten ist das selbe...
	    if r < k
	      op(k) = op1 	  % to be continue just a little bit
	    else
	      op(k) = op0
	    end
    end
  end
end

%}
