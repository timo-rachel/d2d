% collectfun = arFitLhsBwCluster(Nfit,fitsPerCore)
%
% arFitLhsBwCluster performs arFitLHS on the BwGrid by automatically
% generating scripts (startup, moab, matlab) and calling them.
%
%   Nfit           total number of fits as used by arFitLHS(Nfit)
%   fitsPerCore    number of fits on an individual core
%                  (usually something between  1 and 10)
%                  [10]  Default value
% 
%   collectfun  the function including path which collects the results,
%               this file can be executed via run(collectfun) if the
%               analyses are finished.
%
% The number of cores in a node is by default 5 as specified in
% arClusterConfig.m. The number of nodes is calculated from Nfit and fitsPerCore
% (and 5 cores per node).
% 
% Example 1:
%     arLoadLatest                      % load some workspace
%     arFitLhsBwCluster(1000,10)        % arFitLHS(1000) with 10 Fits per core
% 
%     "Call m_20181221T154020_D13811_results.m manually after the analysis is finished!"
% 
%     m_20181221T154020_D13811_results  % follow the advice (wait and collect the results using the automatically written function)
%     results                           % a struct containing the results
% 
% Example 2: 
% collectfun = arFitLhsBwCluster(1000)
% run(collectfun)
% 
% See also arClusterConfig, arFitLHS

function collectfun = arFitLhsBwCluster(Nfit,fitsPerCore)
if ~exist('fitsPerCore','var') || isempty(fitsPerCore)
    fitsPerCore = 10;
end

%% configuration
fprintf('arFitLhsBwCluster.m: Generating bwGrid config ...\n');
conf = arClusterConfig;
if (fitsPerCore*conf.n_inNode>Nfit)
    error('For %i cores per node, and a total of %i fits, it''s not meaninful to make %i fits on each core.',conf.n_inNode,Nfit,fitsPerCore);
end
conf.n_calls = ceil((Nfit/conf.n_inNode)/fitsPerCore);

%% writing the startup bash-script:
fprintf('arFitLhsBwCluster.m: Writing startup file %s ...\n',conf.file_startup);
arWriteClusterStartup(conf);

%% writing the moab file:
fprintf('arFitLhsBwCluster.m: Writing moab file %s ...\n',conf.file_moab);
arWriteClusterMoab(conf);

%% saving global ar in a workspace:
global ar
save(conf.file_ar_workspace,'ar');

%% Writing matlab code for LHS:
fprintf('arFitLhsBwCluster.m: Writing matlab file %s ...\n',conf.file_matlab);
fprintf('%i fits will be performed on %i nodes and with %i cores at each node.\n',fitsPerCore,conf.n_calls,conf.n_inNode);
WriteClusterMatlabFile(conf,fitsPerCore,Nfit); 

%% starting calculation by calling the startup script:
fprintf('arFitLhsBwCluster.m: Starting job in background ...\n');
system(sprintf('bash %s\n',conf.file_startup));

%% Writing the function for collecting results:
fprintf('arFitLhsBwCluster.m: Write matlab file for collecting results ...\n');
collectfun = WriteClusterMatlabResultCollection(conf);

fprintf('-> Call %s manually after the analysis is finished!\n',conf.file_matlab_results);
fprintf('The collected results are then stored in variable ''results''.\n');


% collectfun = WriteClusterMatlabResultCollection(conf)
% 
% WriteClusterMatlabResultCollection writes the function for collecting the
% results in workspaces and put them into variable results.
% 
%   conf    Output of arClusterConfig.m
function collectfun = WriteClusterMatlabResultCollection(conf)

