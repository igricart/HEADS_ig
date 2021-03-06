function [Y_ddot, Y_dot, Y, Xf, Af] = sinNeuralNetFcn(X,~,~)
%SINNEURALNETFCN neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 24-Apr-2019 16:33:46.
% 
% [Y] = sinNeuralNetFcn(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = 1xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 1xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = 0;
x1_step1.gain = 0.4;
x1_step1.ymin = -1;

% Layer 1
b1 = [-6.6558675289538884456;4.9546056053266633867;-2.9161993537125385778;2.2002903600517802474;0.69086704983979274619;-0.65972714704967716504;0.40355141864682803066;-2.2510612445480755461;-4.989264766064228418;5.4211747864529824525];
IW1_1 = [6.7915476748637679805;-6.2955404144841882186;4.9341294186711284198;-5.6889151919468599061;-3.8458315814402208588;-3.3057095087767280894;2.0507929103327988685;-3.8878680442941164763;-6.4319527166913372795;5.5106835152049233884];

% Layer 2
b2 = 3.4233499828784830221;
LW2_1 = [5.111232154208141587 3.5902831048321295349 16.33963225827798027 3.6312622035831507716 -65.975603058127703093 -194.52008776621337915 -352.70192667705634904 -63.300152792970472149 1.8934823938860589898 12.880678938421516122];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 1.00000004936777;
y1_step1.xoffset = -0.999999950632233;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
  X = {X};
end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
  Q = size(X{1},2); % samples/series
else
  Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);
Y_dot = cell(1,TS);
Y_ddot = cell(1,TS);

% Time loop
for ts=1:TS

    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
    
    % Output 2
    Y_dot{1,ts} = LW2_1*diag(IW1_1)*(1 - a1.*a1);
    
    % Output 3
    Y_ddot{1,ts} = -LW2_1*diag(IW1_1)*2*(a1 - a1.*a1.*a1);
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX
  Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
  y = bsxfun(@minus,x,settings.xoffset);
  y = bsxfun(@times,y,settings.gain);
  y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
  x = bsxfun(@minus,y,settings.ymin);
  x = bsxfun(@rdivide,x,settings.gain);
  x = bsxfun(@plus,x,settings.xoffset);
end
