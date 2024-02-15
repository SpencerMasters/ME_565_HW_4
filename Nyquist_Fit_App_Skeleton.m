function  Nyquist_Fit_App
%NYQUIST_FIT_APP: The UI will automatically load and plot experimental data
%from 'chargeEIS01MBCA3.mat'. Using the sliders, students will be able to
%visualize the effect of each parameter on EIS results. Using the 'Fit me'
%button, the data will be fitted using a built-in, global search and
%multi-start optimization scheme. The resulting curve will be plotted on
%the main plot and the fitted parameters will be returned as 'p' and
%displayed in the command window. In the "calc_nyquist" function, an
%OCV-R-RC example has already been implemented. As a bonus problem,
%students will fill in the missing code for an OCV-R-RC-RC-L-Z model
%(Lines 122-123).

%% Create figure window
close(findall(0, 'type', 'figure')) % close previous uifigures
global p ax2
fig = uifigure('Position',[0 0 1000 600]); %position: [left bottom width height]
fig.Name = "Nyquist plot and fit ME565";
fig2=figure(2);
ax2(1) = subplot(2,1,1);
ax2(2) = subplot(2,1,2);


%% load experimental data
load('chargeEIS01MBCA3.mat'); 

%% define default slider parameters

p.Rs=0.013;
p.R1=0.005;
p.tau1=.01;
p.R2=0.015;
p.tau2=.1;
p.Aw=1e-3;
p.alpha_over_Q=1/(2*3600);
p.L=1e-7;
p.Zdata_real=chargeEIS01MBCA3.ReZOhm;
p.Zdata_imag=chargeEIS01MBCA3.ImZOhm;
p.Zdata_freq_Hz=chargeEIS01MBCA3.freqHz;

%% Add UI elements

% main plot
ax = axes('Parent',fig,'position',[0.13 0.42  0.77 0.54]); 


% Rs slider
s = uislider(fig,'Position',[50 200 250 3],...
    'ValueChangedFcn',@(s,event) updateRs(s,ax));
s.Value = p.Rs;
s.Limits = [0 .05];
uilabel(fig, 'Text','Rs:','FontSize', 14, 'FontWeight', 'bold','Position', [s.Position(1:2)+[-30 -5] 80 20]);

% L slider
sL = uislider(fig,'Position',[400 200 250 3],...
    'ValueChangedFcn',@(sL,event) updateL(sL,ax));
sL.Value = p.L;
sL.Limits = [0 1e-6];
uilabel(fig, 'Text','L:','FontSize', 14, 'FontWeight', 'bold','Position', [sL.Position(1:2)+[-30 -5] 80 20]);

% Aw slider
sAw = uislider(fig,'Position',[750 200 200 3],...
    'ValueChangedFcn',@(sAw,event) updateAw(sAw,ax));
sAw.Value = p.Aw;
sAw.Limits = [0 .01];
uilabel(fig, 'Text','Aw:','FontSize', 14, 'FontWeight', 'bold','Position', [sAw.Position(1:2)+[-30 -5] 80 20]);

% Alpha slider
salpha = uislider(fig,'Position',[750 150 200 3],...
    'ValueChangedFcn',@(salpha,event) updatealpha(salpha,ax));
salpha.Value = p.alpha_over_Q;
salpha.Limits = [0 .005];
uilabel(fig, 'Text','Alpha:','FontSize', 14, 'FontWeight', 'bold','Position', [salpha.Position(1:2)+[-50 -5] 80 20]);

% R1 slider
sR1 = uislider(fig,'Position',[50 150 250 3],...
    'ValueChangedFcn',@(sR1,event) updateR1(sR1,ax));
sR1.Value = p.R1;
sR1.Limits = [0 .05];
uilabel(fig, 'Text','R1:','FontSize', 14, 'FontWeight', 'bold','Position', [sR1.Position(1:2)+[-30 -5] 80 20]);

% R2 slider
sR2 = uislider(fig,'Position',[400 150 250 3],...
    'ValueChangedFcn',@(sR2,event) updateR2(sR2,ax));
sR2.Value = p.R2;
sR2.Limits = [0 .02];
uilabel(fig, 'Text','R2:','FontSize', 14, 'FontWeight', 'bold','Position', [sR2.Position(1:2)+[-30 -5] 80 20]);

% Tau 1 slider
sTau1 = uislider(fig,'Position',[50 100 250 3],...
    'ValueChangedFcn',@(sTau1,event) updateTau1(sTau1,ax));
sTau1.Value = p.tau1;
sTau1.Limits = [0 .1];
uilabel(fig, 'Text','Tau 1:','FontSize', 14, 'FontWeight', 'bold','Position', [sTau1.Position(1:2)+[-45 -5] 80 20]);

% Tau 2 slider
sTau2 = uislider(fig,'Position',[400 100 250 3],...
    'ValueChangedFcn',@(sTau2,event) updateTau2(sTau2,ax));
sTau2.Value = p.tau2;
sTau2.Limits = [0 1];
uilabel(fig, 'Text','Tau 2:','FontSize', 14, 'FontWeight', 'bold','Position', [sTau2.Position(1:2)+[-45 -5] 80 20]);

