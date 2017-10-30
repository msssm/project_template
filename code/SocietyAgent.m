classdef SocietyAgent
    properties
        % all properties in [0,1]
        opinion
        u
        mu
        kappa
        p
    end
    methods
        function obj = SocietyAgent(dist)
            % set distribution of random number
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