classdef Controller < hgsetget
    %contains properties and methods of the closed/open loop controller
    
    properties
        filename; %name of the model
%         freq; %frequency of the input sine wave
%         phase;%phase shift between the two sets of magnets
%         P; %proportional gain
%         D; %derivative gain
%         I; %integral gain
%         x_0; %target position
        settings;
    end
    
    methods
        function obj = Controller(fileName)
            % right now, filename needs to have a / at the end
            %making the controller requires
            
            %TODO make it so filename format is more flexible
            %TODO, make it so it is optional for the simulink model to have
            %the desired parameters
            obj.settings = containers.Map();
            obj.filename = fileName;
            params = {'freq','phase','P','D','I','x_0'};
            %check whether you're using a PID controller block or
            %individual gains
            PID = find_system(fileName,'Name',...
                'Discrete PID Controller');
            for i = 1:length(params)
                switch params{i}
                    case 'freq'
                        %gets relevent parameters of the kalman filter
                        name = strcat(fileName,'Sine Wave1');
                        
                        freq = get_param(name,'Frequency'); %transition matrix
                        
                        obj.settings('freq') = str2num(freq);
                    case 'phase'
                        %gets zero setting for acceleration
                        name = strcat(fileName,'Sine Wave2');
                        phase = get_param(name,'Phase');
                        obj.settings('phase') = str2num(phase);
                    case 'P'
                        if length(PID) == 1
                            name = strcat(fileName,'Discrete PID Controller');
                            P = get_param(name,'P');
                        else
                            name = strcat(fileName,'P Gain');
                            P = get_param(name,'Gain');
                        end
                        obj.settings('P') = str2num(P);
                    case 'D'
                        if length(PID) == 1
                            name = strcat(fileName,'Discrete PID Controller');
                            D = get_param(name,'D');
                        else
                            name = strcat(fileName,'D Gain');
                            D = get_param(name,'Gain');
                        end
                        obj.settings('D') = str2num(D);
                    case 'I'
                        if length(PID) == 1
                            name = strcat(fileName,'Discrete PID Controller');
                            I = get_param(name,'I');
                        else
                            name = strcat(fileName,'I Gain');
                            I = get_param(name,'Gain');
                        end
                        obj.settings('I') = str2num(I);
                    case 'x_0'
                        name = strcat(fileName,'x_0');
                        target = get_param(name,'Value');
                        obj.settings('x_0') = str2num(target);
                    otherwise
                        warning(strcat('Unrecognized argument: ', params{i}));
                        
                end
            end
        end
        
        function val = get2(obj, param)
            %gets the parameter in question from the controler
            val = obj.settings(param);
        end
        
        function val = getParam(obj, param)
            %gets the parameter from the actual model
            switch param
                    case 'freq'
                        %gets relevent parameters of the kalman filter
                        name = strcat(obj.filename,'Sine Wave1');
                        
                        freq = get_param(name,'Frequency'); %transition matrix
                        
                        obj.settings('freq') = str2num(freq);
                        val = str2num(freq);
                    case 'phase'
                        %gets zero setting for acceleration
                        name = strcat(obj.filename,'Sine Wave2');
                        phase = get_param(name,'Phase');
                        obj.settings('phase') = str2num(phase);
                        val = str2num(phase);
                    case 'P'
                        name = strcat(obj.filename,'P Gain');
                        P = get_param(name,'Gain');
                        obj.settings('P') = str2num(P);
                        val = str2num(P);
                    case 'D'
                        name = strcat(obj.filename,'D Gain');
                        D = get_param(name,'Gain');
                        obj.settings('D') = str2num(D);
                        val = str2num(D);
                    case 'I'
                        name = strcat(obj.filename,'I Gain');
                        I = get_param(name,'Gain');
                        obj.settings('I') = str2num(I);
                        val = str2num(I);
                    case 'x_0'
                        name = strcat(obj.filename,'x_0');
                        target = get_param(name,'Value');
                        obj.settings('x_0') = str2num(target);
                        val = str2num(target);
                    otherwise
                        warning(strcat('Unrecognized argument: ',param));
                        val = NaN;
                        
            end
        end
    
        function setParam(obj,param,val)
            %set the parameters in the model to match the object parameters
            %valid for 'freq','phase','P','D','I','x_0'
%                 if strcmp(params,'all')
%                     params = ['freq','phase','P','D','I','x_0'];
%                 end
%             for i = 1:length(params)
                
                switch param
                    case 'freq'
                        %gets relevent parameters of the kalman filter
                        name = strcat(obj.filename,'Sine Wave1');
                        freq = mat2str(val); 
                        set_param(name,'Frequency',freq); %transition matrix
                        
                        
                    case 'phase'
                        %gets zero setting for acceleration
                        name = strcat(obj.filename,'Sine Wave2');
                        phase = mat2str(val); 
                        set_param(name,'Phase',phase);
                    case 'P'
                        name = strcat(obj.filename,'P Gain');
                        gain = mat2str(val); 
                        set_param(name,'Gain',gain);
                    case 'D'
                        name = strcat(obj.filename,'D Gain');
                        gain = mat2str(val); 
                        set_param(name,'Gain',gain);
                    case 'I'
                        name = strcat(obj.filename,'I Gain');
                        gain = mat2str(val); 
                        set_param(name,'Gain',gain);
                    case 'x_0'
                        name = strcat(obj.filename,'x_0');
                        tar = mat2str(val); 
                        set_param(name,'Value',tar);
                    otherwise
                        warning(strcat('Unrecognized argument: ', param));
                   
                        
                end
            end
            obj.getParam(param);
%         end
        
        
    
    end
end

