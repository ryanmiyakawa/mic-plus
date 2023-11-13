classdef Log < mic.ui.common.Base
    
    
    properties
        cLogDirectory
        cLogName
        cLogPath
    end
    
    methods
        function this = Log(cLogDirectory, cLogName, ceHeaders)
            this.cLogDirectory = cLogDirectory;
            this.cLogName = cLogName;
            
            try
                this.writeLine(ceHeaders, true);
            catch
                error('Cannot find log directory %s', cLogDirectory);
            end
        end
        
        function writeLine(this, ceLogElements, isHeader)
            
            logPath = fullfile(this.cLogDirectory, [this.cLogName '.csv']);
            this.cLogPath = logPath;
            
            nl = java.lang.System.getProperty('line.separator').char;
            
            if nargin < 3
                isHeader = false;
            end
            
            fopenTag = 'a';
            
            fid = fopen(this.cLogPath, fopenTag);
            
            if isHeader
                str = 'Timestamp, Posixtime_ms';
            else
                str = [datestr(now, 31) ',' sprintf('%d', micPlus.Log.getPosixTimeMs()) ];
            end
            
            if iscell(ceLogElements)
                if length(ceLogElements) == 1
                    str = sprintf('%s,%s', str, ceLogElements{1});
                else
                    for k = 1:length(ceLogElements)
                        str = sprintf('%s, %s', str, ceLogElements{k});
                        
                        if k == length(ceLogElements)
                            str = sprintf('%s', str);
                        end
                    end
                end
            else
                str = sprintf('%s,%s', str, ceLogElements);
            end
            
            fwrite(fid, str);
            fprintf(fid, nl);
            fclose(fid);
            
        end
        
        function appendElapsedTime(this)
            % Read the CSV file
            data = readtable(this.cLogPath);
            
            % Calculate elapsed time
            posixTimes = data.Posixtime_ms; % Adjusted for your column name
            elapsedTimes = [diff(posixTimes); 0]/1000; % Last row has no previous timestamp
            
            % Add elapsed time to the table
            data.ElapsedTime_s = elapsedTimes;
            
            % Write the modified table to a new CSV file
            writetable(data, this.cLogPath);
            
        end
        
    end
    
    methods (Static)
        function posixTimeMilliseconds = getPosixTimeMs()
            currentTime = datetime('now', 'Format', 'dd-MMM-yyyy HH:mm:ss.SSS');
            epoch = datetime(1970, 1, 1, 'TimeZone', currentTime.TimeZone);
            timeSinceEpoch = currentTime - epoch;
            totalSeconds = seconds(timeSinceEpoch);
            posixTimeMilliseconds = int64(totalSeconds * 1000);
        end
        
        
        
    end
end

