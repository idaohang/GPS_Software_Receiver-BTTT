function varargout = GPS_Software_Receiver(varargin)
% GPS_Software_Receiver M-file for GPS_Software_Receiver.fig
%      GPS_Software_Receiver, by itself, creates a new GPS_Software_Receiver or raises the existing
%      singleton*.
%
%      H = GPS_Software_Receiver returns the handle to a new GPS_Software_Receiver or the handle to
%      the existing singleton*.
%
%      GPS_Software_Receiver('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GPS_Software_Receiver.M with the given input arguments.
%
%      GPS_Software_Receiver('Property','Value',...) creates a new GPS_Software_Receiver or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GPS_Software_Receiver_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GPS_Software_Receiver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GPS_Software_Receiver

% Last Modified by GUIDE v2.5 31-Aug-2010 18:26:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GPS_Software_Receiver_OpeningFcn, ...
    'gui_OutputFcn',  @GPS_Software_Receiver_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GPS_Software_Receiver is made visible.
function GPS_Software_Receiver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GPS_Software_Receiver (see VARARGIN)
clc;
format ('compact');
format ('long', 'g');

addpath receiverFunctions             % The software receiver functions
addpath calculationFunctions        % Position calculation related functions


%--- Try to read data from the variable "settings" ------------------------
% (variable "settings" is in the base Matlab workspace)
try
    handles.settings = evalin('base', 'settings');
catch
    %--- Creat a new settings structure in case of an error ---------------
    handles.settings = initSettings();
end

%--- Assign it to the GUI data structure ----------------------------------
loadSettings(handles);

% Choose default command line output for GPS_Software_Receiver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GPS_Software_Receiver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GPS_Software_Receiver_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%### Callback functions ###################################################

% --- Executes during object creation, after setting all properties.
function edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit as text
%        str2double(get(hObject,'String')) returns contents of edit as a double

%--- Enable the apply button on any input event ---------------------------
set(handles.pushbuttonApply, 'Enable', 'on');


% --- Executes on button press in any checkbox.
function checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to PRN1checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of PRN1checkbox

%--- Enable the apply button on any input event ---------------------------
set(handles.pushbuttonApply, 'Enable', 'on');

% --- Executes on button press in applybutton.
function pushbuttonApply_Callback(hObject, eventdata, handles)
% hObject    handle to applybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--- Try to read values from the GUI input fields -------------------------
[settings, error] = saveSettings(handles);

%--- If no errors, then ...
if error == 0  
    %--- Save the updated settings in the main workspace ------------------
    assignin('base', 'settings', settings);
        
    % Turn off the apply button 
    set(hObject, 'Enable', 'off');
end

% --- Executes on button press in resetbutton.
function pushbuttonReset_Callback(hObject, eventdata, handles)
% hObject    handle to resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--- Try to read data from the variable "settings" ------------------------
% (variable "settings" is in the base Matlab workspace)
try
    handles.settings = evalin('base', 'settings');
catch
    %--- Create a new settings structure in case of an error --------------
    handles.settings = initSettings();
end
    
%--- Assign it to the GUI data structure ----------------------------------
loadSettings(handles);

%--- Save changes in the GUI data structure -------------------------------
guidata(hObject, handles);

%--- Turn off the apply button --------------------------------------------
set(handles.pushbuttonApply, 'Enable', 'off');

%@@@ Function reads values from the GUI and updates the settings structure
function [settings, error] = saveSettings(handles)
settings = handles.settings;
error = 0; % no error

try
    %Please read the Matlab help for mo details on TRY, CATCH and ERROR
    %commands. 
    
    %--- Signal properties related fields ---------------------------------
    settings.fileName           = get(handles.editFileName, 'String');
    settings.numberOfChannels   = edit2double(handles.editNumberOfChannels);
    settings.msToProcess        = edit2double(handles.editMsToProcess);    
    settings.skipNumberOfBytes   = edit2double(handles.editSkipNumberOfBytes);
    settings.IF                 = edit2double(handles.editIF);
    settings.samplingFreq       = edit2double(handles.editSamplingFreq);
    settings.dataType           = get(handles.editDataType, 'String');

    %--- Satellite PRN numbers --------------------------------------------
    for PRN = 1:32
        %If checkbox is checked 
        if getCheckbox(getfield(handles, ['checkboxPRN', num2str(PRN)])) == 1
            
            % Include satellite in the list
            settings.acqSatelliteList = ...
                                    union(settings.acqSatelliteList, PRN);
        else
            % Exclude satellite from the list
            settings.acqSatelliteList = ...
                                  setdiff(settings.acqSatelliteList, PRN);
        end
    end

    %--- Acquisition parameters -------------------------------------------
    settings.acqSearchBand     = edit2double(handles.editAcqSearchBand);
    settings.acqThreshold      = edit2double(handles.editAcqThreshold);
    settings.skipAcquisition   = getCheckbox(handles.checkboxSkipAcquisition); 
    settings.plotsignalpeaks   = getCheckbox(handles.checkboxplotsignalpeaks); 
    
    %--- Tracking ---------------------------------------------------------
    settings.dllCorrelatorSpacing = edit2double(handles.editDllCorrelatorSpacing);
    settings.dllDampingRatio   = edit2double(handles.editDllDampingRatio);
    settings.dllNoiseBandwidth = edit2double(handles.editDllNoiseBandwidth);
    settings.pllDampingRatio   = edit2double(handles.editPllDampingRatio);
    settings.pllNoiseBandwidth = edit2double(handles.editPllNoiseBandwidth);
       
    %--- Nav solutions ----------------------------------------------------
    settings.elevationMask      = edit2double(handles.editElevationMask);
    settings.navSolPeriod       = edit2double(handles.editNavSolPeriod);
    settings.useTropCorr        = getCheckbox(handles.checkboxUseTropCorr);
    settings.truePosition.E     = edit2double(handles.editUtmE);
    settings.truePosition.N     = edit2double(handles.editUtmN);
    settings.truePosition.U     = edit2double(handles.editUtmU);
    
    %--- Plotting ---------------------------------------------------------    
    settings.plotTracking       = getCheckbox(handles.checkboxPlotTracking);

catch
    %Please read the Matlab help for mo details on TRY, CATCH and ERROR
    %commands. 
    
    %--- Read error information -------------------------------------------
    e = lasterror;
    
    %If this error caused by bad input 
    if strcmp(e.identifier, 'setSettings:badInput')
        % then do not save settings, return an error indication 
        error = 1;
    else
        % Not our error, this error must be handled/reported in the system 
        rethrow(e);
    end    
end

%@@@ Function loads the settings into the GUI @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
function loadSettings(handles)

%--- Signal properties related fields -------------------------------------
set(handles.editFileName, 'String', handles.settings.fileName);
set(handles.editNumberOfChannels, 'String', num2str(handles.settings.numberOfChannels));
set(handles.editSkipNumberOfBytes, 'String', num2str(handles.settings.skipNumberOfBytes));
set(handles.editMsToProcess, 'String', num2str(handles.settings.msToProcess));
set(handles.editIF, 'String', num2str(handles.settings.IF));
set(handles.editSamplingFreq, 'String', num2str(handles.settings.samplingFreq ));
set(handles.editDataType, 'String', handles.settings.dataType);

%--- Satellite PRN numbers ------------------------------------------------
for PRN = 1:32
    % If the PRN number is in the list
    if ismember(PRN, handles.settings.acqSatelliteList)
        % then set the checkbox to "checked" state
        setCheckbox(getfield(handles, ['checkboxPRN', num2str(PRN)]), 1);
    else
        % set the checkbox to "unchecked" state
        setCheckbox(getfield(handles, ['checkboxPRN', num2str(PRN)]), 0);
    end
end

%--- Acquisition parameters -------------------------------------------
set(handles.editAcqSearchBand, 'String', num2str(handles.settings.acqSearchBand));
set(handles.editAcqThreshold, 'String', num2str(handles.settings.acqThreshold));
setCheckbox(handles.checkboxSkipAcquisition, handles.settings.skipAcquisition);
setCheckbox(handles.checkboxplotsignalpeaks, handles.settings.plotsignalpeaks);

%--- Tracking ---------------------------------------------------------
set(handles.editDllCorrelatorSpacing, 'String', num2str(handles.settings.dllCorrelatorSpacing));
set(handles.editDllDampingRatio, 'String', num2str(handles.settings.dllDampingRatio));
set(handles.editDllNoiseBandwidth, 'String', num2str(handles.settings.dllNoiseBandwidth));
set(handles.editPllDampingRatio, 'String', num2str(handles.settings.pllDampingRatio));
set(handles.editPllNoiseBandwidth, 'String', num2str(handles.settings.pllNoiseBandwidth));

%--- Nav solutions --------------------------------------------------------
set(handles.editElevationMask, 'String', num2str(handles.settings.elevationMask));
set(handles.editNavSolPeriod, 'String', num2str(handles.settings.navSolPeriod));
setCheckbox(handles.checkboxUseTropCorr, handles.settings.useTropCorr);
set(handles.editUtmE, 'String', num2str(handles.settings.truePosition.E));
set(handles.editUtmN, 'String', num2str(handles.settings.truePosition.N));
set(handles.editUtmU, 'String', num2str(handles.settings.truePosition.U));

%--- Plotting -------------------------------------------------------------
setCheckbox(handles.checkboxPlotTracking, handles.settings.plotTracking);

%@@@ Function reads current state of a checkbox "in the Matlab way" @@@@@@@
function value = getCheckbox(handle)

if (get(handle, 'Value') == get(handle,'Max'))
    % then checkbox is checked
    value = 1;
else
    % checkbox is not checked
    value = 0;
end

%@@@ Function sets checkbox state @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% Setting the "Value" variable to some number not equal to "Min" or "Max"
% will cause Matlab runtime error.
function setCheckbox(handle, value)

if (value == 1)
    % "check" the checkbox
    set(handle, 'Value', get(handle,'Max'));
else
    % "uncheck" the checkbox
    set(handle, 'Value', get(handle,'Min'));
end

%@@@ Function checks if the edit field contains a numeric value. If yes,
%then it converts string type value to double. @@@@@@@@@@@@@@@@@@@@@@@@@@@@
function value = edit2double(handle)

%--- Try to convert string in the entry field to double -------------------
value = str2double(get(handle, 'String'));

% If it is not a number, then handle the incorect input -------------------
if isnan(value) && ~strcmpi(get(handle, 'String'), 'NaN')
    %--- Make the message text ---
    text = ['Bad input in the field "', get(handle, 'UserData'),...
        '". You must enter a numeric value.'];
    
    % Show the error message in a message box
    errordlg(text, 'Bad Input', 'modal');
    
    %--- Stop code execution here and "Throw an error". The error will be
    % "cached" by the "CATCH" statement. The code execution resumes from
    % at the "CATCH" statement. Please read the Matlab help for mo details
    % on TRY, CATCH and ERROR commands.
    error('setSettings:badInput', text);
end


% --- Executes on button press in pushbuttonSelectDataFile.
function pushbuttonSelectDataFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSelectDataFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName, pathName] = uigetfile('*.bin', ...
                                 'Select data file...', ...
                                 get(handles.editFileName, 'String'));

