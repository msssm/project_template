classdef ExtremeAgent
    properties
         % all properties in [0,1]
        opinion
        u
        mu
        kappa
        p
    end
    methods
        function obj = ExtremeAgent(dist)
            % fix properties to constants
            u = 0
            mu = 0
             % set distribution of random number
            if STRCMP(dist, 'Normal')
                kappa = randn
                opinion = randn
            else 
                kappa = rand
                opinion = rand
            end
        end
    end
end