%% Unpack data from file

function joint = unpack(joint_name)
prompt = 'Set file name to unpack: ';
str = input(prompt);
load(str);

%% Joint
%% Roll
if exist('roll_motor_r') && joint_name == "roll"
   joint.position.time = roll_motor_r.joints_state_samples.time - roll_motor_r.joints_state_samples.time(1);
   joint.position.signal = roll_motor_r.joints_state_samples.position;
   joint.effort = roll_motor_r.joints_state_samples.effort;
end
%% Pitch
if exist('pitch_motor_r') && joint_name == "pitch"
   joint.position.time = pitch_motor_r.joints_state_samples.time - pitch_motor_r.joints_state_samples.time(1);
   joint.position.signal = pitch_motor_r.joints_state_samples.position;
   joint.effort = pitch_motor_r.joints_state_samples.effort;
end

%% Yaw
if exist('yaw_motor_r') && joint_name == "yaw"
   joint.position.time = yaw_motor_r.joints_state_samples.time - yaw_motor_r.joints_state_samples.time(1);
   joint.position.signal = yaw_motor_r.joints_state_samples.position;
   joint.effort = yaw_motor_r.joints_state_samples.effort;
end

%% Joint_ref
% Static parameter estimation
if exist('joint_friction_identification_constant_velocity')
   joint.ref.time = joint_friction_identification_constant_velocity.joint_velocity_ref.time - joint_friction_identification_constant_velocity.joint_velocity_ref.time(1);
   joint.ref.position = joint_friction_identification_constant_velocity.joint_velocity_ref.position;
   joint.ref.vel = joint_friction_identification_constant_velocity.joint_velocity_ref.speed;
end

% Dynamic parameter estimation
if exist('joint_friction_identification_sine_effort')
   joint.ref.time = joint_friction_identification_sine_effort.joint_effort_ref.time - joint_friction_identification_sine_effort.joint_effort_ref.time(1);
   joint.ref.effort = joint_friction_identification_sine_effort.joint_effort_ref.effort;
end


% %% Joint_obs
% if exist('joint_obs')
%    joint.est.time = joint_obs.jointsOut.time - yaw_motor_r.joints_state_samples.time(1);
%    joint.est.position = joint_obs.jointsOut.position;
%    joint.est.vel = joint_obs.jointsOut.speed;
%    joint.est.acc = joint_obs.jointsOut.acceleration;
% end

%% Friction_compensation
if exist('friction_compensation')
   joint.friction.time = friction_compensation.effortOut.time - friction_compensation.effortOut.time(1);
   joint.friction.effortPID = friction_compensation.effortOut.effort;
   joint.friction.friction = friction_compensation.friction;
end

if exist('joint_obs')  && joint_name == "roll"
   joint.vel.time = joint_obs.jointsOut.time - roll_motor_r.joints_state_samples.time(1);
   joint.vel.signal = joint_obs.jointsOut.speed;
end

if exist('joint_obs')  && joint_name == "pitch"
   joint.vel.time = joint_obs.jointsOut.time - pitch_motor_r.joints_state_samples.time(1);
   joint.vel.signal = joint_obs.jointsOut.speed;
end

if exist('joint_obs')  && joint_name == "yaw"
   joint.vel.time = joint_obs.jointsOut.time - yaw_motor_r.joints_state_samples.time(1);
   joint.vel.signal = joint_obs.jointsOut.speed;
end