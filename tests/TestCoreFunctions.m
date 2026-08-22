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

        function connectionTypesCoverFourCases(testCase)
            hyperEdges = {[1, 2], [2, 3], [3, 4], [5, 6]};
            [types, counts] = find_node_pair_connections(hyperEdges, 6);
            testCase.verifyEqual(types(1, 2), 1);
            testCase.verifyEqual(types(1, 3), 2);
            testCase.verifyEqual(types(1, 4), 3);
            testCase.verifyEqual(types(1, 5), 4);
            testCase.verifyGreaterThan(counts.sameHyperEdge, 0);
            testCase.verifyGreaterThan(counts.adjacentHyperEdge, 0);
            testCase.verifyGreaterThan(counts.indirectlyConnected, 0);
            testCase.verifyGreaterThan(counts.notConnected, 0);
        end

        function slidingWindowUsesZeroBasedIndex(testCase)
            signal = reshape(1:40, 2, 20);
            cfg = struct('sampleRate', 2, 'windowSeconds', 3, 'stepSeconds', 1);
            window = get_sliding_window(signal, 1, cfg);
            testCase.verifyEqual(window, signal(:, 3:8));
        end

        function densityElbowIsInteriorAndUnique(testCase)
            plv = [0 .90 .80 .70; .90 0 .20 .10; ...
                .80 .20 0 .05; .70 .10 .05 0];
            [threshold, curve] = select_density_elbow_threshold(plv, 0:0.1:1);
            testCase.verifyGreaterThan(threshold, 0);
            testCase.verifyLessThan(threshold, 1);
            testCase.verifyEqual(sum(curve.isElbow), 1);
            testCase.verifyLessThanOrEqual(max(diff(curve.meanDensity)), 0);
        end

        function phaseCOCIsBounded(testCase)
            phase = linspace(-pi, pi, 2048)';
            locked = [phase, phase, phase];
            coc = phase_coc(locked);
            testCase.verifyGreaterThanOrEqual(coc, 0);
            testCase.verifyLessThanOrEqual(coc, 1);
            testCase.verifyEqual(coc, 1, 'AbsTol', 1e-10);
        end

        function isolatedRowsBecomeUniform(testCase)
            weights = [0 2 0; 0 0 0; 1 0 0];
            P = make_row_stochastic(weights);
            testCase.verifyEqual(diag(P), zeros(3, 1), 'AbsTol', 1e-12);
            testCase.verifyEqual(sum(P, 2), ones(3, 1), 'AbsTol', 1e-12);
            testCase.verifyEqual(P(2, [1, 3]), [0.5, 0.5], 'AbsTol', 1e-12);
        end

        function fourCaseTransitionIsStochasticAndAsymmetric(testCase)
            n = 6;
            hyper = struct;
            hyper.edges = {[1, 2], [2, 3], [3, 4], [5, 6]};
            hyper.edgeWeights = [0.9; 0.7; 0.6; 0.4];
            hyper.dc = n;
            hyper.degree = d_u(hyper.edges, n)';
            hyper.pairwisePLV = 0.2 .* (ones(n) - eye(n));
            similarity = 0.7 .* (ones(n) - eye(n));
            [P, diagnostic] = assemble_transition_matrix(zeros(n, 32), ...
                hyper, similarity);
            testCase.verifyEqual(sum(P, 2), ones(n, 1), 'AbsTol', 1e-12);
            testCase.verifyEqual(diag(P), zeros(n, 1), 'AbsTol', 1e-12);
            testCase.verifyTrue(all(isfinite(P), 'all'));
            testCase.verifyGreaterThan(max(abs(P - P'), [], 'all'), 0);
            testCase.verifyEqual(diagnostic.connectionType(1, 4), 3);
            testCase.verifyGreaterThan(diagnostic.rawScores(1, 4), 0);
        end

        function temporalFusionPreservesBoundary(testCase)
            first = make_row_stochastic([0 3 1; 1 0 2; 4 1 0]);
            second = make_row_stochastic([0 1 2; 3 0 1; 1 4 0]);
            for alpha = [0.25, 0.50, 0.75]
                Q = fuse_transition_matrices(first, second, alpha);
                testCase.verifyEqual(sum(Q, 2), ones(3, 1), 'AbsTol', 1e-12);
                testCase.verifyEqual(diag(Q), zeros(3, 1), 'AbsTol', 1e-12);
            end
        end

        function featurePipelineRunsOnSyntheticSignal(testCase)
            results = synthetic_demo;
            testCase.verifyEqual(numel(results.hypergraphs), 3);
            testCase.verifyEqual(numel(results.transition), 3);
            testCase.verifyEqual(numel(results.dynamicTransition), 2);
            testCase.verifySize(results.similarity{1}, [6, 6]);
            testCase.verifyTrue(all(isfinite(results.transition{1}), 'all'));
        end

        function exactRegionalConcordanceUsesFixedScores(testCase)
            result = evaluate_regional_concordance( ...
                [0.9; 0.8; 0.2; 0.1], [1; 1; 0; 0]);
            testCase.verifyEqual(result.observedAP, 1, 'AbsTol', 1e-12);
            testCase.verifyEqual(numel(result.nullDistribution), 6);
            testCase.verifyGreaterThan(result.normalizedLift, 0);
        end

        function cohortConcordanceIsDeterministic(testCase)
            scores = {[0.9; 0.8; 0.2; 0.1]; [0.7; 0.6; 0.3; 0.2]};
            labels = {[1; 1; 0; 0]; [1; 0; 1; 0]};
            first = summarize_regional_concordance(scores, labels, ...
                'BootstrapSamples', 200, 'JointSamples', 500, 'Seed', 7);
            second = summarize_regional_concordance(scores, labels, ...
                'BootstrapSamples', 200, 'JointSamples', 500, 'Seed', 7);
            testCase.verifyEqual(first.normalizedLiftCI, ...
                second.normalizedLiftCI, 'AbsTol', 0);
            testCase.verifyEqual(first.twoSidedJointPermutationP, ...
                second.twoSidedJointPermutationP, 'AbsTol', 0);
        end

        function transitionPathSupportsArgmaxAndTopM(testCase)
            Q = [0 0.7 0.3; 0.2 0 0.8; 0.6 0.4 0];
            argmaxPath = generate_transition_path(Q, 1, ...
                'Steps', 3, 'CandidateFraction', 0);
            sampledPath = generate_transition_path(Q, 1, ...
                'Steps', 3, 'CandidateFraction', 0.5, ...
                'NumSamples', 100, 'Seed', 3);
            testCase.verifyEqual(argmaxPath, [1 2 3 1]);
            testCase.verifyEqual(sampledPath, argmaxPath);
        end
    end
end
