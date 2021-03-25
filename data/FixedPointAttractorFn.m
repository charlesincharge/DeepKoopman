function X = FixedPointAttractorFn(x1range, x2range, numICs, tSpan, mu, lambda, seed)

% Fixed-point attractor example from https://arxiv.org/pdf/1710.04340.pdf
% x1(t+1) = lambda * x1(t)
% x2(t+1) = mu * x2(t) + (lambda^2 - mu) & x1(t)^2

% try some initial conditions for x1, x2
rng(seed)

% randomly start from x1range(1) to x1range(2)
x1 = (x1range(2)-x1range(1))*rand([numICs,1])+x1range(1);

% randomly start from x2range(1) to x2range(2)
x2 = (x2range(2)-x2range(1))*rand([numICs,1])+x2range(1);

lenT = length(tSpan);
warning('Remapping tSpan to values')
tSpan = 0:(lenT-1);

X = zeros(numICs, lenT, 2);

% Seed data and run out dynamics
% in order to solve more accurately than ode45, map into 3D linear system
% and use exact analytic solution 
for j = 1:numICs
    X(j,1,:) = [x1(j); x2(j)];

    for t = 1:(lenT-1)
        x1 = X(j,t,1);
        x2 = X(j,t,2);

        X(j,t+1,1) = lambda * x1;
        X(j,t+1,2) = (mu * x2) + (lambda^2 - mu) * x1^2;
end
