%% Project on Opinion Formation for the course
%% "Modelling and Simulating of Social Systems with MATLAB"
%% author: The Opinionators (Elisa Wall, Alexander Stein, Niklas Tidbury)

%% number of time steps
T = 30;

%% number of iterations
Tg = 20;

%% number of society agents
N = 1089;

%% Properties of the SocietyAgents
% The threshold u defines when two agents speak/interact with each other
u = 0.3;

% Mu defines the change of opinion when two agents speak with each other
%       mu has to be between 0 and 1 to ensure that all opinions are 
%       opinions are between 0 and 1.
mu = 0.3;

%% Properties of the extremists
% number of extremists
n0 = 10;
n1 = 10;
% number of agents one extremist can reach
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


%% run the program

%run_multi("with", Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1);
%run_multi("without", Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1);
%run_single("with", Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1);
run_single("without", Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1);

function [] = run_single(param, Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1)
    disp("Running...");
    edges = linspace(0,1,200);
    if param == "without"
        figure('name', 'SingleHist: Mean average without Extremists');
        histogram(without(T, N, u, mu), edges);
        xlabel('Distribution of Opinions x');
        ylabel('Amount Counted N');
        titlename = ['Single Hist with T = ' num2str(T) ' and \mu = ' num2str(mu)]
        title(titlename)
        filename = ['SingleWithout_N' num2str(N) '_T' num2str(T) '_mu' num2str(mu) '_u' num2str(u) '.fig']
        savefig(filename)
    elseif param == "with"
        figure('name', 'SingleHist: Mean average with Extremists');
        histogram(with(T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1), edges);
        xlabel('Distribution of Opinions x');
        ylabel('Amount Counted N');
    end
    disp("Finished!");
end

function [] = run_multi(param, Tg, T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1)
    disp("Running...");
    edges = linspace(0,1,200);
    if param == "without"
        res_without = zeros([Tg, N]);
        for k = 1:Tg
            % allocate result vectors to array
            res_without(k,:) = without(T, N, u, mu);
            perc = k*(100/Tg);
            disp([num2str(perc),'%']);
        end
        average_without = mean(res_without);
        figure('name', 'MultiHist: Mean average without Extremists');
        histogram(average_without, edges);
        xlabel('Distribution of Opinions x');
        ylabel('Amount Counted N');
    elseif param == "with"
        res_with = zeros([Tg, N]);
        for k = 1:Tg
            % allocate result vectors to array
            res_with(k,:) = with(T, N, u, mu, n0, p0, kappa0, n1, p1, kappa1, infop0, infop1);
            perc = k*(100/Tg);
            disp([num2str(perc),'%']);
        end
        average_with = mean(res_with);
        figure('name', 'MultiHist: Mean average with Extremists');
        histogram(average_with, edges);
        xlabel('Distribution of Opinions x');
        ylabel('Amount Counted N');
    end
    disp("Finished!");
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
