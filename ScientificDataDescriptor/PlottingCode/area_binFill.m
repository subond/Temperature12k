function[fillhandle,msg]=area_binFill(xpoints,upper,lower,color,edge,add,transparency)
%USAGE: [fillhandle,msg]=area_fill(xpoints,upper,lower,color,edge,add,transparency)
%This function will fill a region with a color between the two vectors provided
%using the Matlab fill command.
%
%fillhandle is the returned handle to the filled region in the plot.
%xpoints= The horizontal data points (ie frequencies). Note length(Upper)
%         must equal Length(lower)and must equal length(xpoints)!
%upper = the upper curve values (data can be less than lower)
%lower = the lower curve values (data can be more than upper)
%color = the color of the filled area 
%edge  = the color around the edge of the filled area
%add   = a flag to add to the current plot or make a new one.
%transparency is a value ranging from 1 for opaque to 0 for invisible for
%the filled color only.
%
%John A. Bockstege November 2006;
%Example:
%     a=rand(1,20);%Vector of random data
%     b=a+2*rand(1,20);%2nd vector of data points;
%     x=1:20;%horizontal vector
%     [ph,msg]=area_fill(x,a,b,rand(1,3),rand(1,3),0,rand(1,1))
%     grid on
%     legend('Datr')
if nargin<7;transparency=.5;end %default is to have a transparency of .5
if nargin<6;add=1;end     %default is to add to current plot
if nargin<5;edge='k';end  %dfault edge color is black
if nargin<4;color='b';end %default color is blue

if length(upper)==length(lower) && length(lower)==length(xpoints)
    msg='';

    if add
        hold on
    end

    for i =1:2:length(xpoints)-1
        a = xpoints(i:i+1);
        a1 = fliplr(xpoints(i:i+1));
        fd = fliplr(lower(i:i+1));
        fillhandle=fill([a, a1],[upper(i:i+1), fd],color);%plot the data one bin at a time
        set(fillhandle,'EdgeColor',edge,'FaceAlpha',transparency,'EdgeAlpha',.1);%set edge color
    end
    
%     if add
%         hold off
%     end
else
    msg='Error: Must use the same number of points in each vector';
end