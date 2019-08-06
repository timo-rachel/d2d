% WriteMatlabFunction(fit, folder)
% 
%   fit     a fit or cell array of fits as generated by
%   arConditon2NewDataStruct*.m
% 
%   folder  [WriteMatlabFunction]
% 
% This function write matlab code for simulating the dynamics based on
% fitted transient functions in the specified folder.
% 
%   Example:
% arLoad
% fits = arApproximateTimeCoursesByTransientFunction2;
% WriteMatlabFunction(fits)
% t = linspace(0,100,101);
% plot(t,feval(fits{1}.label,t));

function WriteMatlabFunction(fit,folder)
if ~exist('folder','var') || isempty(folder)
    folder = 'WriteMatlabFunction';
end
if ~isdir(folder)
    mkdir(folder);
end

if iscell(fit)
    for i=1:length(fit)
        if isfield(fit{i},'pLabel') % otherwise fitting failed
            WriteMatlabFunction(fit{i});
        else
            fprintf('WriteMatlabFunction.m: It seems that fit{%i} fitting was failed.\n',i)
        end
    end
    
else
    if isfield(fit,'label')
        name = sprintf('%s',fit.label);
    else
        name = sprintf('Model%i_%s_condition%i',fit.m, fit.x, fit.c);
    end
    name = strrep(name,' ','_');
    filename = [folder,filesep,name,'.m'];
    fid = fopen(filename,'w');
    
    fprintf(fid,'%s This function can be used to approximate model%i, condition%i, dynamic variable %s\n\n','%',fit.m, fit.c, fit.x);
    fprintf(fid,'function [out, outSD] = %s(t)\n',name);
    for i=1:length(fit.data.p)
        if strcmp('init____dummy___',fit.data.p{i})~=1  % omit this D2D dummy parameter
            if strcmp(fit.data.p{i},fit.data.fp{i})~=1
                fprintf(fid,'%s = %s;\n',fit.data.p{i},fit.data.fp{i});
            else
                ind = strmatch(fit.data.p{i},fit.pLabel,'exact');
                fprintf(fid,'%s = %f;\n',fit.data.p{i},fit.p(ind));
            end
        end
    end
    fprintf(fid,'\n');
    for i=1:length(fit.data.fu)
        fprintf(fid,'%s = %s;\n',fit.u{i},Replacements(fit.data.fu{i}));
    end
    fprintf(fid,'\n');
    for i=1:length(fit.data.fy)
        fprintf(fid,'out = %s;\n',Replacements(fit.data.fy{i}));
    end
    fprintf(fid,'\n');
    fprintf(fid,'outSD = NaN(size(out));\n');
    fprintf(fid,'outSD(:) = %f;\n',fit.approxErr);
    fprintf(fid,'\n');
    
    


    
    fclose(fid);
end


function out = Replacements(in)
out = strrep(in,'*','.*');
out = strrep(out,'/','./');
out = strrep(out,'^','.^');

