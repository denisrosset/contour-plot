addpath('~/Projects/software/2017-nqa');
addpath(genpath('~/software/yalmip'));
addpath(genpath('~/software/sedumi'));
data = load('PNeg.mat');
P1 = data.PNeg;
options = sdpsettings(SedumiOriginalSettings, 'sedumi.eps', 1e-8);
Paxby = reshape(permute(P1, [1 3 2 4]), [4 4]);
Pax = sum(Paxby, 2)/2;
Pby = sum(Paxby, 1)/2;
Pprod = permute(reshape(kron(Pax(:), Pby(:)), [2 2 2 2]), [1 3 2 4]);
P0 = Pprod;
Pdet = [0 1 0 1]';
P2 = permute(reshape(kron(Pdet(:), Pdet(:)), [2 2 2 2]), [1 3 2 4]);
options = SedumiOriginalSettings;
range = 0:pi/256:2*pi;
[lx ly] = FindContour(P0, P1, P2, range, 'L', [], options);
[q1x q1y] = FindContour(P0, P1, P2, range, 'Q', 1, options);
[q2x q2y] = FindContour(P0, P1, P2, range, 'Q', 2, options);
[a1x a1y] = FindContour(P0, P1, P2, range, 0.2, 1, options);
[a2x a2y] = FindContour(P0, P1, P2, range, 0.2, 2, options);
[b1x b1y] = FindContour(P0, P1, P2, range, 0.3, 1, options);
[b2x b2y] = FindContour(P0, P1, P2, range, 0.3, 2, options);
[nx ny] = FindContour(P0, P1, P2, range, 'N', [], options);
clf;
hold on;
plot(lx, ly, 'k-');
plot(q1x, q1y, 'r-');
plot(q2x, q2y, 'b-');
plot(a1x, a1y, 'r:');
plot(a2x, a2y, 'b:');
plot(b1x, b1y, 'r--');
plot(b2x, b2y, 'b--');
plot(nx, ny, 'k-');
plot(0,0,'ok');
plot(1,0,'or');
plot(0,1,'ob');
legend('Local', 'Q1', 'Q2', 'neg=0.2 Q1', 'neg=0.2 Q2', 'neg=0.3 Q1', 'neg=0.3 Q2', 'NS', ...
       'Pprod', 'Pneg', 'Pdet');
save Plot.mat lx ly q1x q1y q2x q2y a1x a1y a2x a2y b1x b1y b2x b2y nx ny