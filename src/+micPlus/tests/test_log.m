addpath ..

cLogDirectory = fullfile(fileparts(mfilename('fullpath')), 'logs');
cLogName = sprintf('MET-FEM-%s', datestr(now,30));
ceHeaders = {'message1', 'message2'};

hLog = micPlus.Log(cLogDirectory, cLogName, ceHeaders);


hLog.writeLine({'test1', 'test2'});
pause(2)
hLog.writeLine({'test3', 'test5'});
pause(3)
hLog.writeLine({'test5', 'test6'});


% append delta times
hLog.appendElapsedTime();