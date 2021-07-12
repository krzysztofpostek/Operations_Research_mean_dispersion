% Plotting of the worst and best case results

figure(1)
hold on

ticks = [0:size(First_table,2)-1]';

scatter(ticks,First_table(3,:)','vk');

scatter(ticks,First_table(4,:)','filled','sk');
scatter(ticks,First_table(5,:)','filled','^k');
scatter(ticks,First_table(6,:)','filled','dk');

set(gca, 'XTick', [0 1 2], 'XTickLabel', {'RO','(\mu,d)'});

legend('Worst-case','Best-case, beta = 0.25','Best-case, beta = 0.5','Best-case, beta = 0.75','Location','northeast');
xlabel('Solution');
ylabel('Objective function value')
xlim([-0.5,1.5]);

grid on
hold off