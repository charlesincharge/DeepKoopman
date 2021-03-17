
numICs = 5000;
filename = 'DiscreteSpectrumExample.h5';

if exist(filename, 'file') == 2
    warning('Deleting %s', filename);
    delete(filename);
end


x1range = [-.5, .5];
x2range = x1range;
tSpan = 0:0.02:1;
mu = -0.05;
lambda = -1;

% time variable
h5create(filename, '/time', numel(tSpan));
h5write(filename, '/time', tSpan)

% test data
seed = 1;
X_test = DiscreteSpectrumExampleFn(x1range, x2range, round(.1*numICs), tSpan, mu, lambda, seed);
h5create(filename, '/test', size(X_test));
h5write(filename, '/test', X_test)

% validation
seed = 2;
X_val = DiscreteSpectrumExampleFn(x1range, x2range, round(.2*numICs), tSpan, mu, lambda, seed);
h5create(filename, '/val', size(X_val));
h5write(filename, '/val', X_val)

% training data
for j = 1:3
	seed = 2+j;
	X_train = DiscreteSpectrumExampleFn(x1range, x2range, round(.7*numICs), tSpan, mu, lambda, seed);
	group_name = sprintf('/train_%d',j);
	h5create(filename, group_name, size(X_train))
	h5write(filename, group_name, X_train)
end


