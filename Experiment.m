%TODO - update plotting

classdef Experiment < hgsetget
    %Experiment class keeps track of air track experiments with the setup
    %as of 12-16-2013
    %   Detailed explanation goes here
    
    properties
        time = 0; %time vector of the experiment
        data; %holds time series data from the experiment
        notes = {'none'}; %keeps track of any notes on the experiment
        
    end
    
    
    methods
        function obj = Experiment(varargin)
            %either call with zero arguments or dataName, data pairs, the
            %time values should be name 't'
            obj.data = containers.Map();
            if nargin == 0 || nargin == 1
                return;
            elseif mod(nargin,2) == 1
                error('constructor needs either no argument, or name value pairs');
            elseif mod(nargin,2) == 0
                for i = 1:2:nargin
                    if strcmp(varargin{i},'t') == 1
                        obj.time = varargin{i+1};
                    else
                        obj.data(varargin{i}) = varargin{i+1};
                    end
                end
            end
        end
        
        function moreData(obj,name,data)
            %adds data to the experiment
            obj.data(name) = data;
            
        end
        
        function plotE(obj,varargin)
            keylist = obj.data.keys;
            if nargin == 1
                %'main' data is the first key value pair you enter
                clf;plot(obj.time,obj.data(keylist{1}));
                
            elseif nargin > 1
                if nargin == 2 && strcmp(varargin{1},'all') == 1
                    %with argument 'all' plots all the data on their own
                    %subplots to the current figure
                    keys = obj.data.keys;
                    num = obj.data.Count;
                    clf;
                    for i = 1:obj.data.Count
                        subplot(double(num),1,double(i));
                        plot(obj.time, obj.data(keys{i}));
                        title(keys{i});
                    end
                    return;
                
                elseif mod(nargin,2) == 0 

                    error('plotE needs property value pairs');
                end
                
                fig = 0; 
                splots = 0; %number of subplots
                dat{1} = obj.data; %plot data by default
                datCalls = 0;
                diffigs = 0;
                
                for i = [1:2:nargin-1]
                    prop = varargin{i};
                    val = varargin{i+1};
                    
                    switch prop
                        case 'fig' 
                            %sets figure to plot in
                            fig = val;
                        case 'splot'
                            %sets number of subplots
                            splots = val;
                        case 'data'
                            %sets the data to be plotted in each subplot
                            %first call overrides default
                            datCalls = datCalls + 1;
                            dat{datCalls} = val;
                        case 'diffigs'
                            if val == 1
                                diffigs = 1;
                            end
                        case 'all'
                            if val == 1
                                dat = obj.data.keys;
                         
                            end       
                    end
                end
                
                if diffigs == 1
                    
                    if splots == 0
                        numFigs = length(dat);
                        for i = 1:numFigs
                            figure(fig+i);clf;plot(obj.time,obj.data(keylist{1}));
                            title(dat{i});
                        end
                        %deal with the case when you want different figs
                        %and subplots later
%                     elseif splots > 0
%                         numFigs = ciel(length(dat)/max(splots,1));
%                          for i = 1:numFigs
%                             figure(fig+1-i);clf;
%                             for j = 1:splots
%                                 subplot(splots,1,j)
%                                 plot(obj.time,obj.data(dat{i}));
%                                 title(dat{i});
%                         end
                    end
                elseif diffigs == 0
                    if fig ~= 0
                        figure(fig)
                    end
                     if length(dat) == 1
                        clf; plot(obj.time,obj.data(dat{1}));
                        title(dat{1})
                     else
                        for i = 1:length(dat)
                            clf; subplot(length(dat),1,i);
                            plot(obj.time,obj.data(dat{i}));
                            title(dat{i});
                        end
                    end
                end
                
                
                
                
               
                    
            end
        %function disp
        %function obj = print(
        end
    
    end
end

