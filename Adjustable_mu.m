% File solving the adjustable mu

cvx_begin
    variable Ordering_LDR_mu_d_shape(T+1,1,T);
    variable Ordering_LDR(T,T+1);
    variable objective_function;
    variable ORDERING_DECISIONS(T,2^T);
    minimize(objective_function);
    subject to
        ORDERING_DECISIONS == reshape(sum(repmat(Ordering_LDR_mu_d_shape,[1 2^T]).*repmat(Demands_scenarios_mu,[1 1 T]),1),[2^T T])';
        sum(Demand_probabilities_mu.*(c'*ORDERING_DECISIONS + sum((repmat(Coefficients_holding,[1 2^T]).*max(x_1+cumsum(ORDERING_DECISIONS - Demands_scenarios_mu(2:T+1,:),1),0) + repmat(Coefficients_backlogging,[1 2^T]).*max((-x_1-cumsum(ORDERING_DECISIONS - Demands_scenarios_mu(2:T+1,:),1)),0)),1))) <= objective_function;
        
        ORDERING_DECISIONS <= repmat(U,[1 2^T]);    
        ORDERING_DECISIONS >= repmat(L,[1 2^T]);   
        
        cumsum(ORDERING_DECISIONS,1) <= repmat(U_cum,[1 2^T]);    
        cumsum(ORDERING_DECISIONS,1) >= repmat(L_cum,[1 2^T]);
        
        for t=1:T
            Ordering_LDR_mu_d_shape(t+1:T+1,1,t) == zeros(T+1-t,1);
        end
        
        Ordering_LDR_mu_d_shape == reshape(Ordering_LDR',[T+1 1 T]);
cvx_end