%% Work in Progress
% Optional extension in different function: Write selection problem yaml with input
% Currently only one criterion supported

function arPEtabSelect(venvActPath, yaml, method, limit, initialModel, CalibYamlOut, estimationRoutine, iterationCounter)
if ~exist('iterationCounter') || isempty(iterationCounter)
    iterationCounter = 1;
end
if ~exist('petab-select', 'dir')
    mkdir('petab-select')
end

%% Parse function input

% standard settings
if ~exist('selectionProblem') || isempty(yaml)
    yaml = 'petab_select_problem.yaml';
end
if ~exist('method') || isempty(method)
    method = 'brute_force';
end
if ~exist('level') || isempty(limit)
    limit = 3;
end
if ~exist('initialModel') || isempty(initialModel)
    initialModel = '';
end
if ~exist('CalibYamlOut') || isempty(CalibYamlOut) % think about htis
    CalibYamlOut = 'petab-select/calibrated_it_001.yaml';
end
if ~exist('estimationRoutine') || isempty(estimationRoutine)
    estimationRoutine = @arFit;
end

if exist('venvActPath') && ~isempty(venvActPath)
    initstr = sprintf('source %s; ', venvActPath);
else
    initstr = '';
    venvActPath = '';
end

%% Check if petab_select installation
syscom = [initstr, 'petab_select --help'];
[status,~] = system(syscom);
if status ~= 0
    error(sprintf('Calling petab_select from the command line failed.\nPlease check your Python environment and the PEtab-select installation.'))
end

%% Call PEtab-select to generate candidate models
fprintf('arPEtabSelect: Generating candidate models...\n')
SelectionProblem = ReadYaml(yaml);

syscom = [initstr,...
    'petab_select candidates ',  ...
    ' -y ', yaml, ...
    ' -s output', filesep, 'state.dill',...
    ' -o output', filesep, 'models.yaml', ... %   ' -m ', method, ...
    ' --relative-paths ', ...
    ' -l ', num2str(limit), ...
    ];
if ~isempty(initialModel)
    syscom = [syscom, ' -b ', initialModel];
end
[status,cmdout] = system(syscom);

if status ~= 0
    error(sprintf('Error while running petab_select candidates from command line.\n Command line message:\n %s',cmdout)); %#ok<SPERR>
end

%% Process candidate models
iterationCounter %debug
CandidateModels = ReadYaml(['output' filesep 'models.yaml']);
nModels = size(CandidateModels,2);

if nModels < 1
    fprintf('arPEtabSelect: Finished after iteration %i - no (more) candidate models found.\n', iterationCounter-1)
    return
end
fprintf('arPEtabSelect: Calibrating candidate models...\n')

for jModel = 1:nModels
    % Load & compile
    arInit
    doPreEq = false;
    arImportPEtab(['output', filesep, CandidateModels{jModel}.petab_yaml],doPreEq)
    ar.config.useFitErrorCorrection = 0;
    
    % Import parameter settings
    pars = fieldnames(CandidateModels{jModel}.parameters);    
    estimatedPars = {};
    
    for iPar = 1:length(pars)
        parIndex(iPar) = find(ismember(ar.pLabel,pars(iPar)));    
        if CandidateModels{jModel}.parameters.(pars{iPar}) == 'estimate'
            arSetPars(pars{iPar},[],1)
            estimatedPars{end+1} = pars{iPar};
        else
            parId = arFindPar(pars{iPar});
            parValue = CandidateModels{jModel}.parameters.(pars{iPar});
            if ar.qLog10(parId) == 1
                arSetPars(pars{iPar},log10(parValue),0)
            else
                arSetPars(pars{iPar},parValue,0)
            end
        end
    end
    
    % Add all estimated parameters that are not in model yaml
    if sum(ar.qFit) > 0
        for iModPar = 1:length(ar.qFit)
            % If not already treated above
            if sum(iModPar == parIndex) == 0
                estimatedPars{end+1} = ar.pLabel{iModPar};
            end
        end
    end
    
    
    % Add all parameters not in par but estimated to estimated parameters
    
    
    % Estimate
    %estimationRoutine;

    if sum(ar.qFit) > 0
       arFit
       arFitLHS(10)
    end
    arCalcMerit
    [~, allmerits] = arGetMerit;
    
    % Collect criteria
    criteria.AIC = allmerits.aic;
    criteria.AICc = allmerits.aicc;
    criteria.BIC = allmerits.bic;
    %criteria.nllh = allmerits.loglik/(2);

    calibCands{jModel}.criteria = criteria;
    calibCands{jModel}.model_id = CandidateModels{jModel}.model_id;
    calibCands{jModel}.parameters = CandidateModels{jModel}.parameters;
    calibCands{jModel}.petab_yaml = CandidateModels{jModel}.petab_yaml;
    
    calibCands{jModel}.model_subspace_id = CandidateModels{jModel}.model_subspace_id;
    calibCands{jModel}.model_hash = CandidateModels{jModel}.model_hash;
    calibCands{jModel}.predecessor_model_hash = CandidateModels{jModel}.predecessor_model_hash;
    calibCands{jModel}.model_subspace_indices = CandidateModels{jModel}.model_subspace_indices;


    if isempty(estimatedPars)
        calibCands{jModel}.estimated_parameters = 'null';
    else
        for iPar = 1:length(estimatedPars)
            calibCands{jModel}.estimated_parameters.(estimatedPars{iPar}) = 10^ar.p(arFindPar(estimatedPars{iPar}))*ar.qLog10(arFindPar(estimatedPars{iPar})) + ar.p(arFindPar(estimatedPars{iPar}))*(1-ar.qLog10(arFindPar(estimatedPars{iPar})));
        end
    end
end
WriteYaml(CalibYamlOut,calibCands);

%% Find best model of current iteration
syscom = [initstr,...
    'petab_select best ', ...
    ' -y ', yaml,...
    ' -m ', CalibYamlOut,...
    ' -o petab-select', filesep, sprintf('best_model_it_%03i.yaml',iterationCounter),... 
    ' -s output', filesep, 'state.dill',...
    ' --relative-paths ',...
    ];
[status,cmdout] = system(syscom);
if status ~= 0
    error(sprintf('Error while running petab_select best from command line.\n Command line message:\n %s',cmdout)); %#ok<SPERR>
end

%% Next iteration
fprintf('arPEtabSelect: Iteration %i complete. Continuing with next iteration\n',iterationCounter)
nextIterationYamlOut = ['petab-select', filesep, sprintf('calibrated_it_%03i.yaml',iterationCounter+1)];
arPEtabSelect(venvActPath, yaml, method, limit, CalibYamlOut, nextIterationYamlOut, estimationRoutine,iterationCounter+1)
end