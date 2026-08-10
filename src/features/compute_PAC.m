function [pac_values, MI] = compute_PAC(datanew)
    % COMPUTE_PAC
    % Compute Phase–Amplitude Coupling (PAC) and Modulation Index (MI).
    %
    % PAC measures the direct influence of instantaneous low-frequency
    % phase on high-frequency amplitude, which is suitable for
    % short-time window analysis.
    %
    % MI measures whether high-frequency amplitude is preferentially
    % modulated by specific low-frequency phases, and is more suitable
    % for long-term brain region analysis.
    %
    % Input:
    %   datanew : [channels × time] signal matrix
    %
    % Output:
    %   pac_values : column vector of PAC values for each channel
    %   MI         : column vector of Modulation Index (MI) values

    num_channels = size(datanew, 1);        % Number of channels
    pac_values = zeros(num_channels, 1);    % Preallocate PAC results
    MI = zeros(num_channels, 1);            % Preallocate Modulation Index

    for ch = 1:num_channels
        % Extract signal from the current channel
        signal = datanew(ch, :);

        %% ===================== Low-Frequency Phase =====================
        % Bandpass filter to extract low-frequency component (theta band)
        low_freq_signal = bandpass(signal, [4 8], 1024);
        low_phase = angle(hilbert(low_freq_signal));

        %% ===================== High-Frequency Amplitude =====================
        % Bandpass filter to extract high-frequency component (HFO band)
        high_freq_signal = bandpass(signal, [30 80], 1024);
        high_amplitude = abs(hilbert(high_freq_signal));

        %% ===================== Phase–Amplitude Coupling =====================
        pac_values(ch) = abs(mean(high_amplitude .* exp(1j * low_phase)));

        %% ===================== Modulation Index (MI) =====================
        % Divide phase into bins
        bins = linspace(-pi, pi, 18);
        amp_per_bin = zeros(1, length(bins) - 1);

        % Compute mean high-frequency amplitude within each phase bin
        for i = 1:length(bins) - 1
            idx = (low_phase >= bins(i)) & (low_phase < bins(i + 1));
            amp_per_bin(i) = mean(high_amplitude(idx));
        end

        % Normalize amplitude distribution
        amp_per_bin = amp_per_bin / sum(amp_per_bin);

        % Shannon entropy
        H = -sum(amp_per_bin .* log(amp_per_bin + eps));

        % Normalized Modulation Index
        MI(ch) = (log(length(bins) - 1) - H) / log(length(bins) - 1);
    end
end
