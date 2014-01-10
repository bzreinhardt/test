classdef Xpcsettings < hgsetget
    %Xpc settings setup and record the experimental run
%     This is a dangerous class - only have one for each block diagram in the workspace,
%       otherwise, things could get out of synch
    
    properties
        names = {'A','X','P','H','Q','R','Value'}; %what they are called in simulink
        params = {'A','X','P','H','Q','R','v0'}; %default parameter keys
        blocks = {'Kalman Filter','Kalman Filter','Kalman Filter','Kalman Filter','Kalman Filter','Kalman Filter', 'V_a_0'};
        namePairs;
        blockPairs;
        settings;
        filename;
    end
    
    methods
        function obj = Xpcsettings(fileName,varargin)
           obj.filename = fileName;
           %TODO probably need to catch some errors here
           if (nargin == 4)
               obj.params = varargin{1};
               obj.names = varargin{2};
               obj.blocks = varargin{3};
           elseif (nargin == 5)
               obj.params = varargin{1};
               obj.names = varargin{2};
               obj.blocks = varargin{3};
               vals = varargin{4};
           end
           obj.namePairs = containers.Map(obj.params,obj.names);
           obj.blockPairs = containers.Map(obj.params,obj.blocks);
           if(exist('vals','var') == 1) 
               obj.settings = containers.Map(obj.params,vals);
               for i = 1:length(obj.params)
                   %if the parameter vals are specified, record and set the
                   %block parameters to be the specified values
                   block = strcat(obj.filename,obj.blockPairs(obj.params{i}));
                   set_param(block,obj.namePairs(obj.params{i}),mat2str(obj.settings(obj.params{i})));
                   
               end
           else
               for i = 1:length(obj.params)
                   %if the parameter values are not specified, pull the
                   %existing values from the simulink block diagram
                   block = strcat(obj.filename,obj.blockPairs(obj.params{i}));
                   values{i} = str2num(get_param(block,obj.namePairs(obj.params{i}))); 
                   
               end
               obj.settings = containers.Map(obj.params,values);
           end
               
            
        end
        
        function val = get2(obj, param)
            %retrieves the value from the settings
            val = obj.settings(param);
        end

        function setParam(obj, param, val)
            %sets the given parameter to the given value
            block = strcat(obj.filename,obj.blockPairs(param));
            set_param(block,obj.namePairs(param),mat2str(val));
            obj.settings(param) = val;
            
        end
        
        function val = getParam(obj, param)
            %gets the value of the given existing parameter from the
            %simulink diagram and updates the stored values
            block = strcat(obj.filename,obj.blockPairs(param));
            val = str2num(get_param(block, obj.namePairs(param)));
            obj.settings(param) = val;
    
        end
    end
    
end
    