if (~isequal(fileName, 0) && ~isequal(pathName, 0))
    set(handles.editFileName, 'String', fullfile(pathName, fileName));
    set(handles.pushbuttonApply, 'Enable', 'on');    
end

% --- Executes on button press in pushbuttonProbeData.
function pushbuttonProbeData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonProbeData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[settings, error] = saveSettings(handles);

%--- If no errors, then ...
if error == 0
    try
        probeData(settings);
    catch
        errStruct = lasterror;
        msgbox(errStruct.message, 'Error', 'error');
    end
end


% --- Executes on button press in pushbuttonDefault.
function pushbuttonDefault_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.settings = initSettings();

% Assign it to the GUI data structure
loadSettings(handles);

% Update handles structure
guidata(hObject, handles);

% Turn on the apply button
set(handles.pushbuttonApply, 'Enable', 'on');


% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load trackingResults;
msgbox('   解算接收机位置...');
navSolutions = postNavigation(trackResults, settings);

disp('   Processing is complete for this data block');

plotNavigation(navSolutions, settings);


% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


load acqResults;

% [settings, error] = saveSettings(handles);


[fid, message] = fopen(settings.fileName, 'rb');

if  (fid > 0)
if (any(acqResults.carrFreq))
        channel = preRun(acqResults, settings);
        showChannelStatus(channel, settings);
