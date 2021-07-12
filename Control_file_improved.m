
cvx_solver Gurobi;
warning('off','all');
Objectives_worst_case_mu_d_dependent = zeros(50,1);
OBJ_TRUE_WC_EXPECTATION = zeros(50,1);
OBJ_TRUE_BC_EXPECTATION = zeros(50,3);

Results_simulation_uniform = zeros(N_sim,N_instances);
Results_simulation_mu_d = zeros(N_sim,N_instances);

%Results_simulation_copula_uniform = zeros(N_sim, N_instances, length(Correlation_for_copulas));
%Results_simulation_copula_mu_d = zeros(N_sim, N_instances, length(Correlation_for_copulas));

for iterate_instance = 1:50
    
    fuckup = 0;
    
    Data_setting;
    Wiesemann_LDR_solver_improved;
    Objectives_worst_case_mu_d_dependent(iterate_instance) = cvx_optval;
    
    % Computing the true worst-case expectation under independence
    % assumption
    
    Data_setting_WCE;
    
    Ordering_decisions_for_all_scenarios = q_matrix*Demands_scenarios_mu_d + q_u_matrix * abs(Demands_scenarios_mu_d(2:T+1,:) - repmat(mus(2:T+1),[1 3^T]));
    OBJ_TRUE_WC_EXPECTATION(iterate_instance) = (c'*Ordering_decisions_for_all_scenarios + sum(repmat(Coefficients_holding,[1 3^T]).*max(0, x_1 + cumsum(Ordering_decisions_for_all_scenarios - Demands_scenarios_mu_d(2:T+1,:)))) + ...
        sum(repmat(Coefficients_backlogging,[1 3^T]).*max(0, -x_1 - cumsum(Ordering_decisions_for_all_scenarios - Demands_scenarios_mu_d(2:T+1,:)))) )*Demand_probabilities_mu_d';
    
    % Computing the true best-case expectation under independence
    % assumption
    
    for iterate_beta = 1:3
        
        beta_vector = (0.25 + (iterate_beta-1)*0.25)*ones(T,1);
        
        Data_setting_BCE;
        
        Ordering_decisions_for_all_scenarios = q_matrix*Demands_scenarios_best_case + q_u_matrix * abs(Demands_scenarios_best_case(2:T+1,:) - repmat(mus(2:T+1),[1 2^T]));
        
        OBJ_TRUE_BC_EXPECTATION(iterate_instance,iterate_beta) = (c'*Ordering_decisions_for_all_scenarios + sum(repmat(Coefficients_holding,[1 2^T]).*max(0, x_1 + cumsum(Ordering_decisions_for_all_scenarios - Demands_scenarios_best_case(2:T+1,:)))) + ...
        sum(repmat(Coefficients_backlogging,[1 2^T]).*max(0, -x_1 - cumsum(Ordering_decisions_for_all_scenarios - Demands_scenarios_best_case(2:T+1,:)))) )*Demand_probabilities_best_case';
    
    end
    
    sampled_demands_uniform = repmat([lb],[1 N_sim]) + repmat([ub]-[lb],[1 N_sim]).*sampled_scenarios_01_uniform;
    sampled_demands_mu_d = repmat([lb],[1 N_sim]) + repmat([ub]-[lb],[1 N_sim]).*sampled_01_mu_d;
    
    for iterate_simulate = 1:N_sim
        Orders = q_matrix*(sampled_demands_uniform(:,iterate_simulate)) + q_u_matrix * abs(sampled_demands_uniform(2:T+1,iterate_simulate) - mus(2:T+1));
        Results_simulation_uniform(iterate_simulate,iterate_instance) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate))),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0));
        if(~(all(Orders <= U + 0.01) && all(Orders >= L - 0.01) && all(cumsum(Orders) <= U_cum + 0.01) && all(cumsum(Orders) >= L_cum - 0.01)))
            fuckup = fuckup + 1;
            break;
        end
        Orders = q_matrix*(sampled_demands_mu_d(:,iterate_simulate)) + q_u_matrix * abs(sampled_demands_mu_d(2:T+1,iterate_simulate) - mus(2:T+1));
        Results_simulation_mu_d(iterate_simulate,iterate_instance) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate))),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0));
    end
    
end

save('Results_Bertsimas2016_anticipate_analysis.mat')
