%first try of our opinion formation program in MATLAB
%author: Alexander

% Creating the society

% N opinions in [0,1] randomly (gaussian) distributed opinions
N = 1000;
op = randn(N,1);

% Defining the properties of the society
function mu = muf(op1, op2)           % how much should the opinion change?
mu = 0.2/(op1-op2)                    % this is only taken as example and need to be changed later
end

u = 0.4;						% threshold: when should the opinion change

% Defining the influence of a single SocietyAgent during one timestep t
% Input: op0 - one single agent, op - the society, mu and u as described above
% Output: change of opinions of op0 and a randomly chosen op1 from the society op
function [op0,op1, pos_op1] = SingleAgentf(op0, op, u)
% op0 meets a random guy in op, called op1
k = randi([0,N], 0, N-1);
op1 = op[k];
if abs(op1-op0) < u
  op0 += mu(op0, op1);
  op1 += mu(op1, op0)
end
end

% Creating the extremists
n = 10;      % number of extremists with opinion 0 and 1 splitted symmetrically and must be even therefore!
ex0 = 0;
nex0 = n/2;
ex1 = 1;
nex1 = n/2;

% Defining the properties of the extremists
p = 5;           % number of people the extremists can influence
kappa = 0.2;     % the probability "to get the opinion" for the extremist

% Now we raise up the time steps
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
	  r = random.rand();
	  for j = 1:p           % fuck, p und anzahl agenten ist das selbe...
	    if r < k
	      op(k) = ex1 or ex0  % to be continue just a little bit
	    end
    end
  end
end
  
%gagaga, sollen wir schon wieder diskreten random benutzen für    das "or"? bisschen effizienter wäre vielleicht das if aufzuteilen in r in [0, k/2] und [k/2, k]
