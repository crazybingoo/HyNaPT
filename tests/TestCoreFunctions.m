classdef TestCoreFunctions < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addRepositoryPaths(~)
            repoRoot = fileparts(fileparts(mfilename('fullpath')));
            addpath(repoRoot);
            startup;
        end
    end

    methods (Test)
        function gaussianSimilarityIsFinite(testCase)
            similarity = GK_Similarity(ones(4, 3));
            testCase.verifySize(similarity, [4, 4]);
            testCase.verifyTrue(all(isfinite(similarity), 'all'));
            testCase.verifyEqual(diag(similarity), ones(4, 1));
        end

        function connectionTypesIncludeIsolatedNode(testCase)
            hyperEdges = {[1, 2, 3], [3, 4], [5, 6]};
            [types, counts] = find_node_pair_connections(hyperEdges, 7);
            testCase.verifyEqual(types(1, 2), 1);
            testCase.verifyEqual(types(1, 4), 2);
            testCase.verifyEqual(types(1, 5), 4);
            testCase.verifyEqual(types(1, 7), 4);
            testCase.verifyGreaterThan(counts.sameHyperEdge, 0);
        end

        function slidingWindowUsesZeroBasedIndex(testCase)
            signal = reshape(1:40, 2, 20);
            cfg = struct('sampleRate', 2, 'windowSeconds', 3, 'stepSeconds', 1);
            window = get_sliding_window(signal, 1, cfg);
            testCase.verifyEqual(window, signal(:, 3:8));
        end

        function featurePipelineRunsOnSyntheticSignal(testCase)
            results = synthetic_demo;
            testCase.verifyEqual(numel(results.hypergraphs), 3);
            testCase.verifySize(results.similarity{1}, [6, 6]);
            testCase.verifyTrue(all(isfinite(results.similarity{1}), 'all'));
        end
    end
end
