% Solver Wiesemann (2014) linear adjustable decisions

cvx_begin

    variable q(T*(T+1),1)
    variable q_matrix(T,T+1)
    variable objective
    variable Lambda(T,2*T) nonnegative
    variable Kappa(T,2*T) nonnegative
    variable Lambda_cum(T,2*T) nonnegative
    variable Kappa_cum(T,2*T) nonnegative
    variable Lambda_lin_approx(T,2*T) nonnegative
    variable Kappa_lin_approx(T,2*T) nonnegative
    variable V(T,T+1)
    
    minimize(objective)
    subject to
    
        sum(V(:,1)) + sum(V(:,2:T+1)) * mus <= objective;
        
        for t = 1:T
            
            % Bounding the ordering minus holding costs with a linear
            % decision rule
            
            q_matrix(t, 1) * c(t) + h(t) * (x_1 + sum(q_matrix(1:t,1))) - V(t,1) + Lambda_lin_approx(:,2*t-1)'*(ub) - Kappa_lin_approx(:,2*t-1)'*(lb) <= 0;
            c(t) * q_matrix(t, 2:T+1)' + h(t) * (sum(q_matrix(1:t,2:T+1))' - [ones(t,1) ; zeros(T-t,1)]) - V(t,2:T+1)' - Lambda_lin_approx(:, 2*t - 1) + Kappa_lin_approx(:, 2*t - 1) == 0;
            
            q_matrix(t, 1) * c(t) - p(t) * (x_1 + sum(q_matrix(1:t,1))) - V(t,1) + Lambda_lin_approx(:,2*t)'*(ub) - Kappa_lin_approx(:,2*t)'*(lb) <= 0;
            c(t) * q_matrix(t, 2:T+1)' - p(t) * (sum(q_matrix(1:t,2:T+1))' - [ones(t,1) ; zeros(T-t,1)]) - V(t,2:T+1)' - Lambda_lin_approx(:, 2*t) + Kappa_lin_approx(:, 2*t) == 0;
            
        end
        
        q_matrix == reshape(q,[T+1 T])';
        
        for t = 1:T
            
            q_matrix(t,t+1:T+1) == 0;
            V(t,t+2:T+1) == 0;
            
        end
        
        for t = 1:T
            
            q_matrix(t,1) + Lambda(:,2*t-1)'*(ub) - Kappa(:,2*t-1)'*(lb) <= U(t);
            
            q_matrix(t,2:T+1)' - Lambda(:,2*t-1) + Kappa(:,2*t-1) == 0;
            
            q_matrix(t,1) - Lambda(:,2*t)'*(ub) + Kappa(:,2*t)'*(lb) >= L(t);
            
            q_matrix(t,2:T+1)' + Lambda(:,2*t) - Kappa(:,2*t) == 0;
            
            sum(q_matrix(1:t,1)) + Lambda_cum(:,2*t-1)'*(ub) - Kappa_cum(:,2*t-1)'*(lb) <= U_cum(t);
            
            sum(q_matrix(1:t,2:T+1),1)' - Lambda_cum(:,2*t-1) + Kappa_cum(:,2*t-1) == 0;
            
            sum(q_matrix(1:t,1)) - Lambda_cum(:,2*t)'*(ub) + Kappa_cum(:,2*t)'*(lb) >= L_cum(t);
            
            sum(q_matrix(1:t,2:T+1),1)' + Lambda_cum(:,2*t) - Kappa_cum(:,2*t) == 0;
            
        end

cvx_end
