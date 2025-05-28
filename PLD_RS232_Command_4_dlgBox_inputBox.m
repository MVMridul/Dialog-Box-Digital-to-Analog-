
% ---------------------------------------------
%                  By Mridul Verma
%            MOS Lab , IIT Hyderabad, India
% ---------------------------------------------


clc
clear all
close all
format compact





% ---------------------------------------------
%%                  Program
% ---------------------------------------------



choice = 'Yes';


while 1
answer = questdlg('Choose the type of calculation', ...
	'PLD RS232 Terminal Command Menu', ...
	'Pulse Width: Analog to Digital','Pulse Power: Analog to Digital','Digital to Analog: Power & Energy', 'Digital to Analog: Power & Energy');


% Response
switch answer
    case 'Pulse Width: Analog to Digital'
        digit_width = PwidthToDigital();
        
    case 'Pulse Power: Analog to Digital'
        digit_optPower = PpowerToDigital();
        
    case 'Digital to Analog: Power & Energy'
        [output_power, output_energy] = DigitalToPE();
end

% while loop question
choice = questdlg('Go back to Calculations?','Choose','Yes','No','No');
    if isequal(choice,'No')
        break;
    end
   
% % response to open Trigger vi file
% switch choice
%     case 'Run Trigger window (.vi)'
%         e=actxserver('LabVIEW.Application');
%         vipath='D:\PhotoSound_Legion\labview_mridul\Trigger_input_Laser_Counter_Continuous_Output.vi';
%         vi=invoke(e,'GetVIReference',vipath);  
%         %!start D:\PhotoSound_Legion\labview_mridul\Trigger_input_Laser_Counter_Continuous_Output.vi
%         vi.Run;       
% end

end

fprintf(2, '\n<strong>****************************** End of Program ******************************</strong>\n')

% ---------------------------------------------
%                  Functions
% ---------------------------------------------


%% Pulse Width
function digital_width = PwidthToDigital()

prompt = {'Required Pulse Width [30 ns - 100 ns]:'};
dlgtitle = 'Pulse Width (ns)';
fieldsize = [1 45];
answer = inputdlg(prompt,dlgtitle,fieldsize);

width = str2num(answer{1});

digital_width = interp1([30,100], [0,1000], width);

msg = cell(3,1);
msg{1} = sprintf('For Pulse Width = %.2f ns \n', width);
msg{2} = sprintf('Digital value for Pulse Width = %.3f \n', digital_width);
msg{3} = sprintf('RS232 command = widL %3.3f ', digital_width);

waitfor(msgbox(msg, 'PW'));

%waitfor(msgbox({sprintf('For Pulse Width = %.2f ns \n', width) ; sprintf('Digital value for Pulse Width = %.3f \n', digital_width) ;  sprintf('RS232 command: widL %3.3f ', digital_width)}, 'PW'));


end

%% Optical Peak Power
function digital_optPower = PpowerToDigital()

prompt = {'Required Optical Peak Power [40 W - 200 W]:'};
dlgtitle = 'Optical Power(W)';
fieldsize = [1 45];
answer = inputdlg(prompt,dlgtitle,fieldsize);

optPower = str2num(answer{1});

digital_optPower = interp1([40,200], [0,1000], optPower);

energy_here = interp1([0,1000],[1200,20000], digital_optPower);

msg = cell(4,1);
msg{1} = sprintf('For Optical Peak Power = %.2f W \n', optPower);
msg{2} = sprintf('Digital value for Peak Power = %3.3f \n', digital_optPower);
msg{3} = sprintf('RS232 command = powL %3.3f \n', digital_optPower);
msg{4} = sprintf('Pulse Energy corresponding to %3.3f Digital Value = %3.3f nJ \n', digital_optPower, energy_here');

waitfor(msgbox(msg, 'Power'));

end



%% Digital input for Pulse energy and Power
function [out_power, out_energy] = DigitalToPE()

prompt = {'Required Digital Input [0 - 1000]:'};
dlgtitle = 'Digital to Analog';
fieldsize = [1 45];
answer = inputdlg(prompt,dlgtitle,fieldsize);

digital_input = str2num(answer{1});

out_power = interp1([0,1000],[40, 200], digital_input);
out_energy = interp1([0,1000],[1200,20000], digital_input);

msg = cell(3,1);
msg{1} = sprintf('For Digital Input = %.2f \n', digital_input);
msg{2} = sprintf('Peak Optical Power = %3.3f W \n', out_power);
msg{3} = sprintf('Pulse Energy = %3.3f nJ \n', out_energy);

waitfor(msgbox(msg, 'DAC'));

end



%% Pulse Energy
function digital_energy = PenergyToDigital()

prompt = {'Required Pulse energy (nJ):'};
dlgtitle = 'Pulse Energy [1200 nJ - 20,000 nJ]';
fieldsize = [1 12];
answer = inputdlg(prompt,dlgtitle,fieldsize)

energy = str2num(answer{1});

digital_energy = interp1([1200,20000], [0,1000], energy);

power_here = interp1([0,1000],[40,200], digital_energy);

h = msgbox([sprintf('Required energy in mJ = %f mJ \n', energy*1E-6) ; sprintf('Digital value for Pulse energy = <strong>%3.3f</strong> \n', digital_energy) ; sprintf('\n<strong> Optical Peak Power corresponding to %3.3f Digital Value </strong> : %3.3f W\n', digital_energy, power_here)]);

end