function varargout = ay_klam(varargin)
% AY_KLAM MATLAB code for ay_klam.fig
%      AY_KLAM, by itself, creates a new AY_KLAM or raises the existing
%      singleton*.
%
%      H = AY_KLAM returns the handle to a new AY_KLAM or the handle to
%      the existing singleton*.
%
%      AY_KLAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AY_KLAM.M with the given input arguments.
%
%      AY_KLAM('Property','Value',...) creates a new AY_KLAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ay_klam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ay_klam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ay_klam

% Last Modified by GUIDE v2.5 24-Apr-2019 10:54:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ay_klam_OpeningFcn, ...
                   'gui_OutputFcn',  @ay_klam_OutputFcn, ...
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


% --- Executes just before ay_klam is made visible.
function ay_klam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ay_klam (see VARARGIN)

% Choose default command line output for ay_klam
handles.output = hObject;
% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('C:\Users\NADA EL-SAYED\Downloads\FER-project\WhatsApp Image 2019-04-24 at 12.19.17 AM.jpeg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ay_klam wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ay_klam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.gif';'*.bmp';'*.jpg'},'File Selector');
global x

x= strcat(pathname, filename);
axes(handles.axes1);
imshow(x)
set(handles.edit1,'string',filename);
set(handles.edit2,'string',x);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global x
input_dir = 'C:\Users\NADA EL-SAYED\Downloads\FER-project\yale-face-database';
image_dims = [243,320];
 
filenames = dir(fullfile(input_dir, '*.jpg'));
num_images = numel(filenames);
images = [];
for n = 1:num_images
    filename = fullfile(input_dir, filenames(n).name);
    img = imread(filename);
   img3 = reshape(img,prod(image_dims),1);
    if n == 1
        images = zeros(prod(image_dims), num_images);
    end
    images(:, n) = img3(:);
end
% % steps 1 and 2: find the mean image and the mean-shifted input images
 mean_face = mean(images, 2);
shifted_images = images - repmat(mean_face, 1, num_images);
% 
 [evectors, score, evalues] = pca(images');
%  
% 
 num_eigenfaces = 20;
 evectors = evectors(:,1:num_eigenfaces);
% % step 6: project the images into the subspace to generate the feature vectors
 features = evectors' * shifted_images;
% 
 input_image = imread(x);
%  input_image2 = reshape(input_image,prod(image_dims),1);
 feature_vec = evectors' * (double(input_image(:)) - mean_face);
 similarity_score = arrayfun(@(n) 1 / (1 + norm(features(:,n) - feature_vec)), 1:num_images);
%  
% 
[match_score, match_ix] = max(similarity_score);
% recognized_img= strcat(int2str(match_ix),'.jpg');
% selected_img= strcat('C:\Users\NADA EL-SAYED\Downloads\FER-project\yale-face-database', '\',recognized_img);
% select_img=imread(selected_img);

% imshow(select_img)

 axes(handles.axes2);
 imshow([input_image reshape(images(:,match_ix),image_dims)]);
 title(sprintf('matches%s,score%f',filenames(match_ix).name,-match_score));


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x
 I = imread(x);
    PSF = fspecial('motion', 21, 15);
blurred = imfilter(I, PSF, 'conv', 'circular');
axes(handles.axes2)
imshow(blurred)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x
 I = imread(x);
    PSF = fspecial('motion', 21, 15);
blurred = imfilter(I, PSF, 'conv', 'circular');

wnr3 = deconvwnr(blurred, PSF,0.00005);
axes(handles.axes2);
imshow(wnr3)
  


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x
I = imread(x);
J = histeq(I);
axes(handles.axes2);
imshow(J);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x
i=imread(x);
J = imadjust(i);
axes(handles.axes2);
imshow(J)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global x
contents = get(hObject,'Value')
switch contents
    case 2
        a = imread(x);
        bw= edge(a,'sobel');
        axes(handles.axes2);
imshow(bw)
    case 3
        a = imread(x);
        bw2= edge(a,'canny');
        axes(handles.axes2);
imshow(bw2)
    otherwise
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

global x
contents = get(hObject,'Value')
switch contents
    case 2
        i = imread(x);
y = imnoise(i,'salt & pepper',0.2);
axes(handles.axes2);
imshow(y)
    case 3
        i = imread(x);
 y = imnoise(i,'speckle');
 axes(handles.axes2);
imshow(y)
    case 4
        i = imread(x);
y = imnoise(i,'gaussian');
axes(handles.axes2);
imshow(y)
    otherwise
end
% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
global x

contents = get(hObject,'Value')
switch contents
    case 2
        i = imread(x);
        y = imnoise(i,'salt & pepper',0.2);
 h = fspecial('unsharp');
 j=imfilter(y,h);
axes(handles.axes2);
imshow(j)
    case 3
        i = imread(x);
        y = imnoise(i,'salt & pepper',0.2);
  k = filter2(fspecial('average',3),y)/255;
 axes(handles.axes2);
imshow(k)
    case 4
        i = imread(x);
        y = imnoise(i,'salt & pepper',0.2);
 n = medfilt2(y,[5 5]);
axes(handles.axes2);
imshow(n)
    case 5
        i = imread(x);
        y = imnoise(i,'salt & pepper',0.2);
         m =wiener2(y,[5 5]);
         axes(handles.axes2);
imshow(m)
    otherwise
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

global x
contents = get(hObject,'Value')
switch contents
    case 2
  a = imread(x);
a = imresize(a,0.4);
detector = vision.CascadeObjectDetector('Mouth');

detector.MergeThreshold=5;

bbox = step(detector, a);
B = insertObjectAnnotation(a,'rectangle',bbox,'Mouth');
axes(handles.axes2);
imshow(B)
    case 3
a = imread(x);
a = imresize(a,0.4);
detector = vision.CascadeObjectDetector('EyePairBig');

detector.MergeThreshold=1;

bbox = step(detector, a);
B = insertObjectAnnotation(a,'rectangle',bbox,'EyePairBig');

 axes(handles.axes2);
imshow(B)
    case 4
        a = imread(x);
a = imresize(a,0.4);
detector = vision.CascadeObjectDetector('Nose');

detector.MergeThreshold=10;

bbox = step(detector, a);
B = insertObjectAnnotation(a,'rectangle',bbox,'Nose');
axes(handles.axes2);
imshow(B)
    otherwise
end

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
