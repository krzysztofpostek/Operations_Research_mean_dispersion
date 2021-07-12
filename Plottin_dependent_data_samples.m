
subplot(2,2,1);

plot( [0.1:0.1:0.9]', Results(:,1,3), '--k' , [0.1:0.1:0.9]', Results(:,1,1), 'k');
%ylim([0 max([Results(:,1,3); Results(:,1,1)])])
ylim([950 1150]);
legend('LDR-1','LDR-2');
title('Uniform sample');
xlabel('\rho');
ylabel('Mean cost');

subplot(2,2,2);

plot([0.1:0.1:0.9]',Results(:,1,4) , '--k' , [0.1:0.1:0.9]', Results(:,1,2), 'k');
title('(\mu,d) sample');
xlabel('\rho');
ylabel('Mean cost');

subplot(2,2,3);

plot([0.1:0.1:0.9]', Results(:,2,3) , '--k' , [0.1:0.1:0.9]', Results(:,2,1), 'k' );
ylim([250 450]);
title('Uniform sample');
xlabel('\rho');
ylabel('Cost standard deviation');

subplot(2,2,4);

plot( [0.1:0.1:0.9]', Results(:,2,4) , '--k' , [0.1:0.1:0.9]', Results(:,2,2), 'k' );
title('(\mu,d) sample');
xlabel('\rho');
ylabel('Cost standard deviation');