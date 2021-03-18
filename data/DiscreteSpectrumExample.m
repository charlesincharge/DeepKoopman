%% Generates data that can be loaded by xarray in Python

numICs = 5000;
filename = 'DiscreteSpectrumExample.h5';

x1range = [-.5, .5];
x2range = x1range;
tSpan = 0:0.02:1;
mu = -0.05;
lambda = -1;

%% Create file
file_id = H5F.create(filename, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');
root_id = H5G.open(file_id, '/');

%% Label state dimension axis
dim_axis_name = 'state_dim';
dim_axis_idx = 1;
dim_names = {'x1', 'x2'};
h5create(filename, ['/', dim_axis_name], numel(dim_names), 'Datatype', 'string');
h5write(filename, ['/', dim_axis_name], dim_names);
dim_dset_id = H5D.open(root_id, dim_axis_name);
H5DS.set_scale(dim_dset_id, dim_axis_name);
H5D.close(dim_dset_id);

%% Create time axis
time_axis_name = 'time';
h5create(filename, ['/', time_axis_name], numel(tSpan));
h5write(filename, ['/', time_axis_name], tSpan);
time_dset_id = H5D.open(root_id, time_axis_name);
H5DS.set_scale(time_dset_id, time_axis_name);
H5D.close(time_dset_id);

%% Create initial_condition_idx
ic_axis_name = 'initial_condition_idx';
h5create(filename, ['/', ic_axis_name], numICs, 'Datatype', 'int32');
h5write(filename, ['/', ic_axis_name], 1:numICs);
ic_dset_id = H5D.open(root_id, ic_axis_name);
H5DS.set_scale(ic_dset_id, ic_axis_name);
H5D.close(ic_dset_id);

%% Generate data
seed = 1;
data = DiscreteSpectrumExampleFn(x1range, x2range, numICs, tSpan, mu, lambda, seed);
h5create(filename, '/data', size(data));
h5write(filename, '/data', data);

%% Clean up
% Note that some exceptions might cause issues before this
H5G.close(root_id);
H5F.close(file_id);

%% Debug logging
file_h5info = h5info(filename)
