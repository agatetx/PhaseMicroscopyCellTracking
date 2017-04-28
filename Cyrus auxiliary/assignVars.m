function assignVars(vars)

% takes a cell array of alternating variable names and values, and assigns
% the values to the named variables in the caller's workspace (useful for
% assigning to variables the arguments in varargin)
%
% Cyrus A Wilson    February 2005

nargs = size(vars, 2);

narg = 1;

while (narg < nargs) %if narg == nargs, the arg isn't part of a name/value pair,
                     %so ignore
  varName = vars{narg};
  
  if ischar(varName) && isvarname(varName)
    % argument is a valid variable name; we'll assume it's a variable name and
    % the next argument is its value
    assignin('caller', varName, vars{narg + 1}); %assign the variable in the
                                                 %caller's workspace
    narg = narg + 2;
  else
    % argument is not a valid variable name;
    % skip to the next
    narg = narg + 1;
  end
end