else
        % No satellites to track, exit
        msgbox('No GNSS signals detected, signal processing finished.');
        trackResults = [];
        return;
end
    startTime = now;
    msgbox(['  跟踪开始时间： ', datestr(startTime)]);

    % Process all channels for given data block
    [trackResults, channel] = tracking(fid, channel, settings);

    % Close the data file
    fclose(fid);
    
    msgbox(['   跟踪成功完成 (用时 ', ...
                                        datestr(now - startTime, 13), ')'])     

    % Auto save the acquisition & tracking results to a file to allow
    % running the positioning solution afterwards.
    disp('   Saving Acq & Tracking results to file "trackingResults.mat"')
    save('trackingResults', ...
                      'trackResults', 'settings', 'acqResults', 'channel');
     
    if settings.plotTracking ~= 0
        plotTracking(1:settings.numberOfChannels, trackResults, settings);
    end
else
    % Error while opening the data file.
    error('Unable to read file %s: %s.', settings.fileName, message);
end


% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[settings, error] = saveSettings(handles);

[fid, message] = fopen(settings.fileName, 'rb');

if (fid > 0)
     fseek(fid, settings.skipNumberOfBytes, 'bof');
     
      if ((settings.skipAcquisition == 0) || ~exist('acqResults', 'var'))
        
        % Find number of samples per spreading code
        samplesPerCode = round(settings.samplingFreq / ...
                           (settings.codeFreqBasis / settings.codeLength));
        
        % Read data for acquisition. 11ms of signal are needed for the fine
        % frequency estimation
        data = fread(fid, 11*samplesPerCode, settings.dataType)';

        %--- Do the acquisition -------------------------------------------
        
        acqResults = acquisition(data, settings);
        
        save acqResults;

        plotAcquisition(acqResults);
      end
