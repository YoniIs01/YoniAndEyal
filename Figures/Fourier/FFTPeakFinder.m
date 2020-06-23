function Peaks = FFTPeakFinder(md)
%FFTPEAKFINDER Summary of this function goes here
%   Detailed explanation goes here
        Y=fft(md);
        PosY = 2*Y(2:floor(length(Y)/2))/length(Y);
        dt=1;
        f=(2:(length(Y)/2))./(length(Y)*dt);
        
        Magnitude = abs(PosY);
        [peaks,frequencies] = findpeaks(Magnitude,f,'SortStr','descend');
        Threshold = mean(peaks) + 2*std(peaks);
        HighPeakIndexes = (peaks > Threshold);
        TopPeaks = peaks(HighPeakIndexes);
        TopFrequencies = frequencies(HighPeakIndexes)';
        TopPeaks = TopPeaks (1./TopFrequencies > 5);
        TopFrequencies = TopFrequencies (1./TopFrequencies > 5);
%         figure;
%         plot(f,Magnitude,'k',TopFrequencies,TopPeaks,'or');
%         text(TopFrequencies,TopPeaks,num2str(round(1./TopFrequencies)));
%         xlabel('Frequency'); ylabel('2|Xn|^2/n^2 , 2|Xn|/n');
%         title('Spectral analysis using fft');
        if (length(TopFrequencies) == 0) 
            Peaks = [];
        else
            Peaks = sortrows([1./TopFrequencies TopPeaks (TopPeaks - mean(peaks))/std(peaks)],1,'descend');
        end
end

