

data_box_plot = [];

for solution_type=1:2
    for bound_type = 4:6
        data_box_plot = [data_box_plot [First_table(3,solution_type); First_table(bound_type,solution_type)]];
    end
end

positions = [1 1.25 1.5 2.5 2.75 3];

H = boxplot(data_box_plot, 'positions', positions);

set(gca,'xtick',[mean(positions(1:3)) mean(positions(4:6)) ])
set(gca,'xticklabel',{'RO','(\mu,d)'})

color = ['b', 'r', 'w', 'b', 'r', 'w'];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
   patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',1);
end

grid on

c = get(gca, 'Children');

hleg1 = legend(c(1:3), '\beta = 0.25', '\beta = 0.5','\beta = 0.75' );

for i=1:6
    set(H(6,i),'color',color(i))
end

xlabel('Solution');
ylabel('Expected value objective')