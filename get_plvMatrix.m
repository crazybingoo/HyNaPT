function plvMatrix = get_plvMatrix(datanew)
    % GET_PLVMATRIX
    % Compute the Phase Locking Value (PLV) matrix for multichannel signals.
    %
    % Input:
    %   datanew : [channels × time] signal matrix
    %
    % Output:
    %   plvMatrix : [channels × channels] PLV connectivity matrix
    %               (self-connections are set to zero)

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

            % Store PLV
            plvMatrix(ch1, ch2) = plv;
        end
    end

    % Remove self-connections
    plvMatrix(1:dc+1:end) = 0;
end
