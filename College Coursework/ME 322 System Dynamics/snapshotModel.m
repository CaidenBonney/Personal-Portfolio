function snapshotModel(in1, in2)
%snapshotModel Capture a snapshot of a Simulink model and display it in a
%figure window.
%   snapshotModel(MODEL) generates a snapshot of the Simulink model in 
%   MODEL on a new figure. MODEL must be specified as the Simulink model
%   name without file extension.
%
%   snapshotModel(HANDLE, MODEL) generates a snapshot of the Simulink model
%   in MODEL on the figure specified by HANDLE. MODEL must be specified as
%   the Simulink model name without file extension.
%

% Import the required components of the report generator
try
    import slreportgen.report.*
catch
    error('You must have the report generator toolbox installed for snapshotModel to execute properly.');
end
    
    
% First check how any input arguments there are to determine if a new
% figure needs to be created. If only one input is specified then a new
% figure handle is created. If two inputs are specified and the first is a
% figure handle, then the snapshot will appear on the specified figure. Any
% other combination of inputs will result in an error.
if nargin == 1
    hf = figure();
    model = in1;
elseif nargin == 2 && strcmp(get(in1, 'type'), 'figure')
    hf = in1;
    model = in2;
else
    error('Invalid inputs specified');
end

% Open the simulink model but don't focus on the simulink GUI
open_system(model,'loadonly');

% Using the report generator, create a large diagram in order to have
% sufficient resolution for the report. The diagram will be saved as a
% temporary file on the local system.
r = Report(tempname, 'html');
D = Diagram(model);
D.SnapshotFormat = 'png';
D.Scaling='zoom';
D.Zoom='300%';
D.MaxWidth = '12in';
D.MaxHeight = '12in';
add(r,D);

% Read the diagram from the temp file and display it as a figure.
% Additionally the warnings associated with large figures will be
% supressed.
im = imread(D.Snapshot.Image.Content.Path);
figure(hf);
warning('off','MATLAB:print:FigureTooLargeForPage');
imshow(im,'Border','tight','InitialMagnification',100);
warning('on','MATLAB:print:FigureTooLargeForPage');
close(r);

% Clean up any mess created by the report generator.
delete(r.OutputPath);
end