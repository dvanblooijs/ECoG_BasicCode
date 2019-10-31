function ccep_el_add_color(dataBase,els,cfg)

%     Copyright (C) 2006  K.J. Miller & D. Hermes, Dept of Neurology and Neurosurgery, University Medical Center Utrecht
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     Modified for own use by D van Blooijs, september 2019, UMC Utrecht
%     whereas color represents latency and size represents amplitude

%   els = coordinates matrix
%   r2_size = input amplitudes
%   r2_color = input latencies
%   r2_sizemax = scale for amplitudes
%   r2_colormax = scale for latencies

% set steps for color and size
cmapshades(1,:,:,:) = [0:1/63:1;zeros(1,64);zeros(1,64)]'; %red
cmapshades(2,:,:,:) = [zeros(1,64);0:1/63:1;zeros(1,64)]'; %green
cmapshades(3,:,:,:) = [zeros(1,64);zeros(1,64);0:1/63:1]'; %blue
cmapshades(4,:,:,:) = [zeros(1,64);0:1/63:1;0:1/63:1]'; %cyan
cmapshades(5,:,:,:) = [0:1/63:1;0:1/63:1;zeros(1,64)]'; %yellow
cmapshades(6,:,:,:) = [0:1/63:1;zeros(1,64);0:1/63:1]'; %magenta

r2_color = cfg.r2_color;
r2_colormax = max(r2_color);
color_title = cfg.color_title;
color = cfg.color;
elsize= cfg.size;

if strcmp(color,'r')
    cmap = squeeze(cmapshades(1,:,:,:));
elseif strcmp(color,'g')
    cmap = squeeze(cmapshades(2,:,:,:));
elseif strcmp(color,'b')
    cmap = squeeze(cmapshades(3,:,:,:));
elseif strcmp(color,'c')
    cmap = squeeze(cmapshades(4,:,:,:));
elseif strcmp(color,'y')
    cmap = squeeze(cmapshades(5,:,:,:));
elseif strcmp(color,'m')
    cmap = squeeze(cmapshades(6,:,:,:));
end

stepsnum = size(cmap,1);
% divide markercolors in X steps (0-(stepsnum-1))
elcolornum = min(r2_color):(max(r2_color)-min(r2_color))/(stepsnum):max(r2_color);

% scale size and color
r2_color_scaled=round(r2_color/r2_colormax *(stepsnum)); % scale r2_color between 0-64 (because size(cmap)=64)
hold on

% electrode with r2:
for k=1:size(els,1)
    if ~isnan(r2_color_scaled(k)) && r2_color_scaled(k) ~= 0
        % color and size of specific electrode
        elcol_r2 = cmap(r2_color_scaled(k),:);
        % plot electrode in specific color and size (and red edge when SOZ)
        if ismember(k,dataBase(1).soz)
            plot3(els(k,1),els(k,2),els(k,3),'.','Color','r','MarkerSize',elsize)
        else
            plot3(els(k,1),els(k,2),els(k,3),'.','Color','k','MarkerSize',elsize)
        end
        plot3(els(k,1),els(k,2),els(k,3),'.','Color',elcol_r2,'MarkerSize',elsize-5)
    else
        if ismember(k,dataBase(1).soz)
            plot3(els(k,1),els(k,2),els(k,3),'.','Color','r','MarkerSize',25)
        else
            plot3(els(k,1),els(k,2),els(k,3),'.','Color','k','MarkerSize',25)
        end
        plot3(els(k,1),els(k,2),els(k,3),'.','Color','k','MarkerSize',20)
        
    end
    
end

hold off
title(sprintf('%s %s %s %s ',dataBase(1).sub_label,dataBase(1).ses_label, dataBase(1).task_label,dataBase(1).run_label))

% Legendas
subplot('position', [0.05 0.1 0.4 0.1],'color',[1 1 1])
hold on
for k=1:size(cmap,1)
    plot(elcolornum(k),1,'.','MarkerSize',elsize,'Color',cmap(k,:))
end
hold off
xlim([min(r2_color) max(r2_color)])
set(gca,'YColor','w')
set(gca,'XTick',min(r2_color):1:max(r2_color),'YTick',[], 'FontName','arial','FontSize',12)
xlabel(color_title)

end
