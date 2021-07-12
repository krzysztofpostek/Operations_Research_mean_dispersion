figure(1);

subplot(1,2,1);

AARC = cdfplot(reshape(Results_simulation_uniform(:,2,:),[N_sim*N_instances 1]));
set(AARC,'Color','black')
hold on
AAMUD = cdfplot(reshape(Results_simulation_uniform(:,13,:),[N_sim*N_instances 1]));
set(AAMUD,'Color','black')
set(AAMUD,'LineStyle','--')
legend('RO','(\mu,d)');
title('Empirical CDFs - uniform sample');
xlabel('Total cost');
ylabel('CDF');

subplot(1,2,2);

AARC = cdfplot(reshape(Results_simulation_mu_d(:,2,:),[N_sim*N_instances 1]));
set(AARC,'Color','black')
hold on
AAMUD = cdfplot(reshape(Results_simulation_mu_d(:,13,:),[N_sim*N_instances 1]));
set(AAMUD,'Color','black')
set(AAMUD,'LineStyle','--')
legend('RO','(\mu,d)');
title('Empirical CDFs - (\mu,d) sample');
xlabel('Total cost');
ylabel('CDF');
xlim([0 4000]);

figure(2);

AARC = cdfplot(reshape(Results_simulation_mu_d(:,2,:),[N_sim*N_instances 1]));
set(AARC,'Color','black')
hold on
AAMUD = cdfplot(reshape(Results_simulation_mu_d(:,6,:),[N_sim*N_instances 1]));
set(AAMUD,'Color','black')
set(AAMUD,'LineStyle','--')
legend('RO','(\mu,d) enhanced RO');
title('Empirical CDFs - (\mu,d) sample');
xlabel('Total cost');
ylabel('CDF');