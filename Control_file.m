% Computing the 10 solutions

% The proper experiment, initialization of the ranges for the error and the
% probability of constraint satisfaction

epsilon_range = [0.001 0.01 0.05];
error_size_range = [0.001 0.01 0.05];

% Defining the MAD
d=0.5*ones(N_antennas,1);

% Finding the omega's corresponding to the MAD

axis_grid = linspace(-20,20,10^4);

omega = zeros(N_antennas,1);

for l=1:N_antennas
    
    omega(l) = sqrt(max(2*log(d(l)*cosh(axis_grid) + 1 - d(l) )./axis_grid.^2));
    
end

Solutions = zeros(N_antennas,10);
Worst_case_objective = zeros(1,10);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Nominal solution %%%%%%%%%%%%%%%%%%%%%%%%%%

Solver_nominal;
Worst_case_objective(1) = cvx_optval;
Solutions(:,1) = x;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Robust solutions %%%%%%%%%%%%%%%%%%%%%%%%%%
for iterate_epsilon=1:length(epsilon_range)
    for iterate_error_size=1:length(error_size_range)
        % Defining the assumed error and probability for the given solution
        epsilon = epsilon_range(iterate_epsilon);
        error_size = error_size_range(iterate_error_size);
        
        % Running the solver file
        Solver;
        
        % Writing down the worst-case objective and the solutions
        Worst_case_objective((iterate_epsilon-1)*length(epsilon_range)+iterate_error_size+1) = cvx_optval;
        Solutions(:,(iterate_epsilon-1)*length(epsilon_range)+iterate_error_size+1) = x;
    end
end

% Simulation study %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_sim = 10^4;

% Allocation of matrices for empirical violation probabilities
Empirical_probabilities = zeros(size(error_size_range,2),size(Solutions,2));
Empirical_sidelobe = zeros(size(error_size_range,2),size(Solutions,2));


Random_numbers = 2*rand(N_antennas,N_sim)-1;

for iterate_error_size=1:length(error_size_range)
    % Defining the sample of random numbers on [-1,1]
    
    for iterate_solution = 1: size(Solutions,2)
        
            % Computing the implemented values of the decisions
            Implemented_values = (Random_numbers*error_size_range(iterate_error_size) +1).*repmat(Solutions(:,iterate_solution),[1 N_sim]);
        
            % Computing the implemented power at each angle
            Implemented_power = Diagrams'*Implemented_values;
            
            % Empirical sidelobe size
            Empirical_sidelobe(iterate_error_size,iterate_solution) = mean(max(abs(Implemented_power(1:length(Indices_class_1),:))));
            
            % Computing the empirical 0-1 variable indicating infeasibility
            % of the given constraint
            Infeasibility = 1- prod(Implemented_power(length(Indices_class_1)+1:N_grid_points,:) <= ones(length(Indices_class_2)+length(Indices_class_3),N_sim) ,1).*prod(Implemented_power(length(Indices_class_1)+1:N_grid_points,:) >= repmat([-ones(length(Indices_class_2),1) ; 0.9*ones(length(Indices_class_3),1) ],[1 N_sim]),1);
            
            % Updating the matrix with empirical probabilities
            Empirical_probabilities(iterate_error_size,iterate_solution) = mean(Infeasibility)*100;
    
    end
    
end


save(strcat(['Results d=' num2str(d(1)) '.mat']));