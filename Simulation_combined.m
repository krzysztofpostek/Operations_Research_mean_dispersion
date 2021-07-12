
% In order to run this file you need to open the file Big_data_inventory,
% which has been constructed for T=6 time periods

    beta_range = [0.25 0.5 0.75];
    rho = 0.25;
    T=6;

    % Setting the one-sided probabilities
    N_instances=50;
    N_sim_average_optimization = 200;
    Objectives_worst_case = zeros(N_instances,15);
    Objectives_worst_case_mu_d = zeros(N_instances,15);
%    Objectives_worst_case_mu = zeros(N_instances,15);
    Objectives_best_case_together = zeros(N_instances,15,length(beta_range));

    N_sim=10^4;
    Results_simulation_uniform = zeros(N_sim,15,N_instances);
    Results_simulation_mu_d = zeros(N_sim,15,N_instances);
%    Results_simulation_mu = zeros(N_sim,15,N_instances);
%     
%     Results_simulation_copula_uniform = zeros(N_sim, N_instances, length(Correlation_for_copulas));
%     Results_simulation_copula_mu_d = zeros(N_sim, N_instances, length(Correlation_for_copulas));
%     
    Times = zeros(N_instances,1);

    for iterate_instance = 1:50
        tic
        Data_setting_mu_d;
        Data_setting_mu;

        sampled_demands_uniform = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_scenarios_01_uniform;
        sampled_demands_mu_d = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_01_mu_d;
        sampled_demands_mu = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_01_mu;

        %%%% The fully adjustable problem
%         position_table = 1;
%         Full_ARO;
%         Objectives_worst_case(iterate_instance,position_table) = objective_proxy;
% 
%         clear Demand_scenarios_binary Equality_constraints_binary;

        %%%% Solve the adjustable robust problem and insert data
        cvx_clear;
        position_table = 2;
        ARO;
        Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
        objective_limit = cvx_optval;

        Simulation_run;

        Performance_in_mu_d_setting;
        Objectives_worst_case_mu_d(iterate_instance,position_table) = performance_optval;

        Performance_in_mu_setting;
        Objectives_worst_case_mu(iterate_instance,position_table) = performance_optval;

        for beta_iterate = 1:3  
    
            beta_best_case = beta_range(beta_iterate);
            beta_vector = beta_best_case*ones(T,1);
            Data_setting_best_case;

            Performance_best_case_setting;
            Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = performance_optval;

        end

        % Nominal refinement
        Average_case_refinement_for_ARO_nominal;
        position_table = 3;
        Simulation_run;

        Performance_in_robust_setting;
        Objectives_worst_case(iterate_instance,position_table) = cvx_optval;

        Performance_in_mu_d_setting;
        Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;

        Performance_in_mu_setting;
        Objectives_worst_case_mu(iterate_instance,position_table) = cvx_optval;

        for beta_iterate = 1:3  
    
            beta_best_case = beta_range(beta_iterate);
            beta_vector = beta_best_case*ones(T,1);
            Data_setting_best_case;

            Performance_best_case_setting;
            Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = cvx_optval;

        end

        % Sample based refinement
        Average_case_refinement_for_ARO_sample_based;
        position_table = 4;
        Simulation_run;

        Performance_in_robust_setting;
        Objectives_worst_case(iterate_instance,position_table) = cvx_optval;

        Performance_in_mu_d_setting;
        Objectives_worst_case_mu_d(iterate_instance,position_table) = performance_optval;

        Performance_in_mu_setting;
        Objectives_worst_case_mu(iterate_instance,position_table) = performance_optval;

        for beta_iterate = 1:3  
    
            beta_best_case = beta_range(beta_iterate);
            beta_vector = beta_best_case*ones(T,1);
            Data_setting_best_case;

            Performance_best_case_setting;
            Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = performance_optval;

        end

        % Mu refinement
        Average_case_refinement_for_ARO_mu_based;
        position_table = 5;
        Simulation_run;

        Performance_in_robust_setting;
        Objectives_worst_case(iterate_instance,position_table) = cvx_optval;

        Performance_in_mu_d_setting;
        Objectives_worst_case_mu_d(iterate_instance,position_table) = performance_optval;

        Performance_in_mu_setting;
        Objectives_worst_case_mu(iterate_instance,position_table) = performance_optval;

        for beta_iterate = 1:3  
    
            beta_best_case = beta_range(beta_iterate);
            beta_vector = beta_best_case*ones(T,1);
            Data_setting_best_case;

            Performance_best_case_setting;
            Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = performance_optval;

        end

        % Mu-d refinement
        Average_case_refinement_for_ARO_mu_d_based;
        position_table = 6;
        Simulation_run;

        Performance_in_robust_setting;
        Objectives_worst_case(iterate_instance,position_table) = cvx_optval;

        Performance_in_mu_d_setting;
        Objectives_worst_case_mu_d(iterate_instance,position_table) = performance_optval;

        Performance_in_mu_setting;
        Objectives_worst_case_mu(iterate_instance,position_table) = performance_optval;

        for beta_iterate = 1:3  
    
            beta_best_case = beta_range(beta_iterate);
            beta_vector = beta_best_case*ones(T,1);
            Data_setting_best_case;

            Performance_best_case_setting;
            Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = performance_optval;

        end

