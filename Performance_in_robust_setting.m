A_unc = [eye(T+1) ; -eye(T+1) ] ;
b_unc = [ub ; -lb];
Demand_extraction = [zeros(T,1) eye(T)];

cvx_begin
    % Linear decision rules for the orders
    variable Ordering_LDR_test(T,T+1);
    % Linear decision rules for the maximum terms
    variable Max_LDR(T,T+1);
    % Objective
    variable objective_function;
    variable Ordering_LDR_test_mu_d_shape(T+1,1,T);
    variable lambda_objective(2*(T+1),1) nonnegative;
    variable lambda_holding(2*(T+1),T) nonnegative;
    variable lambda_backlogging(2*(T+1),T) nonnegative;
    variable lambda_U(2*(T+1),T) nonnegative;
    variable lambda_L(2*(T+1),T) nonnegative;
    variable lambda_U_cum(2*(T+1),T) nonnegative;
    variable lambda_L_cum(2*(T+1),T) nonnegative;
    
    minimize(objective_function)
    subject to
        Ordering_LDR_test == double(Ordering_LDR);
        
        for t=1:T
            Ordering_LDR_test_mu_d_shape(t+1:T+1,1,t) == zeros(T+1-t,1);
        end
        
        Ordering_LDR_test_mu_d_shape == reshape(Ordering_LDR_test',[T+1 1 T]);

        % Constraint on the objective
        lambda_objective'*b_unc <= objective_function;
        A_unc'*lambda_objective >= (Ordering_LDR_test'*c + Max_LDR'*ones(T,1));

        % Constraints on the LDRs for the max terms - holding costs
        for t=1:T
            lambda_holding(:,t)'*b_unc <= - Coefficients_holding(t)*x_1 ;
            A_unc'*lambda_holding(:,t) >= (Coefficients_holding(t)*(Ordering_LDR_test - Demand_extraction)'*[ones(t,1); zeros(T-t,1)] - Max_LDR(t,:)') ;
        end

        % Constraints on the LDRs for the max terms - backlogging costs
        for t=1:T
            lambda_backlogging(:,t)'*b_unc <= Coefficients_backlogging(t)*x_1 ;
            A_unc'*lambda_backlogging(:,t) >= (Coefficients_backlogging(t)*(-Ordering_LDR_test + Demand_extraction)'*[ones(t,1); zeros(T-t,1)] - Max_LDR(t,:)') ;
        end

        % Nonanticipativity max terms LDR
        for t=1:T-1
            Max_LDR(t,t+2:T+1) == zeros(1,T-t);
        end

        % Constraints on orders
        for t=1:T
            lambda_U(:,t)'*b_unc <= U(t);
            A_unc'*lambda_U(:,t) >= Ordering_LDR(t,:)';
            
            lambda_L(:,t)'*b_unc <= -L(t);
            A_unc'*lambda_L(:,t) >= -Ordering_LDR(t,:)';
            
            lambda_U_cum(:,t)'*b_unc <= U_cum(t);
            A_unc'*lambda_U_cum(:,t) >= ([ones(t,1); zeros(T-t,1)]'*Ordering_LDR)';
            
            lambda_L_cum(:,t)'*b_unc <= -L_cum(t);
            A_unc'*lambda_L_cum(:,t) >= -([ones(t,1); zeros(T-t,1)]'*Ordering_LDR)';
        end
        
cvx_end