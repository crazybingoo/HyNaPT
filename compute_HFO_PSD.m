function psd_hfo = compute_HFO_PSD(datanew)
    % COMPUTE_HFO_PSD
    % Compute the power spectral density (PSD) of high-frequency
    % oscillations (HFOs) in the 30–80 Hz band from SEEG signals.
    %
    % Input:
    %   datanew : [channels × time] SEEG signal matrix
    %
    % Output:
    %   psd_hfo : column vector containing HFO band power for each channel

    [num_channels, ~] = size(datanew);   % Number of channels
    psd_hfo = zeros(num_channels, 1);    % Store HFO PSD per channel

    for ch = 1:num_channels
        % Compute power spectral density using Welch's method
        [Pxx, F] = pwelch(datanew(ch, :), ...
                          hamming(1024), ...
                          512, ...
                          2048, ...
                          1024);

        % Select the 30–80 Hz frequency band
        idx = (F >= 30 & F <= 80);

        % Integrate PSD over the HFO band
        psd_hfo(ch) = trapz(F(idx), Pxx(idx));
    end
end
