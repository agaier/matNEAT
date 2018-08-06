function cpvisual( hf, pole_length, state, axis_range, action )
% cpvisual( HF, POLE_LENGTH, STATE, AXIS_RANGE )
%
%     Takes as input a figure handle HF, the pole length POLE_LENGTH, and
%   cart-pole state information (for STATE formatting, see help information
%   in cart_pole.m). With these arguments, cpvisual() generates a graphic
%   in the desired figure representing the current cart-pole state. The
%   AXIS_RANGE parameter is 1x4 vector with the following format:
%   [Xmin Xmax Ymin Ymax]
%
%   Operation Notes:
%    - Regarding timing, the figure is drawn immediately (with no
%      artificial delays).
%    - If a figure with the given figure handle is not already
%      open, a new one will be created.
%    - If cart moves outside of given axis range, then the window
%      is horizontally translated to include it, while keeping the
%      aspect ratio constant.
%
%
% Written by Scott Livingston, October 2007 - January 2008
%
% Machine Intelligence Lab, EECS - Univ. of Tennessee
%
% Released under the GNU General Public License, version 3, see
% GPLv3.txt or README for details.
%
%*******************************
%
%   Arrows added to indicate executed action
%


% error-checking
if ~exist( 'hf', 'var' ) || ~exist( 'pole_length', 'var' ) || ~exist( 'state', 'var' )
    fprintf( 'Error: insufficient function arguments. See "help cpvisual" for usage.\n' );
    return
end
% if hf < 1 || hf-floor(hf) ~= 0 % if figure handle is invalid
%     fprintf( 'Error: HF = %d is an invalid figure handle.\n', hf );
%     return
% end
if pole_length <= 0 % if pole length is invalid
    fprintf( 'Error: %d is not a valid pole length.\n', pole_length );
    return
end
[r,c] = size( axis_range ); % if desired axis range is invalid
if r ~= 1 || c ~= 4 || axis_range(1) > axis_range(2) || axis_range(3) > axis_range(4)
    fprintf( 'Error: [%d %d %d %d] is not a valid axis range.\n', axis_range );
    return
end
[r,c] = size( state );
if r ~= 4 || c ~= 1 % if state vector is invalid
    fprintf( 'Error: STATE vector is invalid. See "help cart_pole.m" for format details.\n' );
    return
end

% graphing parameters:
% distance units are assumed to be the same as those of the pole length
% (that is, in meters).
cart_height = 0.25; % height of the cart
cart_width = 0.5; % width of the cart
hinge_radius = cart_width/20; % radius of the hinge connecting the pole and cart
hinge_res = 0.1; % resolution of the circle which represents the hinge


% generate vertices for the complicated components (pole and hinge)
hinge_X = state( 1 )+hinge_radius*cos(0:hinge_res:2*pi);
hinge_Y = cart_height+hinge_radius*sin(0:hinge_res:2*pi);
pole_vertices = [state( 1 )+pole_length/8*sin(state( 3 )-pi/8) cart_height+pole_length/8*cos(state( 3 )-pi/8); ...
                 state( 1 ) cart_height; ...
                 state( 1 )+pole_length/8*sin(state( 3 )+pi/8) cart_height+pole_length/8*cos(state( 3 )+pi/8); ...
                 state( 1 )+pole_length*sin(state( 3 ))-pole_length/8*sin(state( 3 )-pi/8) cart_height+pole_length*cos(state( 3 ))-pole_length/8*cos(state( 3 )-pi/8); ...
                 state( 1 )+pole_length*sin(state( 3 )) cart_height+pole_length*cos(state( 3 )); ...
                 state( 1 )+pole_length*sin(state( 3 ))-pole_length/8*sin(state( 3 )+pi/8) cart_height+pole_length*cos(state( 3 ))-pole_length/8*cos(state( 3 )+pi/8)];

% make graph
figure( hf );
clf;
patch( [state( 1 )-cart_width/2 state( 1 )-cart_width/2 state( 1 )+cart_width/2 state( 1 )+cart_width/2], ...
       [0 cart_height cart_height 0], ...
       [0.5 0.5 1.0] ); % the cart
patch( pole_vertices(:,1), pole_vertices(:,2), [.5 1.0 .5] ); % the pole
patch( hinge_X, hinge_Y, [0 0 0] ); % the hinge
hold on;
if action > 0
    plot(state( 1 ), cart_height/2, 'g>','MarkerSize',10*abs(action));
end

if action < 0
    plot(state( 1 ), cart_height/2, 'r<','MarkerSize',10*abs(action));
end



% shift window to follow the cart
if state(1)-cart_width/2 < axis_range(1)
    axis_range(2) = axis_range(2) - (axis_range(1) - state(1)-cart_width/2);
    axis_range(1) = state(1)-cart_width/2;
elseif state(1)+cart_width/2 > axis_range(2)
    axis_range(1) = axis_range(1) + (state(1)+cart_width/2 - axis_range(2));
    axis_range(2) = state(1)+cart_width/2;
end
axis( axis_range );

%axis( axis_range ); % old method; doesn't shift window to follow cart
%axis equal; % used to force realistic aspect ratio; it is disabled because
             % the axis range will change as the animation progresses if
             % "axis equal" is used.
xlabel( 'x (horizontal position)' );
drawnow; % force figure refresh
