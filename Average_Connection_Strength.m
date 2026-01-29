function mean_PLV = Average_Connection_Strength(datanew)
    % AVERAGE_CONNECTION_STRENGTH
    % Compute the average phase-locking value (PLV) across channels.
    %
    % Input:
    %   datanew : [channels × time] signal matrix
    %
    % Output:
    %   mean_PLV : 1 × channels vector representing the average
    %              connectivity strength of each channel

    [dc, ~] = size(datanew);
    plvMatrix = zeros(dc, dc);

    for ch1 = 1:dc
        for ch2 = 1:dc
            % Extract instantaneous phase sequences
            phase1 = angle(hilbert(datanew(ch1, :)));
            phase2 = angle(hilbert(datanew(ch2, :)));

            % Phase difference
            phaseDiff = phase1 - phase2;

            % Phase Locking Value (PLV)
            plv = abs(mean(exp(1i * phaseDiff)));

            % Store PLV value
            plvMatrix(ch1, ch2) = plv;
        end
    end

    % Remove self-connections
    plvMatrix(1:dc+1:end) = 0;

    % Average PLV across all connections for each channel
    mean_PLV = mean(plvMatrix, 1);

end
