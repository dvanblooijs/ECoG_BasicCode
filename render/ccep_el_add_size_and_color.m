function ccep_el_add_size_and_color(dataBase,els,cfg,n)

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

r2_size = cfg.r2_size;
r2_color = cfg.r2_color;
r2_sizemax = max(r2_size);
r2_colormax = max(r2_color);
size_title = cfg.size_title;
color_title = cfg.color_title;
color = cfg.color;

% set steps for color and size
cmapshades(1,:,:,:) = [0:1/63:1;zeros(1,64);zeros(1,64)]'; %red
cmapshades(2,:,:,:) = [zeros(1,64);0:1/63:1;zeros(1,64)]'; %green
cmapshades(3,:,:,:) = [zeros(1,64);zeros(1,64);0:1/63:1]'; %blue
cmapshades(4,:,:,:) = [zeros(1,64);0:1/63:1;0:1/63:1]'; %cyan
cmapshades(5,:,:,:) = [0:1/63:1;0:1/63:1;zeros(1,64)]'; %yellow
cmapshades(6,:,:,:) = [0:1/63:1;zeros(1,64);0:1/63:1]'; %magenta

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

stepsnum = size(cmap,1)-1;
minmarkersize = 30; % minimal size the electrodes can be
maxmarkersize = 60; % maximal size the electrode can be
% divide markersizes in X steps (0-(stepsnum-1))
elsize=minmarkersize:(maxmarkersize-minmarkersize)/(stepsnum):maxmarkersize;
elsizenum = min(r2_size):(max(r2_size)-min(r2_size))/(stepsnum):max(r2_size);
elcolornum = min(r2_color):(max(r2_color)-min(r2_color))/(stepsnum):max(r2_color);

% scale size and color
r2_size_scaled=round(r2_size/r2_sizemax *(stepsnum)); % scale r2_size between 0-64(because size(cmap)=64)
r2_color_scaled=round(r2_color/r2_colormax *(stepsnum)); % scale r2_color between 0-64 (because size(cmap)=64)
hold on

% electrode with r2:
for n=1:size(els,1)
    if ~isnan(r2_size_scaled(n))
        % color and size of specific electrode
        elsize_r2 = elsize(r2_size_scaled(n)+1);
        elcol_r2 = cmap(r2_color_scaled(n)+1,:);
        % plot electrode in specific color and size (and red edge when SOZ)
        if ismember(n,dataBase(1).soz)
            plot3(els(n,1),els(n,2),els(n,3),'.','Color','r','MarkerSize',elsize_r2)
        else
            plot3(els(n,1),els(n,2),els(n,3),'.','Color','k','MarkerSize',elsize_r2)
        end
        plot3(els(n,1),els(n,2),els(n,3),'.','Color',elcol_r2,'MarkerSize',elsize_r2-5)
    else
        if ismember(n,dataBase(1).soz)
            plot3(els(n,1),els(n,2),els(n,3),'.','Color','r','MarkerSize',elsize(1))
        else
            plot3(els(n,1),els(n,2),els(n,3),'.','Color','k','MarkerSize',elsize(1))
        end
        plot3(els(n,1),els(n,2),els(n,3),'.','Color','k','MarkerSize',elsize(1)-5)
        
    end
    
end
hold off
title(sprintf('%s %s %s %s ',dataBase(1).sub_label,dataBase(1).ses_label, dataBase(1).task_label,dataBase(1).run_label))

% Legendas
subplot('position', [0.05 0.1 0.4 0.1],'color',[1 1 1])
hold on
for n=1:size(cmap,1)
    plot(elcolornum(n),1,'.','MarkerSize',elsize(1),'Color',cmap(n,:))
end
hold off
xlim([min(r2_color) max(r2_color)])
set(gca,'YColor','w')
set(gca,'XTick',min(r2_color):1:max(r2_color),'YTick',[], 'FontName','arial','FontSize',12)
xlabel(color_title)

subplot('position', [0.55 0.1 0.4 0.1],'color',[1 1 1])
hold on
for n=1:size(elsize,2)
    plot(elsizenum(n),1,'.','MarkerSize',elsize(n),'Color',[0 0 0])
end
hold off
xlim([min(r2_size) max(r2_size)])
set(gca,'YColor','w')
set(gca,'XTick',min(r2_size):1:max(r2_size),'YTick',[], 'FontName','arial','FontSize',12)
xlabel(size_title)
end
