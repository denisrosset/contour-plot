Contour(s)Plot
==============

Plots the boundary of 2D convex sets.

The convex sets are each defined by an oracle/function that maximizes a linear functional/inequality and returns a maximizer (i.e. a point in the convex set).

Such a function can be (here in a minimal example):

```matlab
function pt = circlef(lin)
% function that defines a circle of radius 1
	x = sdpvar;
	y = sdpvar;
	optimize(norm([x;y]) <= 1, -lin(1)*x-lin(2)*y);
	pt = [double(x); double(y)];
end

state = ContourInit(@circlef);
for i = 1:10
	state = ContourUpdate(@circlef, state);
	style = struct;
	style.fill = {'', 'FaceColor', [1 0 0], 'FaceAlpha', 0.2, 'LineStyle', 'none'};
	style.bezier = {'-', 'Color', [1 0 0]};
	ContourPlot(state, style);
end
```

The `ContourInit` function creates an approximation using three oracle calls (so, the shape is a triangle), and the approximation is returned in a Matlab struct called `state` which can easily be saved to disk (this is why we provide the functions separately to the functions, as they are more difficult to write to disk).

Subsequent calls to `ContourUpdate` perform a single oracle call to refine the approximation where it is most needed.

In the `Example.m` file, we show how to perform an iterative refinement of a convex set and display it using `ContourPlot`. This last function, `ContourPlot`, takes a `style` struct argument, with the following possible fields:

- `inner` plots a 2D inner polytope approximation of the convex set,
- `outer` plots a 2D outer polytope approximation of the convex set,
- `bezier` uses the known points on the boundary and the tangent angles to provide a best guess of the boundary of the convex set,
- `fill` plots the difference between the inner and outer approximations.

These fields should contain the parameters passed to `plot` and `fill` in a cell array, such as `{'r-'}` for a red line.

The `ContoursInit`, `ContoursUpdate` and `ContoursPlot` perform the same operations for a family of convex sets; `ContoursUpdate` will perform a single oracle call to refine the convex set that has currently the worst approximation. See `ExampleMulti.m`.

An example below, which required less than 100 oracles *in total* for the picture.

![Animation](optimizedanim.gif)

