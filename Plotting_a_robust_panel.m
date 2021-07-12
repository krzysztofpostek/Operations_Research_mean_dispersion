% Plotting_a_robust_panel
% Choose solution

solution_index = 2;

Diagram_for_plot = Diagrams'*Solutions(:,solution_index);
 
 figure(2);
 
 subplot(2,2,1);
 hold on;
 
 plot(Degrees_angle_grid,Diagram_for_plot,'k');
 xlim([0 90]);
 ylim([-0.2 1.1]);
 refline(0,0);
 plot([77 90],[0.9 0.9]);
 plot([70 90],[1 1]);
 ylabel('Diagram')';
 xlabel('Angle');
 plot([70 70],[0 1]);
 plot([77 77],[0 0.9]);
 
 grid on;
 switch solution_index
     case 1
        title('Nominal solution - no implementation error');
     otherwise
        title('Robust solution - no implementation error');
 end
 
 hold off
 
 % No implementation error - polar plot
 subplot(2,2,2);
 
 polar(linspace(0,2*pi,4*N_grid_points)',0.99*[Diagram_for_plot ; flip(Diagram_for_plot) ; Diagram_for_plot ; flip(Diagram_for_plot)],'k');
 hold on
 polar(linspace(0,2*pi,4*N_grid_points)',0.9*ones(4*N_grid_points,1));
 hold off
 
title('No implementation error - polar plot');
 
 % Implementation error - standard plot
 
 subplot(2,2,3);
 Diagram_for_plot = Implemented_diagrams(:,round(rand()*(N_plots-1)+1),solution_index);
 
 plot(Degrees_angle_grid,Diagram_for_plot,'k');
 hold on
 xlim([0 90]);
 ylabel('Diagram')';
 xlabel('Angle');
 refline(0,0);
 
 grid on;
 switch solution_index
     case 1
        title(strcat(['Nominal solution - implementation error \rho=' num2str(error_size_range(iterate_error_size))]));
       otherwise
        title(strcat(['Robust solution - implementation error \rho=' num2str(error_size_range(iterate_error_size))]));
         plot([77 90],[0.9 0.9]);
         plot([70 90],[1 1]);
         plot([70 70],[0 1]);
         plot([77 77],[0 0.9]);
         ylim([-0.2 1.1]);
 end
 
 hold off
 
 % Implementation error - polar plot
 
 subplot(2,2,4);
 
 polar(linspace(0,2*pi,4*N_grid_points)',[Diagram_for_plot ; flip(Diagram_for_plot) ; Diagram_for_plot ; flip(Diagram_for_plot)],'k');
 hold on
  switch solution_index
        case 1
        otherwise
          polar(linspace(0,2*pi,4*N_grid_points)',0.9*ones(4*N_grid_points,1)); 
 end
 hold off
 
 title('Implementation error - polar plot');
