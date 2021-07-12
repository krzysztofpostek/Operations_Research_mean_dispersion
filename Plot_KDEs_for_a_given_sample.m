% This file makes a plot of the kernel density estimators for a given
% problem sample

figure(5);

instance_number_for_plot = 1+round(rand()*49);

hold on

[f,xi] = ksdensity(Results_simulation_uniform(:,2,instance_number_for_plot));
plot(xi,f,'-k','LineWidth',2)

[f,xi] = ksdensity(Results_simulation_uniform(:,6,instance_number_for_plot));
plot(xi,f,'--k','LineWidth',2)

legend('Non-enhanced RO','(\mu,d)-enhanced RO');

[f,xi] = ksdensity(Results_simulation_uniform(:,2,instance_number_for_plot));
plot_mean = mean(Results_simulation_uniform(:,2,instance_number_for_plot));
supple = [1:length(xi)];
supple2 = (xi <= plot_mean);
supple = max(supple2.*supple);
plot([xi(supple) xi(supple)]',[0 f(supple)]','-k','LineWidth',2);

[f,xi] = ksdensity(Results_simulation_uniform(:,6,instance_number_for_plot));
plot(xi,f,'--k','LineWidth',2)


plot_mean = mean(Results_simulation_uniform(:,6,instance_number_for_plot));
supple = [1:length(xi)];
supple2 = (xi <= plot_mean);
supple = max(supple2.*supple);
plot([xi(supple) xi(supple)]',[0 f(supple)]','--k','LineWidth',2);

xlabel('Objective value');
ylabel('Density function');
hold off;