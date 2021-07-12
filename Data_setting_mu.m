% Setting the means of the demand distribution
mus=(lb+ub)/2;

% Setting the parameter of mean absolute deviation 

% Setting the worst_case probabilities
Probabilities_matrix_mu=zeros(T,2);

Probabilities_matrix_mu(:,1) = (ub(2:T+1) - mus(2:T+1))./(ub(2:T+1) - lb(2:T+1));
Probabilities_matrix_mu(:,2) = (mus(2:T+1) - lb(2:T+1))./(ub(2:T+1) - lb(2:T+1));

% Setting the demand scenarios
Scenarios_mu = [lb(2:T+1) ub(2:T+1)];

Demands_scenarios_mu = zeros(T+1,2^T);
Demand_probabilities_mu = zeros(1,2^T);

% Filling the preallocated matrices
for iterate_scenario=0:2^T-1
    % Manipulations to get the coordinates
    vec=dec2base(iterate_scenario,2);
    vec=strcat(repmat('0',[1,T-length(vec)]),vec);
    Positions=[[1:T]'  abs(vec)'-47];
    Positions=mat2cell(Positions, size(Positions, 1), ones(1, size(Positions, 2)));
    % Setting the w-c demand scenario and its probability
    Demands_scenarios_mu(:,iterate_scenario+1) = [1; Scenarios_mu(sub2ind(size(Scenarios_mu), Positions{:}))];
    Demand_probabilities_mu(iterate_scenario+1) = prod(Probabilities_matrix_mu(sub2ind(size(Probabilities_matrix_mu), Positions{:})));
end