%         %%%% Solve the nonadjustable mu problem
%         position_table = 7;
%         Nonadjustable_mu;
%         objective_limit = cvx_optval;
%         Objectives_worst_case_mu(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_robust_setting;
%         Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_mu_d_setting;
%         Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;
% 
%         for beta_iterate = 1:3  
%     
%             beta_best_case = beta_range(beta_iterate);
%             beta_vector = beta_best_case*ones(T,1);
%             Data_setting_best_case;
% 
%             Performance_best_case_setting;
%             Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = cvx_optval;
% 
%         end
% 
%         Simulation_run;
% 
%         % Refinement with robust
% 
%         position_table = 8;
%         Robust_refinement_for_nonadjustable_mu;
% 
%         Performance_in_mu_setting
%         Objectives_worst_case_mu(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_robust_setting;
%         Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_mu_d_setting;
%         Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;
% 
%         for beta_iterate = 1:3  
%     
%             beta_best_case = beta_range(beta_iterate);
%             beta_vector = beta_best_case*ones(T,1);
%             Data_setting_best_case;
% 
%             Performance_best_case_setting;
%             Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = cvx_optval;
% 
%         end
% 
% 
% %         Simulation_run;
% 
%         %%%% Solve the adjustable mu problem
% 
%         position_table = 9;
% 
%         Adjustable_mu;
%         objective_limit = cvx_optval;
%         Objectives_worst_case_mu(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_robust_setting;
%         Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_mu_d_setting;
%         Objectives_worst_case_mu_d(iterate_instance,position_table) = performance_optval;
% 
%         for beta_iterate = 1:3  
%     
%             beta_best_case = beta_range(beta_iterate);
%             beta_vector = beta_best_case*ones(T,1);
%             Data_setting_best_case;
% 
%             Performance_best_case_setting;
%             Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = performance_optval;
% 
%         end
% 
% 
%         Simulation_run;
% 
%         % Refinement with robust
% 
%         position_table = 10;
%         Robust_refinement_for_adjustable_mu;
% 
%         Performance_in_mu_setting
%         Objectives_worst_case_mu(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_robust_setting;
%         Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_mu_d_setting;
%         Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;
% 
%         for beta_iterate = 1:3  
%     
%             beta_best_case = beta_range(beta_iterate);
%             beta_vector = beta_best_case*ones(T,1);
%             Data_setting_best_case;
% 
%             Performance_best_case_setting;
%             Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = cvx_optval;
% 
%         end
% 
% 
%         Simulation_run;
% 
        %%%% Solve the nonadjustable mu-d problem

%         position_table = 11;
%         Nonadjustable_mu_d;
%         objective_limit = cvx_optval;
%         Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_robust_setting;
%         Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_mu_setting;
%         Objectives_worst_case_mu(iterate_instance,position_table) = cvx_optval;
% 
%         for beta_iterate = 1:3  
%     
%             beta_best_case = beta_range(beta_iterate);
%             beta_vector = beta_best_case*ones(T,1);
%             Data_setting_best_case;
% 
%             Performance_best_case_setting;
%             Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = performance_optval;
% 
%         end
% 
% 
%          Simulation_run;
% 
%         % Refinement with robust
% 
%         position_table = 12;
%         Robust_refinement_for_nonadjustable_mu_d;
% 
%         Performance_in_mu_d_setting
%         Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_robust_setting;
%         Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_mu_setting;
%         Objectives_worst_case_mu(iterate_instance,position_table) = cvx_optval;
% 
%         for beta_iterate = 1:3  
%     
%             beta_best_case = beta_range(beta_iterate);
%             beta_vector = beta_best_case*ones(T,1);
%             Data_setting_best_case;
% 
%             Performance_best_case_setting;
%             Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = cvx_optval;
% 
%         end
% 
%         Simulation_run;
% 
%         %%%% Solve the adjustable mu-d problem
% 
%         position_table = 13;
%         Adjustable_mu_d;
%         objective_limit = cvx_optval;
%         Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_robust_setting;
%         Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_mu_setting;
%         Objectives_worst_case_mu(iterate_instance,position_table) = performance_optval;
% 
%         for beta_iterate = 1:3  
%     
%             beta_best_case = beta_range(beta_iterate);
%             beta_vector = beta_best_case*ones(T,1);
%             Data_setting_best_case;
% 
%             Performance_best_case_setting;
%             Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = performance_optval;
% 
%         end
%         
%         for iterate_correlation_for_copulas = 1:length(Correlation_for_copulas)
%     
%             sampled_demands_copula_uniform = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*[ ones(1,N_sim) ; Copula_sample_01(:,:,iterate_correlation_for_copulas) ];
%         
%             for iterate_simulate = 1:N_sim
%             
%                   Orders = double(Ordering_LDR) * (sampled_demands_copula_uniform(:,iterate_simulate));
%                   Results_simulation_copula_uniform(iterate_simulate, iterate_instance, iterate_correlation_for_copulas) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - sampled_demands_copula_uniform(2:T+1,iterate_simulate))),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_copula_uniform(2:T+1,iterate_simulate)),0));
%         
%             end
%         
%         end
%         
%         for iterate_correlation_for_copulas = 1:length(Correlation_for_copulas)
%     
%             sampled_demands_copula_mu_d = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*[ ones(1,N_sim) ; Copula_sample_01_mu_d(:,:,iterate_correlation_for_copulas) ];
%         
%             for iterate_simulate = 1:N_sim
%             
%                   Orders = double(Ordering_LDR) * (sampled_demands_copula_mu_d(:,iterate_simulate));
%                   Results_simulation_copula_mu_d(iterate_simulate, iterate_instance, iterate_correlation_for_copulas) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - sampled_demands_copula_mu_d(2:T+1,iterate_simulate))),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_copula_mu_d(2:T+1,iterate_simulate)),0));
%         
%             end
%         
%         end
% 
%         Simulation_run;
% 
%         % Refinement with robust
% 
%         position_table = 14;
%         Robust_refinement_for_adjustable_mu_d;
% 
%         Performance_in_mu_d_setting
%         Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_robust_setting;
%         Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_mu_setting;
%         Objectives_worst_case_mu(iterate_instance,position_table) = cvx_optval;
% 
%         for beta_iterate = 1:3  
%     
%             beta_best_case = beta_range(beta_iterate);
%             beta_vector = beta_best_case*ones(T,1);
%             Data_setting_best_case;
% 
%             Performance_best_case_setting;
%             Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = cvx_optval;
% 
%         end
% 
%         Simulation_run;

%         %%%% Solve the nominal problem
% 
%         position_table = 15;
%         Nominal_solution;
% 
%         Performance_in_mu_d_setting
%         Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_robust_setting;
%         Objectives_worst_case(iterate_instance,position_table) = cvx_optval;
% 
%         Performance_in_mu_setting;
%         Objectives_worst_case_mu(iterate_instance,position_table) = cvx_optval;   
% 
%         for beta_iterate = 1:3  
%     
%             beta_best_case = beta_range(beta_iterate);
%             beta_vector = beta_best_case*ones(T,1);
%             Data_setting_best_case;
% 
%             Performance_best_case_setting;
%             Objectives_best_case_together(iterate_instance,position_table,beta_iterate) = cvx_optval;
% 
%         end
% 
%         Simulation_run;

        if(not(logical(mod(iterate_instance,5))))
            save(strcat(['Results_combined_T' num2str(T) 'rho' num2str(rho) 'beta' num2str(beta_range) 'N_instances' num2str(N_instances) '.mat']));
        end

        Times(iterate_instance) = toc;
    end
