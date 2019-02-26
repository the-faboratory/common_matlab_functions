%% Initialize MATLAB
clc; clear; close all;

%% Plot and record video

%?==-- Select video settings (REQUIRES USER INPUT) ---==?%
movieName     = 'Kp11_Run2_Video';
frameRate     = 60;
xSize         = 800;     % Video X resolution [pixels]
ySize         = 800/2.5; % Video Y resolution [pixels]
timeWindow    = 5000;   % Window width [ms]
dataRate      = 5000;    % How many miliseconds of data to plot per second
                         % of video (1000 for realtime) [msD/msV]

dataDuration  = 50000;  % End timestep that should be plotted [ms] 
                        % If this is above the maximum timestep in the data,
                        % the movie will run until all data is plotted. 

% v.Quality   = 100;    % Default 75. Doesn't work for uncompressed
%?==-------------------------------------------------==?%

%?==------- Import Data -------==?%
% Load CSV Data (Must have ASCII encoding or it will fail with error
% "Trouble reading 'Numeric' field from file" 
CSVData = csvread('Kp11_Run2.csv');
timeData = CSVData(:,1);
timeData = timeData - timeData(1); % Set beginning time to 0 
sensorData = CSVData(:,6);
controlData = CSVData(:,7);
dataLength = size(timeData,1); % Get length of our data
maxTime = timeData(dataLength);
%?==-------------------------------------------------==?%

%?==-- Determine Plot properties (REQUIRES USER INPUT) --==?%
windowMinY = min(controlData)*1.2; % Max data value to plot (above is clipped)
windowMaxY = max(controlData)*1.2; % Min data value to plot (below is clipped)
%?==-----------------------------------------------------==?%

% Initialize video writer
% framePeriod = 1/frameRate * 1000; % Time per video frame, [ms]
dataPeriod = dataRate/frameRate; % Time ploted per frame [ms]
pointsPerFrame = timeWindow / dataPeriod;
% Example: 5000 [msD/sV] / 60 [frame/sV] = 83 [msD/frame]
v = VideoWriter(sprintf('%s.avi',movieName));
v.FrameRate = frameRate;
open(v);

% Interpolate data at time-values defined by interpolatedTimes
interpolatedTimes = 0:dataPeriod:maxTime;
sensorDataInterp = interp1(timeData, sensorData, interpolatedTimes);
controlDataInterp = interp1(timeData, controlData, interpolatedTimes);
nFrames = size(interpolatedTimes, 2);

% Set up figure for plotting (and the video frames)
fig = figure('pos',[10 10 xSize ySize]);

% Generate frames for the video
frameNumber = 0;
for ii = 1:nFrames
    currentTime = interpolatedTimes(ii);

    % Check if we have reached the max movie duration, if so, we are done
    if currentTime > dataDuration
        break;
    end
    
    % Only write a frame if enough time passed (this gets proper framerate)
    if currentTime > floor(frameNumber*dataPeriod)
        frameNumber = frameNumber + 1;
        
        % Print after generating each second of video, for predicting remaining time
        if (rem(frameNumber,frameRate) == 0)
            secondsRemaining = (dataDuration - currentTime) / 1000
        end
        
        % Shift data so comes in from the right side of the screen (0 is
        % displayed @ right)
        shiftT = interpolatedTimes - currentTime;
        
        % Find the data corresponding to our current window
        if ii < pointsPerFrame+1
            windowBeginning = 1;
        else
            windowBeginning = ii - pointsPerFrame;
        end
        
        truncatedTime = shiftT(windowBeginning:ii);
        truncatedSensor = sensorDataInterp(windowBeginning:ii);
        truncatedControl = controlDataInterp(windowBeginning:ii);
        
        % Let matlab clear figure, and plot new data
        hold off; 
        plot(truncatedTime,truncatedSensor,'LineWidth',1.5);
        hold on;
        plot(truncatedTime,truncatedControl,'LineWidth',1.5);
        
        % Format the Plot        
        ylabel("Curvature");
        legend("Sensor Data","Command Data",'Location','southoutside','orientation','horizontal');
        set(gca,'fontsize',16)
        % hold axes constant
        axis([-timeWindow 0 windowMinY windowMaxY]); % only show current window
%         axis([-timeWindow*2 timeWindow windowMinY windowMaxY]); % Wider view to verify we are only plotting necessary data
        
        % Hide the axes on the bottom
        set(gca,'XTick',[]);
        set(gca,'XTickLabel',{' '})
        
        % Show figure and save frame to the video
        drawnow
        % pause(framePeriod); % Pause, so we plot speed matches video speed
        F = getframe(fig);
        writeVideo(v,F.cdata)
    end

end

% Finish Up
close(v)
print('done')
