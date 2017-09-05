classdef SIUnits
   properties (Constant)
      % Time
      s = 1                     % second
      min = 60                  % minute
      h = 3600                  % hour
      sd = 86164.09054          % sidereal day
      d = 86400                 % julian day
      y = 3.15576e7             % julian year
      sy = 3.1558149504e7       % sidereal year
      
      % Distance
      m = 1                     % meter
      km = 1e3                  % kilometer
      au = 1.49597870691e11     % astronomical unit
      
      % Angle
      rad = 1                   % radian
      deg = pi/180              % degree
   end
end
