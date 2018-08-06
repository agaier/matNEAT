function plotMedMax(value)
hold on;
valMax = max(value); valMed = median(value); itr = size(value,2);

h(10) = plot(valMax);
h(20) = plot(valMed);

h(21) = text(itr*1.02, valMed(end), [num2str(valMed(end),3) ' Median']);
h(11) = text(itr*1.02, valMax(end), [num2str(valMax(end),3) ' Max']);

h(12) = plot(itr, valMax(end),'s');
h(22) = plot(itr, valMed(end),'s');

% Formatting
h(11).Color = h(10).Color;
h(21).Color = h(20).Color;

h(12).MarkerFaceColor = h(10).Color;
h(22).MarkerFaceColor = h(20).Color;

h(12).MarkerEdgeColor = 'k';
h(22).MarkerEdgeColor = 'k';

h(12).MarkerSize = 9;
h(22).MarkerSize = 9;

hold off;