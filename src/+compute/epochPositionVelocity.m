function [epoch,position,velocity] = epochPositionVelocity(statesHistory)
epoch = statesHistory(:,1);
position = statesHistory(:,2:4);
velocity = statesHistory(:,5:7);
