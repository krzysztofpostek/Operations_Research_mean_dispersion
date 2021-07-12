%Data setting file 
lb = lb_matrix(2:T+1,iterate_instance);
ub = ub_matrix(2:T+1,iterate_instance);
% Lower and upper bounds on the orders
L = L_matrix(:,iterate_instance);
U = U_matrix(:,iterate_instance);
% Lower and upper bounds on cumulative orders
L_cum=L_cum_matrix*ones(T,1);
U_cum=U_cum_matrix(:,iterate_instance)*ones(T,1);
% Initial inventory state
x_1=x_1_matrix(iterate_instance);
% Ordering costs
c=c_matrix(:,iterate_instance);
% Holding costs
h=h_matrix(:,iterate_instance);
% Backlogging
p=p_matrix(:,iterate_instance);
% Replenishment value
s=0;

% Setting for problem
Coefficients_holding = h - ([1:T]' == T)*s;
Coefficients_backlogging = p;

% Setting the means of the demand distribution
mus=(lb+ub)/2;

% Setting the parameter of mean absolute deviation 

ds = rho*(ub - lb);