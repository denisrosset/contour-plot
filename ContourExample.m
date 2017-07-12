f2 = ContourFun(0.2, 2);
f3 = ContourFun(0.3, 2);
fQ = ContourFun('Q', 2);
state2 = ContourInit(f2);
state3 = ContourInit(f3);
stateQ = ContourInit(fQ);
for i = 1:20
    clf;
    hold on;
    ContourPlot(state2, [1 0 0], 1);
    ContourPlot(state3, [0 1 0], 1);
    ContourPlot(stateQ, [0 0 1], 1);
    axis([-2 2 -2 2]);
    drawnow;
    state2 = ContourUpdate(f2, state2);
    state3 = ContourUpdate(f3, state3);
    stateQ = ContourUpdate(fQ, stateQ);
end
clf;
hold on;
ContourPlot(state2, [1 0 0], 1);
ContourPlot(state3, [0 1 0], 1);
ContourPlot(stateQ, [0 0 1], 1);
axis([-2 2 -2 2]);
