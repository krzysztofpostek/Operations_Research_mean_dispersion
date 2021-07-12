% This file runs the simulation of various instances of the inventory
% problem. 
rho = 0.2;
T=6;
N_instances=50;
Objectives_worst_case = zeros(N_instances,5);
Objectives_worst_case_expectation = zeros(N_instances,4);
N_sim=10^4;
Results_simulation_uniform = zeros(N_sim,9,N_instances);
Results_simulation_mu_d = zeros(N_sim,9,N_instances);
Results_simulation_mu = zeros(N_sim,9,N_instances);
rng(1989,'twister');

for iterate_instance = 1:N_instances
    Data_setting;
    sampled_demands_uniform = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_scenarios_01_uniform;
    sampled_demands_mu_d = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_01_mu_d;
    sampled_demands_mu = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_01_mu;
    
    % Solve the adjustable robust problem and insert data
    cvx_clear;
    ARO;
    Objectives_worst_case(iterate_instance,2) = cvx_optval;
    objective_limit = cvx_optval;
    
    Average_case_refinement_for_ARO_mu_based;
    Objectives_worst_case_expectation(iterate_instance,1) = cvx_optval;
    
    for iterate_simulate = 1:N_sim
        Orders = double(Ordering_LDR)*sampled_demands_uniform(:,iterate_simulate);
        Results_simulation_uniform(iterate_simulate,4,iterate_instance) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate))),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0));
        Orders = double(Ordering_LDR)*sampled_demands_mu_d(:,iterate_simulate);
        Results_simulation_mu_d(iterate_simulate,4,iterate_instance) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate))),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0));
        Orders = double(Ordering_LDR)*sampled_demands_mu(:,iterate_simulate);
        Results_simulation_mu(iterate_simulate,4,iterate_instance) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate))),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate)),0));
    end
    
    % Solver the nonadjustable mu-d problem insert data
    cvx_clear;
    Nonadjustable_mu;
    objective_limit = cvx_optval;
    Objectives_worst_case_expectation(iterate_instance,2) = cvx_optval;
    
    for iterate_simulate = 1:N_sim
        Orders = reshape(Ordering_LDR,[T+1 T])' * sampled_demands_uniform(:,iterate_simulate);
        Results_simulation_uniform(iterate_simulate,5,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0));
        Orders = reshape(Ordering_LDR,[T+1 T])' * sampled_demands_mu_d(:,iterate_simulate);
        Results_simulation_mu_d(iterate_simulate,5,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0));
        Orders = reshape(Ordering_LDR,[T+1 T])' * sampled_demands_mu(:,iterate_simulate);
        Results_simulation_mu(iterate_simulate,5,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate)),0));
    end
    
    Robust_refinement_for_nonadjustable_mu;
    Objectives_worst_case(iterate_instance,3) = cvx_optval;
    
    for iterate_simulate = 1:N_sim
        Orders = Ordering_LDR * sampled_demands_uniform(:,iterate_simulate);
        Results_simulation_uniform(iterate_simulate,6,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0));
        Orders = Ordering_LDR * sampled_demands_mu_d(:,iterate_simulate);
        Results_simulation_mu_d(iterate_simulate,6,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0));
        Orders = Ordering_LDR * sampled_demands_mu(:,iterate_simulate);
        Results_simulation_mu(iterate_simulate,6,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate)),0));
    end
    
    % Solver the adjustable mu-d problem and insert data
    cvx_clear;
    Adjustable_mu;
    objective_limit = cvx_optval;
    Objectives_worst_case_expectation(iterate_instance,3) = cvx_optval;
    
    for iterate_simulate = 1:N_sim
        Orders = reshape(Ordering_LDR,[T+1 T])' * sampled_demands_uniform(:,iterate_simulate);
        Results_simulation_uniform(iterate_simulate,7,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0));
        Orders = reshape(Ordering_LDR,[T+1 T])' * sampled_demands_mu_d(:,iterate_simulate);
        Results_simulation_mu_d(iterate_simulate,7,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0));
        Orders = reshape(Ordering_LDR,[T+1 T])' * sampled_demands_mu(:,iterate_simulate);
        Results_simulation_mu(iterate_simulate,7,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate)),0));
    end
    
    Robust_refinement_for_adjustable_mu_d;
    Objectives_worst_case(iterate_instance,4) = cvx_optval;
    
    for iterate_simulate = 1:N_sim
        Orders = Ordering_LDR * sampled_demands_uniform(:,iterate_simulate);
        Results_simulation_uniform(iterate_simulate,8,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0));
        Orders = Ordering_LDR * sampled_demands_mu_d(:,iterate_simulate);
        Results_simulation_mu_d(iterate_simulate,8,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0));
        Orders = Ordering_LDR * sampled_demands_mu(:,iterate_simulate);
        Results_simulation_mu(iterate_simulate,8,iterate_instance) = c'*Orders + sum(p.*max(-x_1 -cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu(2:T+1,iterate_simulate)),0));
    end
    
end
