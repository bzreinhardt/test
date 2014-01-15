%TODO - make sure the number of samples on the scopes is synchronized
%TODO - make it so that it will initialize its own controller and xpc
%properties if you just give it a filename
classdef MagExperiment < Experiment 
    %MagExperiment class keeps track of air track experiments with the setup
    %as of 12-16-2013
    %   Detailed explanation goes here
    
    properties
        %outData = 0; %data commanded to the v_out of the DAQ card 
        %stateData = 0; % the state of the cart in the time domain
        %currData = 0; %the voltage through the current probes on the output from the amplifier
        %freq = -1; %frequency of signal through magnets
        %phase = -1;% phase difference between the front and side magnets
        R = 2.5; %resistance of the inductor circuit in question
        L = -1; %inductance of inductors in actuator circuit
        trackAngle = 1*pi/180; %angle of the track in radians positive angles tilt towards the actuator
        mCart = .225; % mass of the cart in kg
        settings; %settings in the simulink target
        controller; %controller used in the experiment (make controller class)
    end
    
    methods(Static)
        function current = convCur(V)
            %converts voltages from the LTSR 15 NP to values in Amps
            current = (V-2.5)*15/0.625;
        end
        
    end
    
    methods
        
        function obj = MagExperiment(varargin)
            %need switch statement to call to superclass
            super_args = {};
            len = 0;
            i = 1;
            while i <= nargin
                
                if isa(varargin{i},'Controller')
                    cont = varargin{i};
                    i = i + 1;
                elseif isa(varargin{i}, 'Xpcsettings')
                    settings = varargin{i};
                    i = i+1;
                elseif strcmp(varargin{i}(length(varargin{i})),'/')
                    filename = varargin{i};
                    i = i + 1;
                else 
      
                    %pass everything else to the experiment constructor 
                    len = len +1;
                    super_args{len} = varargin{i};
                    len = len+1;
                    i = i + 1;
                    super_args{len} = varargin{i};
                    i = i + 1;
                end
            end
            
            obj = obj@Experiment(super_args);
            
            if exist('cont','var') == 1
                obj.controller = cont;
            else 
                obj.controller = Controller(filename);
            end
            if exist('settings','var') == 1
                obj.settings = settings;
            else
                obj.settings = Xpcsettings(filename);
            end
            
        end
        
        
        
        function F = getForce(obj)
            g = 9.81; %gravity, duh
            F = obj.mCart*(obj.stateData(:,1)-g*sin(obj.trackAngle));
        end
        
        function xpcRun(obj,scopes)
            %runs an xpc experiment
            %TODO decide system for what scope corresponds to what all the
            %time
            %scope 1 reserved for xpc display
            %scope 2 is raw state voltage data
            %scope 3 is current through EMs
            %scope 4 is the commanded voltage output
            %scope 5 is the filtered state data
            %scope 6 is the unfiltered but converted state data
            sysName = obj.settings.filename;
            open_system(sysName);                   % Open the model
            set_param(sysName,'RTWVerbose','off');  % Configure RTW for a non-Verbose build
            rtwbuild(sysName);                      % Build and download to the target PC
            % close_system('sosModel3_mod',0);                % Close the model
            tg = xpc;                                   % Create an xPC Target Object
            start(tg);                                  % Start xPC Target Object (run the model)

            % Wait until model has finished running.
            while ~strcmpi(tg.Status,'stopped');        % Is the run complete?
            end;
            for i = 1:length(scopes)
                scope = getscope(tg,scopes(1));
                obj.time = scope.time;
                switch scopes(i)
                    
                    case 2
                        sc2 = getscope(tg,2);
                        obj.data('rawState') = sc2.data;
                    case 3
                        sc3 = getscope(tg,3);
                        obj.data('rawCur') = sc3.data;
                    case 4
                        sc4 = getscope(tg,4);
                        obj.data('outV') = sc4.data;
                    case 5
                        sc5 = getscope(tg,5);
                        obj.data('filtState') = sc5.data;
                    case 6
                        sc6 = getscope(tg,6);
                        obj.data('unfiltState') = sc6.data;
                end
            end
        end
        
        function simRun(obj)
            filename = obj.settings.filename;
         
%             %simOut = sim(filename,...
%             'StopTime', '3', ... 
%             'SaveTime','on','TimeSaveName','tout', ...
%             'SaveOutput','on','OutputSaveName','youtNew',...
%             'SignalLogging','on','SignalLoggingName','logsout');
        end
        
        
    end
    
end

