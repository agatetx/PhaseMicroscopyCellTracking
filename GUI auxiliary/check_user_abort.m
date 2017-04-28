function res = check_user_abort(handles)

% 
% res = check_user_abort(handles)
% 
% A GUI helper function to determine wether the user is 
% asking to abort the tracking process
% 
% input:
%     handles - standard GUI handles array
%     
% output:
%     res - boolean result (true if user wants to abort)
%         
        
        
if(strcmp(get(handles.pushbuttonAbortTracking,'String'),'Aborting...'))
    set(handles.pushbuttonAbortTracking,'String', 'Abort');
    
    ME = MException('UserAction:UserHitAbort', ...
        'EXEPTION: User hit the abort button');
    throw(ME);
else 
    return;
end