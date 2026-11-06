function ONOFFboxplot( dt )

color       = dt.color;
nCond       = numel(unique(dt.group));
nSub        = numel(unique(dt.sub));

figure; hold on

groupWidth  = 0.8;
subWidth    = groupWidth / nSub;
pos         = zeros(1, size(dt.raw,2));

for i = 1:numel(pos)
    c       = dt.group(i);
    s       = dt.sub(i);
    pos(i)  = c + (s - (nSub+1)/2) * subWidth;
end

boxplot( dt.raw, 'positions', pos, 'orientation', 'horizontal', 'widths', subWidth*0.9, 'symbol', '' );

% recolor each box to match the corresponding trial-label color
h                            = findobj(gca,'Tag','Box');
for k = 1:numel(h)
    s                        = dt.sub( numel(h) - k + 1 );   % handles are reversed order
    patch(get(h(k),'XData'), get(h(k),'YData'), color(s,:), 'FaceAlpha', 0.6, 'EdgeColor', color(s,:), 'LineWidth', 1.5);
end

% % this is just for double-checking the values als scattered dots 
% for i = 1:size(dt.raw,2)
%     c                        = dt.group(i);
%     n                        = dt.Nsub(c);                 % true subject count for this condition
%     colVals                  = dt.raw( 1:n, i );           % drop the padded NaN rows
%     % jittered scatter, e.g.:
%     scatter( colVals, pos(i) + (rand(n,1)-0.5)*0.05, 15, color(dt.sub(i),:), 'filled', 'MarkerFaceAlpha',0.4 )
% end

set( gca, 'YTick', 1:nCond, 'YTickLabel', {'detect','global','local'})
set( gcf, 'color', [1 1 1])

% make whiskers look like the old errorbar lines: solid, thick, no caps
set( findobj(gca,'Tag','Upper Whisker'), 'LineStyle','-', 'LineWidth',2 )
set( findobj(gca,'Tag','Lower Whisker'), 'LineStyle','-', 'LineWidth',2 )

% remove the little end-caps
set( findobj(gca,'Tag','Upper Adjacent Value'), 'LineStyle','none' )
set( findobj(gca,'Tag','Lower Adjacent Value'), 'LineStyle','none' )

% match median line color to each box's edge color
ML                           = findobj(gca,'Tag','Median');
for k = 1:numel(ML)
    s                        = dt.sub( numel(ML) - k + 1 );   
    ML(k).Color              = color(s,:);
    ML(k).LineWidth          = 2; 
end

box off 
pbaspect([1 .3 1])
myaxis('threshold','instruction')
ylim([0 nCond+1])
% xlim([min( dt.x ) max( dt.x )])

end

