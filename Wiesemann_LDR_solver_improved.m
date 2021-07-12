% Solver Wiesemann (2014) linear adjustable decisions

cvx_begin

    % variable q(T*(T+1),1)
    variable q_matrix(T,T+1)
    variable q_u_matrix(T,T)
    variable objective
    variable Lambda(T,2*T) nonnegative
    variable Kappa(T,2*T) nonnegative
    variable Tau(T,2*T) nonnegative
    variable Ypsilon(T,2*T) nonnegative
    variable Upsilon(T,2*T) nonnegative
    variable Lambda_cum(T,2*T) nonnegative
    variable Kappa_cum(T,2*T) nonnegative
    variable Tau_cum(T,2*T) nonnegative
    variable Ypsilon_cum(T,2*T) nonnegative
    variable Upsilon_cum(T,2*T) nonnegative
    variable Lambda_lin_approx(T,2*T) nonnegative
    variable Kappa_lin_approx(T,2*T) nonnegative
    variable Tau_lin_approx(T,2*T) nonnegative
    variable Ypsilon_lin_approx(T,2*T) nonnegative
    variable Upsilon_lin_approx(T,2*T) nonnegative
    variable V(T,2 * T+1)
    
    minimize(objective)
    subject to
    
        sum(V(:,1)) + sum(V(:,2:T+1)) * mus + sum(V(:,T+2:2*T+1)) * ds <= objective;
        
        for t = 1:T
            
            % Bounding the ordering minus holding costs with a linear
            % decision rule
            
            q_matrix(t, 1) * c(t) + h(t) * (x_1 + sum(q_matrix(1:t,1))) - V(t,1) + ...
                Lambda_lin_approx(:,2*t-1)'*(ub) - Kappa_lin_approx(:,2*t-1)'*(lb) + ...
                Tau_lin_approx(:,2*t-1)'*mus - Ypsilon_lin_approx(:,2*t-1)'*mus + ...
                Upsilon_lin_approx(:,2*t-1)'*(- mus + ub) <= 0;
            c(t) * q_matrix(t, 2:T+1)' + h(t) * (sum(q_matrix(1:t,2:T+1))' - ...
                [ones(t,1) ; zeros(T-t,1)]) - V(t,2:T+1)' - ...
                Lambda_lin_approx(:, 2*t - 1) + Kappa_lin_approx(:, 2*t - 1) - ...
                Tau_lin_approx(:, 2*t - 1) + Ypsilon_lin_approx(:, 2*t - 1) == 0; % The z condition
            c(t) * q_u_matrix(t, 1:T)' + h(t) * sum(q_u_matrix(1:t,1:T))' + ...
                Tau_lin_approx(:, 2*t - 1) - V(t,T+2:2*T+1)' + ...
                Ypsilon_lin_approx(:, 2*t - 1) - Upsilon_lin_approx(:, 2*t - 1) == 0; % The u condition
            
            
            q_matrix(t, 1) * c(t) - p(t) * (x_1 + sum(q_matrix(1:t,1))) - V(t,1) + ...
                Lambda_lin_approx(:,2*t)'*(ub) - Kappa_lin_approx(:,2*t)'*(lb) + ...
                Tau_lin_approx(:,2*t)'*mus - Ypsilon_lin_approx(:,2*t)'*mus + ...
                Upsilon_lin_approx(:,2*t)'*(- mus + ub) <= 0;
            c(t) * q_matrix(t, 2:T+1)' - p(t) * (sum(q_matrix(1:t,2:T+1))' - ...
                [ones(t,1) ; zeros(T-t,1)]) - V(t,2:T+1)' - ...
                Lambda_lin_approx(:, 2*t) + Kappa_lin_approx(:, 2*t) - ...
                Tau_lin_approx(:, 2*t) + Ypsilon_lin_approx(:, 2*t) == 0; % The z condition
            c(t) * q_u_matrix(t, 1:T)' - p(t) * sum(q_u_matrix(1:t,1:T))' + ...
                Tau_lin_approx(:, 2*t) - V(t,T+2:2*T+1)' + ...
                Ypsilon_lin_approx(:, 2*t) - Upsilon_lin_approx(:, 2*t) == 0; % The u condition
            
        end
        
        % q_matrix == reshape(q,[T+1 T])';
        
        for t = 1:T
            
            q_matrix(t,t+1:T+1) == 0;
            q_u_matrix(t,t:T) == 0;
            %V(t,t+2:T+1) == 0;
            %V(t,T+t+2:2*T+1) == 0;
            
        end
        
        for t = 1:T
            
            q_matrix(t,1) + Lambda(:,2*t-1)'*(ub) - Kappa(:,2*t-1)'*(lb) + ...
                Tau(:,2*t-1)'*mus - Ypsilon(:,2*t-1)'*mus + ...
                Upsilon(:,2*t-1)'*(- mus + ub) <= U(t);
            
            q_matrix(t,2:T+1)' - Lambda(:,2*t-1) + Kappa(:,2*t-1) - ...
                Tau(:,2*t-1) + Ypsilon(:,2*t-1) == 0; % the z constraint
            
            q_u_matrix(t,1:T)' + Tau(:,2*t-1) + Ypsilon(:,2*t-1) - Upsilon(:,2*t-1) == 0; % the u constraint
            
            q_matrix(t,1) - Lambda(:,2*t)'*(ub) + Kappa(:,2*t)'*(lb) - ...
                Tau(:,2*t)'*mus + Ypsilon(:,2*t)'*mus - ...
                Upsilon(:,2*t)'*(- mus + ub) >= L(t);
            
            q_matrix(t,2:T+1)' + Lambda(:,2*t) - Kappa(:,2*t) + ...
                Tau(:,2*t) - Ypsilon(:,2*t) == 0; % the z constraint
            
            q_u_matrix(t,1:T)' - Tau(:,2*t) - Ypsilon(:,2*t) + Upsilon(:,2*t) == 0; % the u constraint
            
            sum(q_matrix(1:t,1)) + Lambda_cum(:,2*t-1)'*(ub) - Kappa_cum(:,2*t-1)'*(lb) + ...
                Tau_cum(:,2*t-1)'*mus - Ypsilon_cum(:,2*t-1)'*mus + ...
                Upsilon_cum(:,2*t-1)'*(- mus + ub) <= U_cum(t);
            
            sum(q_matrix(1:t,2:T+1),1)' - Lambda_cum(:,2*t-1) + Kappa_cum(:,2*t-1) - ...
                Tau_cum(:,2*t-1) + Ypsilon_cum(:,2*t-1) ==  0; % the z constraint
            
            sum(q_u_matrix(1:t,1:T),1)' + Tau_cum(:,2*t-1) + Ypsilon_cum(:,2*t-1) - Upsilon_cum(:,2*t-1) == 0; % the u constraint
            
            sum(q_matrix(1:t,1))  - Lambda_cum(:,2*t)'*(ub) + Kappa_cum(:,2*t)'*(lb) - ...
                Tau_cum(:,2*t)'*mus + Ypsilon_cum(:,2*t)'*mus - ...
                Upsilon_cum(:,2*t)'*(- mus + ub) >= L_cum(t);
            
            sum(q_matrix(1:t,2:T+1),1)' + Lambda_cum(:,2*t) - Kappa_cum(:,2*t) + ...
                Tau_cum(:,2*t) - Ypsilon_cum(:,2*t) ==  0; % the z constraint
            
            sum(q_u_matrix(1:t,1:T),1)' - Tau_cum(:,2*t) - Ypsilon_cum(:,2*t) + Upsilon_cum(:,2*t) == 0; % the u constraint
            
        end

cvx_end
