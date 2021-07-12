% This file solves the fully adjustable version of the problem

% Allocating the matrices with coefficients for the maximum terms.
Demand_coefficients_holding = h - ([1:T]' == T)*s;
Demand_coefficients_backlogging = p;

Demand_scenarios_binary = zeros(T,2^T);
Equality_constraints_binary = ones(2^T-1,1);

% Now we establish the equality constraints between various decision
% vectors, based on their corresponding scenarios

for iterate_scenario=0:2^T-1
    % Manipulations to get the coordinates
    vec = dec2base(iterate_scenario,2);
    vec = strcat(repmat('0',[1,T-length(vec)]),vec);
    Positions= abs(vec)'-48;
    
    % Setting the relevant demand scenario value
    Demand_scenarios_binary(:,iterate_scenario+1) = lb(2:T+1)+(ub(2:T+1)-lb(2:T+1)).*[Positions];
    
    if(iterate_scenario>0)
        for i=1:T-1
            % Condition that if the first i outcomes of a scenario are the
            % same, then the corresponding decision vectors should be the
            % same up to time i+1
            if(prod(double(Demand_scenarios_binary(1:i,iterate_scenario)==Demand_scenarios_binary(1:i,iterate_scenario+1))) > 0)
                Equality_constraints_binary(iterate_scenario) = i+1;
            end
        end
    end
end

% Defining the optimization file
cvx_begin
    % Ordering variables
    variable q(T,2^T) nonnegative
    % Objective proxy variables
    variable objective_proxy
    
    minimize(objective_proxy)
    subject to
        % The objective constraints
        max(c'*q + sum(repmat(Demand_coefficients_holding,[1 2^T]).*max((x_1+cumsum(q-Demand_scenarios_binary)),0) + repmat(Demand_coefficients_backlogging,[1 2^T] ).*max((-x_1-cumsum(q-Demand_scenarios_binary)),0))) <= objective_proxy;
        
        % The purchase size constraints
        q <= repmat(U,[1 2^T]);
        q >= repmat(L,[1 2^T]);
        
        % The cumulative purchase constraints
        cumsum(q) <= repmat(U_cum,[1 2^T]);
        cumsum(q) >= repmat(L_cum,[1 2^T]);
        
        % Equality constraints between decision vectors
        for iterate_scenario=0:2^T-2
            q(1:Equality_constraints_binary(iterate_scenario+1),iterate_scenario+1)==q(1:Equality_constraints_binary(iterate_scenario+1),iterate_scenario+2);
        end
cvx_end
