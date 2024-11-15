% arChi2LHS([n], [sensis], [randomseed], [silent], [use_cluster])
% 
% Performs a chi2 sequence (without fitting)
%   - using random sampling from prior (ar.config.useLHS = 0 [default])
%   - using latin hyper cube sampling (ar.config.useLHS = 1)
% and returns the likelihood values.
%
% n:            number of runs          [10]
% sensis:       use sensitivities       [false]
% randomseed:                           rng(randomseed)
% silent:       no output               [false]
% use_cluster:                          [false]
% 
% Creates as waterfall plot for the initial guesses of e.g. the multistart
% optimisation procedure. Can be used, for example, to check which areas of
% the parameter search space are close to the optimum or far off.
% 
% Example: 
%   arChi2LHS(100,[],1337) 
% 
% See also arChi2, arFitLHS, arScanChi2, arSample

function arChi2LHS(n, sensis, randomseed, silent, use_cluster)

if(~exist('n','var'))
    n = 10;
end
if(~exist('sensis','var'))
    sensis = false;
end
if(~exist('randomseed','var'))
    randomseed = [];
end
if(~exist('silent','var'))
    silent = false;
end
if(~exist('use_cluster','var'))
    use_cluster = false;
end

global ar
if ~isfield(ar.config,'restartLHS')
    ar.config.restartLHS = 0;
end

% generate random values
ps = arRandomPars(n, randomseed);

if(~use_cluster)
    arChi2s(ps, sensis, silent);
else
    arChi2sCluster(ps, sensis, silent);
end

if ar.config.restartLHS ==1 && isempty(randomseed)
    indnan = find(isnan(ar.chi2s));
    counter = 1;
    while ~isempty(indnan) && counter<10
        counter = counter+1;
    
        fprintf('Repeat function evaluation %i\n', indnan); 
        
        % get new parameters
        ps = arRandomPars(n, randomseed);
        pstmp = ps(indnan,:);
        
        % backup old values
        ar_old = arDeepCopy(ar);
        
        if(~use_cluster)
            arChi2s(pstmp, sensis, true);
        else
            arChi2sCluster(pstmp, sensis, true);
        end
        
        % save new values
        chi2s_new = ar.chi2s;
        ps_new = ar.ps;
        timing_new = ar.timing;
        exitflag_new = ar.exitflag;
        chi2fit_new = ar.chi2fit;
        chi2sconstr_new = ar.chi2constr;
        
        % overwrite ar from backup
        ar = arDeepCopy(ar_old);
        
        % write new values
        ar.chi2s(indnan) = chi2s_new;
        ar.ps(indnan,:) = ps_new;
        ar.timing(indnan) = timing_new;
        ar.exitflag(indnan) = exitflag_new;
        ar.chi2fit(indnan) = chi2fit_new;
        ar.chi2constr(indnan) = chi2sconstr_new;
        
        indnan = find(isnan(ar.chi2s));
    end
    
    if(~silent)
        arPlotChi2s
    end
else
    if(sum(isnan(ar.chi2s))>0)
        fprintf('\nSome function evaluations yield parameters where ODE intergration was not feasible.\n');
        fprintf('Such fits can be automatically restarted with another intial guess by setting\n');
        fprintf('   ar.config.restartLHS = 1\n\n')
    end
end
