classdef ContourDataSet
    properties
        data = {};
    end
    methods
        function S = ContourDataSet(data)
            S.data = data;
        end
        function plot(S, styles)
        % PLOT Plots the contours of a data set
        %
        % Inputs:
        %
        % styles    Cell array vector of styles
            for s = 1:length(S.data)
                S.data{s}.plot(styles{s});
            end
        end
        function newS = updatedOracles(S, oracles)
        % UPDATEDORACLES Adds a point to a convex set contour
        %
        % Refines a single contour, where an area between inner/outer 
        % approximations is the greatest 
        %
        % Inputs:
        %
        % oracles     Cell array vector of oracle functions (see ContourData.fromOracle)
        %
        % OUTPUTS
        %
        % S           Updated ContourDataSet
            m = length(S.data);
            areas = cellfun(@(d) max(d.area), S.data, 'UniformOutput', true);
            s = find(areas == max(areas));
            s = s(1);
            newData = S.data;
            newData{s} = S.data{s}.updatedOracle(oracles{s});
            newS = ContourDataSet(newData);
        end
        function newS = updatedCVX(S, cvxsets)
        % UPDATEDCVX Adds a point to a convex set contour
        %
        % See updatedOracles, and the calling convention of ContourData.fromCVX
            m = length(S.data);
            areas = cellfun(@(d) max(d.area), S.data, 'UniformOutput', true);
            s = find(areas == max(areas));
            s = s(1);
            newData = S.data;
            newData{s} = S.data{s}.updatedCVX(cvxsets{s});
            newS = ContourDataSet(newData);            
        end
    end
    methods (Static)
        function S = fromOracles(oracles)
            S = ContourDataSet(cellfun(@(o) ContourData.fromOracle(o), oracles, 'UniformOutput', false));
        end
        function S = fromCVX(cvxsets)
            S = ContourDataSet(cellfun(@(c) ContourData.fromCVX(c), cvxsets, 'UniformOutput', false));
        end
    end
end