mcode = {
    'function results = collectfun',...
    'olddir = pwd;',...
    ['cd ',conf.pwd], ...
    ['load(''',conf.file_ar_workspace,''',''ar'');'],...    
    ['matFiles = dir([''',conf.save_path,''',filesep,''result*.mat'']);'], ...
    'matFiles = {matFiles.name};',...
    'fprintf(''%i result workspaced will be collected ...\n'',length(matFiles));', ...
    'results = struct;', ...
    'for i=1:length(matFiles)', ...
    ['    tmp = load([''',conf.save_path,''',filesep,matFiles{i}]);'], ...
    '    if i==1', ...
    '        fn = fieldnames(tmp.result);', ...
    '    end', ...
    '    for f=1:length(fn)', ...
    '        if i==1', ...
    '            if ischar(tmp.result.(fn{f}))', ...
    '                results.(fn{f}) = {tmp.result.(fn{f})};', ...
    '            else', ...
    '                results.(fn{f}) = tmp.result.(fn{f});', ...
    '            end', ...
    '        elseif ischar(tmp.result.(fn{f}))', ...
    '            results.(fn{f}){end+1} = tmp.result.(fn{f});', ...
    '        elseif length(tmp.result.(fn{f}))==1', ...
    '            results.(fn{f}) = [results.(fn{f}),tmp.result.(fn{f})];', ...
    '        elseif size(tmp.result.(fn{f}),2)==length(ar.p) && size(tmp.result.(fn{f}),1) == tmp.result.fitsPerCore', ...
    '            results.(fn{f}) = [results.(fn{f});tmp.result.(fn{f})];', ...
    '        elseif size(tmp.result.(fn{f}),1) == 1', ...
    '            results.(fn{f}) = [results.(fn{f}),tmp.result.(fn{f})];', ...
    '        elseif size(tmp.result.(fn{f}),2) == 1', ...
    '            results.(fn{f}) = [results.(fn{f});tmp.result.(fn{f})];', ...
    '        end', ...
    '    end', ...
    'end', ...
    '', ...
    'for f=1:length(fn)', ...
    '   ar.(fn{f}) = results.(fn{f});',...
    'end',...
    ['save(''',conf.file_ar_workspace,''',''ar'');'],...    
    '',...
    ['save(''',conf.name,'_results.mat'', ''results'');'], ...
    ['disp(''',conf.name,'_results.mat is written and ',conf.file_ar_workspace,'.mat is updated.'')'],...
    'cd(olddir)',...
    };

fid = fopen(conf.file_matlab_results,'w');
for i=1:length(mcode)
    fprintf(fid,'%s\n',mcode{i});
end
fclose(fid);

collectfun = [conf.pwd,filesep,conf.file_matlab_results];


% WriteClusterMatlabFile(conf,fitsPerCore,Nfit)
% 
% WriteClusterMatlabFile writes the matlab code for performing LHS
% 
%   conf            Output of arClusterConfig.m
%   fitsPerCore     the number of fits per core
%   Nfit            total number of fits
% 
% The following variables are available in matlab (provided by moab file)
% icall     call/node number
% iInNode   for parallelization within a node
% arg1      further argument (if required
%
% Nfit denotes the total LHS size (total number of fits), fitsPerCore the number
% of fits within one call.
% 
% The model must be loaded first.
function WriteClusterMatlabFile(conf,fitsPerCore,Nfit)

mcode = {
    ['cd ',conf.pwd], ...
    ['addpath(''',conf.d2dpath,''');'], ...
    'arInit;', ...
    'global ar', ...
    ['load(''',conf.file_ar_workspace,''');'],...
    '', ...
    ['conf.n_inNode = ',num2str(conf.n_inNode),';'],...
    ['conf.save_path = ''',conf.save_path,''';'],...
    ['fitsPerCore = ',num2str(fitsPerCore),';'],...
    ['Nfit = ',num2str(Nfit),';'],...
    '', ...
    'fields = {...',...
    '    ''ps_start'',...',...
    '    ''ps'',...     ',...
    '    ''ps_errors'',...   ',...
    '    ''chi2s_start'',...     ',...
    '    ''chi2sconstr_start'',...    ',...
    '    ''chi2s'',...     ',...
    '    ''chi2sconstr'',...    ',...
    '    ''exitflag'',...     ',...
    '    ''timing'',...    ',...
    '    ''fun_evals'',...     ',...
    '    ''iter'',...     ',...
    '    ''optim_crit''};',...
    '',...
    'indLhs = (icall-1)*conf.n_inNode + iInNode;',...
    'doneFits = (indLhs-1)*fitsPerCore;',...
    'arFitLHS(min(fitsPerCore,Nfit-doneFits),indLhs);',...
    '',...
    'result = struct;',...
    'for ifield = 1:length(fields)',...
    '    result.(fields{ifield}) = ar.(fields{ifield});',...
    'end',...
    'result.icall = icall;',...
    'result.iInNode = iInNode;',...
    'result.arg1 = arg1;',...
    'result.indLhs = indLhs;',...
    'result.Nfit = Nfit;',...
    'result.fitsPerCore = fitsPerCore;',...
    'result.file = [conf.save_path,filesep,''result_'',num2str(indLhs)];',...
    '',...
    'save(result.file,''result'');',...
    };

fid = fopen(conf.file_matlab,'w');
for i=1:length(mcode)
    fprintf(fid,'%s\n',mcode{i});
end
fclose(fid);




