function varargout = SRH_TIDLS_model_ver0(varargin)
% SRH_TIDLS_MODEL_VER0 MATLAB code for SRH_TIDLS_model_ver0.fig
%      SRH_TIDLS_MODEL_VER0, by itself, creates a new SRH_TIDLS_MODEL_VER0 or raises the existing
%      singleton*.
%
%      H = SRH_TIDLS_MODEL_VER0 returns the handle to a new SRH_TIDLS_MODEL_VER0 or the handle to
%      the existing singleton*.
%
%      SRH_TIDLS_MODEL_VER0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SRH_TIDLS_MODEL_VER0.M with the given input arguments.
%
%      SRH_TIDLS_MODEL_VER0('Property','Value',...) creates a new SRH_TIDLS_MODEL_VER0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SRH_TIDLS_model_ver0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SRH_TIDLS_model_ver0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SRH_TIDLS_model_ver0

% Last Modified by GUIDE v2.5 04-Jan-2014 16:10:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SRH_TIDLS_model_ver0_OpeningFcn, ...
                   'gui_OutputFcn',  @SRH_TIDLS_model_ver0_OutputFcn, ...
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


% --- Executes just before SRH_TIDLS_model_ver0 is made visible.
function SRH_TIDLS_model_ver0_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SRH_TIDLS_model_ver0 (see VARARGIN)

% Choose default command line output for SRH_TIDLS_model_ver0
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SRH_TIDLS_model_ver0 wait for user response (see UIRESUME)
% uiwait(handles.SRH_TIDLS_model_ver0);


% --- Outputs from this function are returned to the command line.
function varargout = SRH_TIDLS_model_ver0_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when SRH_TIDLS_model_ver0 is resized.
function SRH_TIDLS_model_ver0_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to SRH_TIDLS_model_ver0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in evaluate.
function evaluate_Callback(hObject, eventdata, handles)
% hObject    handle to evaluate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla;

%Define excess carrier densities to evaluate at
handles.delta_n = [1e13 3e13 6e13 1e14 3e14 6e14 1e15 3e15 6e15 1e16 3e16 6e16 1e17 3e17 6e17 1e18 3e18 6e18 1e19]; %cm^-3

%Define temperatures to evaluate at based on min and max as entered by user
if handles.Tmin==handles.Tmax
    handles.T=handles.Tmin; %K
else
	handles.T = handles.Tmin:((handles.Tmax-handles.Tmin)/5):handles.Tmax; %K
end

%Initialize matrix
handles.tau_SRH_full = zeros(length(handles.delta_n),length(handles.T));

%Populate matrix
for i = 1:length(handles.T)
    for j = 1:length(handles.delta_n)
        [handles.tau_SRH_full(j,i)] = SRH_full_std(handles.Nt,handles.sigma_n,handles.sigma_p,handles.Ect,handles.Etv,handles.T(i),handles.delta_n(j),handles.N_dop,handles.type); %microseconds
    end
end

guidata(hObject,handles);

colors = ['r' 'g' 'b' 'c' 'm' 'k' 'y'];

%Plot the resulting data
for i = 1:length(handles.T)
    hold all;
    hcolors(i) = loglog(handles.delta_n,handles.tau_SRH_full(:,i),'color',colors(i),'LineWidth',3); 
end

grid on;
xlabel('Excess carrier density (cm^-^3)');
ylabel('Tau_S_R_H (microseconds)');
legend(hcolors, num2str(handles.T(:))); 
title('SRH Lifetimes for standard (-) and advanced (--) models');

%Now, get the advanced model data and plot

%Initialize matrix
handles.tau_SRH_full_adv = zeros(length(handles.delta_n),length(handles.T));

%Populate matrix
for i = 1:length(handles.T)
    for j = 1:length(handles.delta_n)
        [handles.tau_SRH_full_adv(j,i)] = SRH_full_adv(handles.Nt,handles.sigma_n,handles.sigma_p,handles.Ect,handles.Etv,handles.T(i),handles.delta_n(j),handles.N_dop,handles.type); %microseconds
    end
end

guidata(hObject,handles);

%Plot the resulting data and write it to an Excel file
for i = 1:length(handles.T)
    loglog(handles.delta_n,handles.tau_SRH_full_adv(:,i),'LineStyle','--','color', colors(i),'LineWidth', 3); 
    hold all;
end

