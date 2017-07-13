function states = ContoursUpdate(fs, states)
% ContoursUpdate - adds a point to a convex set contour
%
% Refines a single contour, where an area between inner/outer 
% approximations is the greatest 
%
% INPUTS
%
% fs     Cell array vector of functions (see ContoursInit)
%
% states Current states
%
% OUTPUTS
%
% states Updated states
%
    m = length(states);
    areas = cellfun(@(state) max(state.area), states, 'UniformOutput', true);
    s = find(areas == max(areas));
    s = s(1);
    states{s} = ContourUpdate(fs{s}, states{s});
end