else
    % Error while opening the data file.
    error('Unable to read file %s: %s.', settings.fileName, message);
end

% --- Executes on button press in pushbutton60.
function pushbutton60_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
      


% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[settings, error] = saveSettings(handles);

[fid, message] = fopen(settings.fileName, 'rb');

%If success, then process the data
if (fid > 0)
    fseek(fid, settings.skipNumberOfBytes, 'bof');
    if ((settings.skipAcquisition == 0) || ~exist('acqResults', 'var'))
        
        % Find number of samples per spreading code
        samplesPerCode = round(settings.samplingFreq / ...
                           (settings.codeFreqBasis / settings.codeLength));
        
        % Read data for acquisition. 11ms of signal are needed for the fine
        % frequency estimation
        data = fread(fid, 11*samplesPerCode, settings.dataType)';

        %--- Do the acquisition -------------------------------------------
        
        acqResults = acquisition(data, settings);
        
        save acqResults;

        plotAcquisition(acqResults);
     end
    
     
     if (~exist('trackingResults', 'var'))
         load acqResults;
         if (any(acqResults.carrFreq))
            channel = preRun(acqResults, settings);
            showChannelStatus(channel, settings);
         else
             % No satellites to track, exit
             msgbox('No GNSS signals detected, signal processing finished.');
             trackResults = [];
             return;
         end
         startTime = now;
         msgbox(['  跟踪开始时间： ', datestr(startTime)]);

         % Process all channels for given data block
         [trackResults, channel] = tracking(fid, channel, settings);

         % Close the data file
         fclose(fid);
    
         msgbox(['   跟踪成功完成 (用时 ', ...
                                        datestr(now - startTime, 13), ')'])     

         % Auto save the acquisition & tracking results to a file to allow
         % running the positioning solution afterwards.
         disp('   Saving Acq & Tracking results to file "trackingResults.mat"')
         save('trackingResults', ...
                      'trackResults', 'settings', 'acqResults', 'channel');
     
         if settings.plotTracking
             plotTracking(1:settings.numberOfChannels, trackResults, settings);
         end
    
    end
     
     load trackingResults;
     msgbox('   解算接收机位置...');
     navSolutions = postNavigation(trackResults, settings);

     msgbox('   Processing is complete for this data block');
     plotNavigation(navSolutions, settings);
     
else
    % Error while opening the data file.
    error('Unable to read file %s: %s.', settings.fileName, message);
end % if (fid > 0)

% --- Executes on button press in checkboxplotsignalpeaks.
function checkboxplotsignalpeaks_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxplotsignalpeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxplotsignalpeaks

%--- Enable the apply button on any input event ---------------------------
set(handles.pushbuttonApply, 'Enable', 'on');


