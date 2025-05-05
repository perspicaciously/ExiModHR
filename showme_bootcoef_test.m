
% created to visualize the data of 100 participants (bootstrapped from 1
% control test) - 6 stimuli 100 samples, coefficients spread + mean 

hold on

scatter3(1, [100:-1:1], bootstrap_samples(1,:),'MarkerEdgeColor','k', 'MarkerFaceColor',[0 .75 .75])
scatter3(1, [100:-1:1],bootstrap_means(1), 'filled','*','MarkerEdgeColor',[0 .75 .75], 'MarkerFaceColor',[0 .75 .75])
xlabel('stimuli')
xlim([0 7])
ylabel('samples')
ylim([0 102])
zlabel('coefficient')
zlim([-20 45])


scatter3(2, [100:-1:1], bootstrap_samples(2,:),'MarkerEdgeColor','k', 'MarkerFaceColor',[0 .50 .75])
scatter3(2, [100:-1:1],bootstrap_means(2), 'filled','*','MarkerEdgeColor',[0 .50 .75], 'MarkerFaceColor',[0 .50 .75])

scatter3(3, [100:-1:1], bootstrap_samples(3,:),'MarkerEdgeColor','k', 'MarkerFaceColor',[0.8500 0.3250 0.0980])
scatter3(3, [100:-1:1],bootstrap_means(3), 'filled','*','MarkerEdgeColor',[0.8500 0.3250 0.0980], 'MarkerFaceColor',[0.8500 0.3250 0.0980])

scatter3(4, [100:-1:1], bootstrap_samples(4,:),'MarkerEdgeColor','k', 'MarkerFaceColor',[0.4940 0.1840 0.5560])
scatter3(4, [100:-1:1],bootstrap_means(4), 'filled','*','MarkerEdgeColor',[0.4940 0.1840 0.5560], 'MarkerFaceColor',[0.4940 0.1840 0.5560])

scatter3(5, [100:-1:1], bootstrap_samples(5,:),'MarkerEdgeColor','k', 'MarkerFaceColor',[0.6350 0.0780 0.1840])
scatter3(5, [100:-1:1],bootstrap_means(5), 'filled','*','MarkerEdgeColor',[0.6350 0.0780 0.1840], 'MarkerFaceColor',[0.6350 0.0780 0.1840])

scatter3(6, [100:-1:1], bootstrap_samples(6,:),'MarkerEdgeColor','k', 'MarkerFaceColor',[0.9290 0.6940 0.1250])
scatter3(6, [100:-1:1],bootstrap_means(6), 'filled','*','MarkerEdgeColor',[0.9290 0.6940 0.1250], 'MarkerFaceColor',[0.9290 0.6940 0.1250])

view([-75 10]) 

%end