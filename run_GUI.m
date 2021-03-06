function run_GUI()
my_pathdef;
if exist('autosave.fig','file') % Open existing GUI workspace
    
    choice = questdlg('What workspace would you like to load?', 'Workspace selection', ...
        'Last workspace', 'New workspace', 'Last workspace');
    % Handle response
    switch choice
        case 'New workspace'
            CellTrackingGui();
        case 'Last workspace'
            hgload('autosave.fig');
    end
    
else % Initilize new GUI workspace
    CellTrackingGui();
end
end