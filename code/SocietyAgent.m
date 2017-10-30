classdef SocietyAgent
    properties
        opinion
        u
        mu
        kappa
        p
    end
    methods
        function obj = SocietyAgent(dist)
            if STRCMP(dist, 'Normal')
                u = randn
                mu = randn
                kappa = randn
                opinion = randn
            else 
                u = rand
                mu = rand
                kappa = rand
                opinion = rand
            end
        end
    end
end