xlswrite('SRH_output.xlsx',handles.delta_n','Sheet1');
xlswrite('SRH_output.xlsx',handles.tau_SRH_full_adv,'Sheet2');



function Nt_Callback(hObject, eventdata, handles)
% hObject    handle to Nt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get defect concentration of sample and place in handles
handles.Nt = str2double(get(hObject,'String'));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of Nt as text
%        str2double(get(hObject,'String')) returns contents of Nt as a double


% --- Executes during object creation, after setting all properties.
function Nt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in defect_type.
function defect_type_Callback(hObject, eventdata, handles)
% hObject    handle to defect_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%All the possible defect types
defect_types = cellstr(get(hObject,'String'));
%The defect type selected by user
handles.defect_type = defect_types{get(hObject,'Value')};
% Au-s-d
% Au-s-a
% CrB
% Fe-i
% FeB-d
% FeB-a
% Mo-i
% Pt-s-a
% Pt-s-d
% Ti-i
%Now set global defect parameters based on selection
if strcmp(handles.defect_type,'Au-s-d')==1
    handles.sigma_p = 2.5e-15; %cm^-3
    handles.sigma_n = 2.7e-15; %cm^-3
    handles.Etv = 0.34; %eV
    handles.Ect = 0; %eV
elseif strcmp(handles.defect_type,'Au-s-a')==1
    handles.sigma_p = 7.6e-15; %cm^-3
    handles.sigma_n = 1.4e-16; %cm^-3
    handles.Etv = 0; %eV
    handles.Ect = 0.55; %eV
elseif strcmp(handles.defect_type,'CrB')==1
    handles.sigma_p = 1.1e-14; %cm^-3
    handles.sigma_n = 4.5e-15; %cm^-3
    handles.Etv = 0; %eV
    handles.Ect = 0.844; %eV
elseif strcmp(handles.defect_type,'Fe-i')==1
    handles.sigma_p = 7e-7; %cm^-3 (Note - there is a temp-dependent model available here)
    handles.sigma_n = 4e-14; %cm^-3
    handles.Etv = 0; %eV
    handles.Ect = 0.745; %eV
elseif strcmp(handles.defect_type,'FeB-d')==1
    handles.sigma_p = 2e-14; %cm^-3
    handles.sigma_n = 4e-13; %cm^-3
    handles.Etv = 0.1; %eV
    handles.Ect = 0; %eV
elseif strcmp(handles.defect_type,'FeB-a')==1
    handles.sigma_p = 2e-15; %cm^-3
    handles.sigma_n = 1.6e-15; %cm^-3
    handles.Etv = 0; %eV
    handles.Ect = 0.27; %eV
elseif strcmp(handles.defect_type,'Mo-i')==1
    handles.sigma_p = 6e-16; %cm^-3
    handles.sigma_n = 1.6e-14; %cm^-3
    handles.Etv = 0.28; %eV
    handles.Ect = 0; %eV
elseif strcmp(handles.defect_type,'Pt-s-a')==1
    handles.sigma_p = 2.9e-14; %cm^-3
    handles.sigma_n = 2.6e-14; %cm^-3
    handles.Etv = 0; %eV
    handles.Ect = 0.23; %eV
elseif strcmp(handles.defect_type,'Pt-s-d')==1
    handles.sigma_p = 8.4e-15; %cm^-3 (Note - there is a temp-dependent model available here)
    handles.sigma_n = 1e-16; %cm^-3
    handles.Etv = 0.32; %eV
    handles.Ect = 0; %eV
elseif strcmp(handles.defect_type,'Ti-i')==1
    handles.sigma_p = 3.7e-17; %cm^-3
    handles.sigma_n = 1.5e-15; %cm^-3
    handles.Etv = 0; %eV
    handles.Ect = 0.865; %eV
elseif strcmp(handles.defect_type,'Cr-i')==1
    handles.sigma_p = 4e-15; %cm^-3
    handles.sigma_n = 2e-14; %cm^-3
    handles.Etv = 0; %eV
    handles.Ect = 0.24; %eV
end
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns defect_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from defect_type


% --- Executes during object creation, after setting all properties.
function defect_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to defect_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function N_dop_Callback(hObject, eventdata, handles)
% hObject    handle to N_dop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get doping concentration of sample and place as number in handles
handles.N_dop = str2double(get(hObject,'String'));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of N_dop as text
%        str2double(get(hObject,'String')) returns contents of N_dop as a double


% --- Executes during object creation, after setting all properties.
function N_dop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_dop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tmin_Callback(hObject, eventdata, handles)
% hObject    handle to Tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get minimum T to evaluate at and place as number in handles
handles.Tmin = str2double(get(hObject,'String'));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of Tmin as text
%        str2double(get(hObject,'String')) returns contents of Tmin as a double


% --- Executes during object creation, after setting all properties.
function Tmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tmax_Callback(hObject, eventdata, handles)
% hObject    handle to Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get maximum T to evaluate at and place as number in handles
handles.Tmax = str2double(get(hObject,'String'));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of Tmax as text
%        str2double(get(hObject,'String')) returns contents of Tmax as a double


% --- Executes during object creation, after setting all properties.
function Tmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function type_Callback(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get sample type (n or p) and place in handles as a string
handles.type = get(hObject,'String');
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of type as text
%        str2double(get(hObject,'String')) returns contents of type as a double


% --- Executes during object creation, after setting all properties.
function type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
