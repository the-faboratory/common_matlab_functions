%% Initialize MATLAB
clc; clear; close all;

%% Plot and record video

%?==-- Select video settings (REQUIRES USER INPUT) ---==?%
movie_name     = 'Kp11_Run2_Video';
frame_rate     = 60;
x_size         = 800;     % Video X resolution [pixels]
y_size         = 800/2.5; % Video Y resolution [pixels]
time_window    = 5000;   % Window width [ms]
data_rate      = 5000;    % How many miliseconds of data to plot per second
                         % of video (1000 for realtime) [msD/msV]

data_duration  = 5000;  % End timestep that should be plotted [ms] 
                        % If this is above the maximum timestep in the data,
                        % the movie will run until all data is plotted. 

% v.Quality   = 100;    % Default 75. Doesn't work for uncompressed
%?==-------------------------------------------------==?%

%?==------- Import Data -------==?%
% Load CSV Data (Must have ASCII encoding or it will fail with error
% "Trouble reading 'Numeric' field from file" 
all_data = csvread('Kp11_Run2.csv'); % USER
time_column = 1; % USER
data_1_column = 6; % USER
data_2_column = 7; % USER

time_data = all_data(:, time_column);
time_data = time_data - time_data(1); % Set beginning time to 0 
data_1 = all_data(:, data_1_column);
data_2 = all_data(:, data_2_column);
dataLength = size(time_data, 1);
maxTime = time_data(dataLength);
%?==-------------------------------------------------==?%

%?==-- Determine Plot properties (REQUIRES USER INPUT) --==?%
window_min_y = min(data_2)*1.2; % Max data value to plot (above is clipped)
window_max_y = max(data_2)*1.2; % Min data value to plot (below is clipped)
%?==-----------------------------------------------------==?%

% Initialize video writer
% framePeriod = 1/frame_rate * 1000; % Time per video frame, [ms]
data_period = data_rate/frame_rate; % Time ploted per frame [ms]
points_per_frame = time_window / data_period;
% Example: 5000 [msD/sV] / 60 [frame/sV] = 83 [msD/frame]
our_video = VideoWriter(sprintf('%s.avi', movie_name));
our_video.FrameRate = frame_rate;
open(our_video);

% Interpolate data at time-values defined by interpolated_times
interpolated_times = 0:data_period:maxTime;
data_1_interp = interp1(time_data, data_1, interpolated_times);
data_2_interp = interp1(time_data, data_2, interpolated_times);
number_of_frames = size(interpolated_times, 2);

% Set up figure for plotting (and the video frames)
fig = figure('pos',[10 10 x_size y_size]);

% Generate frames for the video
frame_number = 0;
for ii = 1:number_of_frames
    current_time = interpolated_times(ii);

    % Check if we have reached the max movie duration, if so, we are done
    if current_time > data_duration
        break;
    end
    
    % Only write a frame if enough time passed (this gets proper frame_rate)
    if current_time > floor(frame_number*data_period)
        frame_number = frame_number + 1;
        
        % Print after generating each second of video, for predicting remaining time
        if (rem(frame_number,frame_rate) == 0)
            seconds_remaining = (data_duration - current_time) / 1000
        end
        
        % Shift data so comes in from the right side of the screen (0 is
        % displayed @ right)
        shifted_times = interpolated_times - current_time;
        
        % Find the data corresponding to our current window
        if ii < points_per_frame+1
            window_beginning = 1;
        else
            window_beginning = ii - points_per_frame;
        end
        
        truncated_time = shifted_times(window_beginning:ii);
        truncated_data_1 = data_1_interp(window_beginning:ii);
        truncated_data_2 = data_2_interp(window_beginning:ii);
        
        % Let matlab clear figure, and plot new data
        hold off; 
        plot(truncated_time, truncated_data_1, 'LineWidth', 1.5);
        hold on;
        plot(truncated_time, truncated_data_2, 'LineWidth', 1.5);
        
        % Format the Plot        
        ylabel("Curvature");
        legend("Sensor Data", "Command Data", 'Location', 'southoutside', 'orientation', 'horizontal');
        set(gca, 'fontsize', 16)
        % hold axes constant
        axis([-time_window 0 window_min_y window_max_y]); % only show current window
%         axis([-time_window*2 time_window window_min_y window_max_y]); % Wider view to verify we are only plotting necessary data
        
        % Hide the axes on the bottom
        set(gca, 'XTick', []);
        set(gca, 'XTickLabel', {' '})
        
        % Show figure and save frame to the video
        drawnow
        % pause(framePeriod); % Pause, so we plot speed matches video speed
        frame = getframe(fig);
        writeVideo(our_video, frame.cdata)
    end

end

% Finish Up
close(our_video)
disp('done')
