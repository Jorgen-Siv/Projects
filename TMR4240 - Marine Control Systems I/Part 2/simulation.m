
% Define Simulink model name
model_name = 'part2';

simChoise = 4;

if simChoise == 1
    % Simulation 1 - Wind and current
    load('eta_response.mat');
    
    % Data from wind only and current only
    eta_sim = eta_response;

    % set-point to [0 0 0] for position and heading
    set_point = [0 0 0]; % Origin

    eta_N = eta_sim(2,:);
    eta_E = eta_sim(3,:);
    eta_psi = eta_sim(4,:);

    time_sim = eta_sim(1,:);

    figure;
    hold on;
    plot(time_sim, eta_N, 'DisplayName', 'Surge', 'LineWidth', 2);
    xlabel('Time (s)', 'FontSize', 14);
    ylabel('\eta_N (m)', 'FontSize', 14);
    grid on;
    legend show;
    set(gca, 'FontSize', 12);
    
    figure;
    hold on;
    plot(time_sim, eta_E, 'DisplayName', 'Sway', 'LineWidth', 2);
    xlabel('Time (s)', 'FontSize', 14);
    ylabel('\eta_E (m)', 'FontSize', 14);
    grid on;
    legend show;
    set(gca, 'FontSize', 12);

    figure;
    hold on;
    plot(time_sim, eta_psi, 'DisplayName', 'Yaw', 'LineWidth', 2);
    xlabel('Time (s)', 'FontSize', 14);
    ylabel('\eta_{\psi} (rad)', 'FontSize', 14);
    grid on;
    legend show;
    set(gca, 'FontSize', 12);

    figure;
    hold on;
    plot(time_sim, eta_N, 'DisplayName', 'North', 'LineWidth', 2);
    plot(time_sim, eta_E, 'DisplayName', 'East', 'LineWidth', 2);
    plot(time_sim, eta_psi, 'DisplayName', 'Heading', 'LineWidth', 2);
    xlabel('Time (s)', 'FontSize', 14);
    ylabel('\eta_{N, E, \psi}', 'FontSize', 14);
    grid on;
    legend show;
    set(gca, 'FontSize', 12);

    figure;
    hold on;
    plot(eta_E, eta_N, 'DisplayName', 'Ship trajectory', 'LineWidth', 2);
    plot(eta_E(1), eta_N(1), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g', 'DisplayName', 'Start point');
    plot(eta_E(end), eta_N(end), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', 'End point');
    xlabel('East (m)', 'FontSize', 14);
    ylabel('North (m)', 'FontSize', 14);
    grid on;
    legend show;
    set(gca, 'FontSize', 12);

elseif simChoise == 2
    % Simulation 2: Varying Current
    load('eta_response.mat');
    load('nu_response.mat');
    load('tau_d.mat');
    load('desiredForce.mat');
    load('thrustForce.mat');

    eta_sim = eta_response;
    
    eta_N = eta_sim(2,:);
    eta_E = eta_sim(3,:);
    eta_psi = eta_sim(4,:);

    nu_sim = nu_response;
    
    nu_N = nu_sim(2,:);
    nu_E = nu_sim(3,:);
    nu_psi = nu_sim(4,:);

    time_sim = eta_sim(1,:);

    waypoints = [
        0 0 0;
        50 0 0;
        50 -50 0;
        50 -50 -pi/4;
        0 -50 -pi/4;
        0 0 0];

    figure;
    hold on;
    title('Surge');
    plot(time_sim, thrustForce(2,:), 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Applied force');
    plot(time_sim, tau_d(2,:), 'LineStyle', '--', 'LineWidth', 2, 'DisplayName', 'Desired force');
    xlabel('Time (s)', 'FontSize', 14);
    ylabel('Force (N)', 'FontSize', 14);
    grid on;
    legend show;
    set(gca, 'FontSize', 12);

    figure;
    hold on;
    title('Sway');
    plot(time_sim, thrustForce(3,:), 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Applied force');
    plot(time_sim, tau_d(3,:), 'LineStyle', '--', 'LineWidth', 2, 'DisplayName', 'Desired force');
    xlabel('Time (s)', 'FontSize', 14);
    ylabel('Force (N)', 'FontSize', 14);
    grid on;
    legend show;
    set(gca, 'FontSize', 12);

    figure;
    hold on;
    title('Yaw');
    plot(time_sim, thrustForce(7,:), 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Applied force');
    plot(time_sim, tau_d(4,:), 'LineStyle', '--', 'LineWidth', 2, 'DisplayName', 'Desired force');
    xlabel('Time (s)', 'FontSize', 14);
    ylabel('Moment (Nm)', 'FontSize', 14);
    grid on;
    legend show;
    set(gca, 'FontSize', 12);

    figure;
    hold on;
    title('Thrust force setpoints');
    plot(time_sim, desiredForce(2:6,:), 'LineStyle', '-', 'LineWidth', 2);
    xlabel('Time (s)', 'FontSize', 14);
    ylabel('Force (N)', 'FontSize', 14);
    grid on;
    legend('Thruster 1', 'Thruster 2', 'Thruster 3', 'Thruster 4', 'Thruster 5');
    set(gca, 'FontSize', 12);

    figure;
    hold on;
    plot(eta_E, eta_N, 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Vessel trajectory');
    plot(waypoints(:, 2), waypoints(:, 1), 'LineStyle', '--', 'LineWidth', 2, 'DisplayName', 'Desired trajectory');
    plot(waypoints(:, 2), waypoints(:, 1), 'r.', 'MarkerSize', 20, 'DisplayName', 'Set points');
    xlabel('East Position (m)', 'FontSize', 14);
    ylabel('North Position (m)', 'FontSize', 14);
    grid on;
    legend show;
    set(gca, 'FontSize', 12);

elseif simChoise == 3
    % Simulation 3:
    load('eta_response.mat');
    load('nu_response.mat');
    load('tau_d.mat');
    load('eta_r.mat');
    load('nu_r.mat');
    
    eta_sim = eta_response;
    
    eta_N = eta_sim(2,:);
    eta_E = eta_sim(3,:);
    eta_psi = eta_sim(4,:);
    
    etar_N = eta_r(2,:);
    etar_E = eta_r(3,:);
    etar_psi = eta_r(4,:);
    
    nu_sim = nu_response;
    
    nu_N = nu_sim(2,:);
    nu_E = nu_sim(3,:);
    nu_psi = nu_sim(4,:);
    
    nur_N = nu_r(2,:);
    nur_E = nu_r(3,:);
    nur_psi = nu_r(4,:);
    
    time_sim = eta_sim(1,:);
    
    waypoints = [
        0 0 0;
        50 0 0;
        50 -50 0;
        50 -50 -pi/4;
        0 -50 -pi/4;
        0 0 0];
    
    % Settings for line width and font size
    line_width = 2;
    font_size = 14;
    
    figure;
    hold on;
    plot(eta_E, eta_N, 'LineStyle', '-', 'LineWidth', line_width, 'DisplayName', 'Vessel trajectory'); % North (x) vs East (y)
    plot(waypoints(:, 2), waypoints(:, 1), 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', 'Desired trajectory');
    plot(waypoints(:, 2), waypoints(:, 1), 'r.', 'MarkerSize', 30, 'DisplayName', 'Set points');
    xlabel('East Position (m)', 'FontSize', font_size);
    ylabel('North Position (m)', 'FontSize', font_size);
    grid on;
    legend show;
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Surge');
    plot(time_sim, nu_N, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', 'Ship velocity');
    plot(time_sim, nur_N, 'LineStyle', '-', 'LineWidth', line_width, 'DisplayName', 'Reference velocity');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\nu_{N} (m/s)', 'FontSize', font_size);
    grid on;
    legend show;
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Sway');
    plot(time_sim, nu_E, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', 'Ship velocity');
    plot(time_sim, nur_E, 'LineStyle', '-', 'LineWidth', line_width, 'DisplayName', 'Reference velocity');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\nu_{E} (m/s)', 'FontSize', font_size);
    grid on;
    legend show;
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Yaw');
    plot(time_sim, nu_psi, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', 'Ship velocity');
    plot(time_sim, nur_psi, 'LineStyle', '-', 'LineWidth', line_width, 'DisplayName', 'Reference velocity');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\nu_{\psi} (rad/s)', 'FontSize', font_size);
    grid on;
    legend show;
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Surge');
    plot(time_sim, eta_N, 'LineStyle', '-', 'LineWidth', line_width, 'DisplayName', 'Ship trajectory');
    plot(time_sim, etar_N, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', 'Reference trajectory');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\eta_N (m)', 'FontSize', font_size);
    grid on;
    legend show;
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Sway');
    plot(time_sim, eta_E, 'LineStyle', '-', 'LineWidth', line_width, 'DisplayName', 'Ship trajectory');
    plot(time_sim, etar_E, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', 'Reference trajectory');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\eta_E (m)', 'FontSize', font_size);
    grid on;
    legend show;
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Yaw');
    plot(time_sim, eta_psi, 'LineStyle', '-', 'LineWidth', line_width, 'DisplayName', 'Ship trajectory');
    plot(time_sim, eta_psi, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', 'Reference trajectory');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\eta_{\psi} (rad)', 'FontSize', font_size);
    grid on;
    legend show;
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    plot(time_sim, eta_N, 'LineWidth', line_width, 'DisplayName', 'North');
    plot(time_sim, eta_E, 'LineWidth', line_width, 'DisplayName', 'East');
    plot(time_sim, eta_psi, 'LineWidth', line_width, 'DisplayName', 'Heading');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\eta_{N, E, \psi}', 'FontSize', font_size);
    grid on;
    legend show;
    set(gca, 'FontSize', font_size);


elseif simChoise == 4
    % Simulation 4: DP Corner Test
    
    waypoints = [
        0 0 0;
        50 0 0;
        50 -50 0;
        50 -50 -pi/4;
        0 -50 -pi/4;
        0 0 0];

    load('eta_response.mat');
    load('nu_response.mat');
    load('observer_response.mat');
    load('observer_nu.mat');
    load('kalman_response.mat');
    load('kalman_nu.mat');
    load('nu_response.mat');
    load('eta_r.mat');
    load('nu_r.mat');
    
    
    eta_obs = eta_observer;
    nu_obs = nu_observer;
    eta_kal = eta_kalman;
    nu_kal = nu_kalman;
    %{
    nu_sim = data.get('nu').Values.Data;

    etar_sim = data.get('eta_r').Values.Data;
    nur_sim = data.get('nu_r').Values.Data;
    %}
    eta_sim = eta_response;
    
    eta_N = eta_sim(2,:);
    eta_E = eta_sim(3,:);
    eta_psi = eta_sim(4,:);
    
    etar_N = eta_r(2,:);
    etar_E = eta_r(3,:);
    etar_psi = eta_r(4,:);
    
    nu_sim = nu_response;
    
    nu_N = nu_sim(2,:);
    nu_E = nu_sim(3,:);
    nu_psi = nu_sim(4,:);
    
    nur_N = nu_r(2,:);
    nur_E = nu_r(3,:);
    nur_psi = nu_r(4,:);

    eta_N_obs = eta_obs(2,:); 
    eta_E_obs = eta_obs(3,:);
    eta_psi_obs = eta_obs(4,:);
    nu_N_obs = nu_obs(2,:); 
    nu_E_obs = nu_obs(3,:);
    nu_psi_obs = nu_obs(4,:);

    eta_N_kal = eta_kal(2,:); 
    eta_E_kal = eta_kal(3,:);
    eta_psi_kal = eta_kal(4,:);
    nu_N_kal = nu_kal(2,:); 
    nu_E_kal = nu_kal(3,:);
    nu_psi_kal = nu_kal(4,:);


    time_sim = eta_sim(1,:);

    line_width = 2;
    font_size = 14;
    
    % Observer
    % figure;
    % hold on;
    % title('Surge');
    % plot(time_sim, nu_N, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\nu$');
    % plot(time_sim, nu_N_obs, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\nu}$');
    % xlabel('Time (s)', 'FontSize', font_size);
    % ylabel('\nu_{N} (m/s)', 'FontSize', font_size);
    % grid on;
    % legend('Interpreter', 'latex');
    % set(gca, 'FontSize', font_size);
    % 
    % figure;
    % hold on;
    % title('Sway');
    % plot(time_sim, nu_E, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\nu$');
    % plot(time_sim, nu_E_obs, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\nu}$');
    % xlabel('Time (s)', 'FontSize', font_size);
    % ylabel('\nu_{E} (m/s)', 'FontSize', font_size);
    % grid on;
    % legend('Interpreter', 'latex');
    % set(gca, 'FontSize', font_size);
    % 
    % figure;
    % hold on;
    % title('Yaw');
    % plot(time_sim, nu_psi, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\nu$');
    % plot(time_sim, nu_psi_obs, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\nu}$');
    % xlabel('Time (s)', 'FontSize', font_size);
    % ylabel('\nu_{\psi} (rad/s)', 'FontSize', font_size);
    % grid on;
    % legend('Interpreter', 'latex');
    % set(gca, 'FontSize', font_size);
    % 
    % figure;
    % hold on;
    % title('Surge');
    % plot(time_sim, eta_N, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\eta$');
    % plot(time_sim, eta_N_obs, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\eta}$');
    % xlabel('Time (s)', 'FontSize', font_size);
    % ylabel('\eta_N (m)', 'FontSize', font_size);
    % grid on;
    % legend('Interpreter', 'latex');
    % set(gca, 'FontSize', font_size);
    % 
    % figure;
    % hold on;
    % title('Sway');
    % plot(time_sim, eta_E, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\eta$');
    % plot(time_sim, eta_E_obs, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\eta}$');
    % xlabel('Time (s)', 'FontSize', font_size);
    % ylabel('\eta_E (m)', 'FontSize', font_size);
    % grid on;
    % legend('Interpreter', 'latex');
    % set(gca, 'FontSize', font_size);
    % 
    % figure;
    % hold on;
    % title('Yaw');
    % plot(time_sim, eta_psi, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\eta$');
    % plot(time_sim, eta_psi_obs, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\eta}$');
    % xlabel('Time (s)', 'FontSize', font_size);
    % ylabel('\eta_{\psi} (rad)', 'FontSize', font_size);
    % grid on;
    % legend('Interpreter', 'latex');
    % set(gca, 'FontSize', font_size);


    %Kalman
    figure;
    hold on;
    title('Surge');
    plot(time_sim, nu_N, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\nu$');
    plot(time_sim, nu_N_kal, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\nu}$');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\nu_{N} (m/s)', 'FontSize', font_size);
    grid on;
    legend('Interpreter', 'latex');
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Sway');
    plot(time_sim, nu_E, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\nu$');
    plot(time_sim, nu_E_kal, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\nu}$');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\nu_{E} (m/s)', 'FontSize', font_size);
    grid on;
    legend('Interpreter', 'latex');
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Yaw');
    plot(time_sim, nu_psi, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\nu$');
    plot(time_sim, nu_psi_kal, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\nu}$');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\nu_{\psi} (rad/s)', 'FontSize', font_size);
    grid on;
    legend('Interpreter', 'latex');
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Surge');
    plot(time_sim, eta_N, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\eta$');
    plot(time_sim, eta_N_kal, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\eta}$');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\eta_N (m)', 'FontSize', font_size);
    grid on;
    legend('Interpreter', 'latex');
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Sway');
    plot(time_sim, eta_E, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\eta$');
    plot(time_sim, eta_E_kal, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\eta}$');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\eta_E (m)', 'FontSize', font_size);
    grid on;
    legend('Interpreter', 'latex');
    set(gca, 'FontSize', font_size);
    
    figure;
    hold on;
    title('Yaw');
    plot(time_sim, eta_psi, 'LineStyle', '-', 'LineWidth', 1, 'DisplayName', '$\eta$');
    plot(time_sim, eta_psi_kal, 'LineStyle', '--', 'LineWidth', line_width, 'DisplayName', '$\hat{\eta}$');
    xlabel('Time (s)', 'FontSize', font_size);
    ylabel('\eta_{\psi} (rad)', 'FontSize', font_size);
    grid on;
    legend('Interpreter', 'latex');
    set(gca, 'FontSize', font_size);
    

end

