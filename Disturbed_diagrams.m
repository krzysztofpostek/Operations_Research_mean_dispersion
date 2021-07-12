% This file builds up an array with disturbed diagrams for N_plots number
% of samples of error and error size chosen by iterate_error_size

% Number of samples for plotting

N_plots = 10;

% Matrix with the implemented powers

Implemented_diagrams = zeros(N_grid_points,N_plots,size(Solutions,2));

iterate_error_size=1;

Random_numbers = error_size_range(iterate_error_size)*(2*rand(N_antennas,N_plots)-1);
    
    for iterate_solution = 1: size(Solutions,2)
        
        % Computing the implemented values of the decisions
        Implemented_values = (Random_numbers+1).*repmat(Solutions(:,iterate_solution),[1 N_plots]);
        
        for iterate_sample = 1:N_plots
            % Computing the implemented power at each angle
            Implemented_diagrams(:,iterate_sample,iterate_solution) = Diagrams'*Implemented_values(:,iterate_sample);
            
            
        end
    end
%     
%  number_of_epsilon = repmat(1:length(epsilon_range),[1 length(error_size_range)])
%  
%  for i=1:10
%      subplot(2,5,i);
%      plot(Angle_grid,Implemented_diagrams(:,:,i),'b');
%      
%      switch i
%          case 1
%             title('Nominal');
%      
%          otherwise
%              title(strcat(['Assumed $(\epsilon,\rho)$: (' num2str(epsilon_range(ceil((i-1)/3))) ',' num2str(error_size_range(number_of_epsilon(i-1))) ')' ]));
%      end
%  end
%  