% Function fitting button
b = uibutton(fig,'Push',...
    'Position',[100, 20, 100, 22],...
               'ButtonPushedFcn', @(btn,event) plotButtonPushed(btn,ax));
b.Text='Fit me';

%% Plot data and modeled EIS
plot_nyquist(p,ax)

end

%% Function definitions

function [stacked_data,Z_real,Z_imag]=calc_nyquist(Rs,R1,tau1,R2,tau2,Aw,alpha_over_Q,L,w)

   % OCV-R-RC example
   Z_real=Rs + R1./(tau1^2*w.^2 + 1);
   Z_imag=alpha_over_Q./w + (R1*tau1*w)./(tau1^2*w.^2 + 1);

   % TO-DO: Replace with the OCV-R-RC-RC-L-Z model
%    Z_real=?;
%    Z_imag=?;
   stacked_data=[Z_real;Z_imag];
end

function plot_nyquist(p,ax)
    %global p ax
    global ax2
    [stacked_data,Z_real,Z_imag]=calc_nyquist(p.Rs,p.R1,p.tau1,p.R2,p.tau2,p.Aw,p.alpha_over_Q,p.L,p.Zdata_freq_Hz*2*pi);
    plot(ax,p.Zdata_real,p.Zdata_imag,'o',Z_real,Z_imag,'.-')
    %xlim(ax,[min(p.Zdata_real) max(p.Zdata_real)])
    %ylim(ax,[min(p.Zdata_imag) max(p.Zdata_imag)])
    xlabel(ax,'Real {Z} (\Omega)')
    ylabel(ax,'Imag {Z} (\Omega)')
    
    mag_data=20*log10(sqrt(-p.Zdata_real.^2+p.Zdata_imag.^2));
    phase_data=atan(-p.Zdata_imag./p.Zdata_real)*90/pi;
    
    mag_fit=20*log10(sqrt(-Z_real.^2+Z_imag.^2));
    phase_fit=atan(-Z_imag./Z_real)*90/pi;
    semilogx(ax2(1),p.Zdata_freq_Hz,mag_data,'o',p.Zdata_freq_Hz,mag_fit,'.-')
    semilogx(ax2(2),p.Zdata_freq_Hz,phase_data,'o',p.Zdata_freq_Hz,phase_fit,'.-')
    %xlim(ax,[min(p.Zdata_real) max(p.Zdata_real)])
    %ylim(ax,[min(p.Zdata_imag) max(p.Zdata_imag)])
    xlabel(ax2(2),'Frequency (Hz)')
    ylabel(ax2(1),'Mag Z (dB)')
    ylabel(ax2(2),'phase Z (deg)')
    
end

function x=fit_nyquist(ax)
    global p
    x0=[p.Rs,p.R1,p.tau1,p.R2,p.tau2,p.Aw,p.alpha_over_Q,p.L];
   lb = [0,0,1e-6,0,1e-5,-100,0,0 ];
    ub = [1,1,20,1,2e3,100,1000,1e-2 ];
 
    x=lsqcurvefit(@(x,xdata) calc_nyquist(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),xdata),x0,p.Zdata_freq_Hz*2*pi,[p.Zdata_real;p.Zdata_imag],lb,ub );
    
    if(0)
        problem = createOptimProblem('lsqcurvefit','x0',x0,'objective',@(x,xdata) 1000*[calc_nyquist(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),xdata)],...
            'lb',lb,'ub',ub,'xdata',p.Zdata_freq_Hz*2*pi,'ydata',1000*[p.Zdata_real;p.Zdata_imag]);
        ms = MultiStart('PlotFcns',@gsplotbestf);
        [xmulti,errormulti] = run(ms,problem,1000)
        x=xmulti;
    end
    
    p.Rs=x(1);
    p.R1=x(2);
    p.tau1=x(3);
    p.R2=x(4);
    p.tau2=x(5);
    p.Aw=x(6);
    p.alpha_over_Q=x(7);
    p.L=x(8);
    plot_nyquist(p,ax);

end

function updateRs(s,ax)
    global p
    p.Rs=s.Value;
    plot_nyquist(p,ax)
end

function updateL(s,ax)
    global p
    p.L=s.Value;
    plot_nyquist(p,ax)
end

function updateR1(s,ax)
    global p
    p.R1=s.Value;
    plot_nyquist(p,ax)
end


function updateR2(s,ax)
    global p
    p.R2=s.Value;
    plot_nyquist(p,ax)
end


function updateTau1(s,ax)
    global p
    p.tau1=s.Value;
    plot_nyquist(p,ax)
end

function updateTau2(s,ax)
    global p
    p.tau2=s.Value;
    plot_nyquist(p,ax)
end

function updateAw(s,ax)
    global p
    p.Aw=s.Value;
    plot_nyquist(p,ax)
end

function updatealpha(s,ax)
    global p
    p.alpha_over_Q=s.Value;
    plot_nyquist(p,ax)
end


% Create the function for the ButtonPushedFcn callback
function plotButtonPushed(btn,ax)
      x=fit_nyquist(ax);
end

