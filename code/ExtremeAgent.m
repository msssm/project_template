classdef ExtremeAgent
    properties
        opinion
        u
        mu
        kappa
        p
    end
    methods
        function obj = ExtremeAgent(dist)
            u = 0
            mu = 0
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