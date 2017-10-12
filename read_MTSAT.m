
thisNamefile = name_input_file;
%read SSP lat,lon 20141021
nominal_SSP_lon = ncread(name_input_file,'nominal_ssp_longitude');%degsEast
nominal_SSP_lat = ncread(name_input_file,'nominal_ssp_latitude');%degsWest
vis_space_resol = ncread(name_input_file,'vis_spacial_resolution')
ir_space_resol  = ncread(name_input_file,'ir_spacial_resolution')

% read visible channel
vis_latitude = ncread(name_input_file, 'vis_latitude');
vis_longitude = ncread(name_input_file, 'vis_longitude');
vis_scan_time = ncread(name_input_file, 'vis_scan_time');
vis_radiance_table   = ncread(name_input_file, 'vis_radiance_table');
vis_count  = ncread(name_input_file, 'vis_count');

%20141020 read obs_time and data_tieme_se
data_start_time = ncread(name_input_file, 'data_start_time');
data_end_time   = ncread(name_input_file, 'data_end_time');
obs_start_time  = ncread(name_input_file, 'observation_start_time');
obs_end_time    = ncread(name_input_file, 'observation_end_time');

%fprintf('%s\n','data_start_time');fprintf('%d\n',data_start_time);
%pause;
%20141023 add 15mins to all nc times !!
%data_start_time = obs_start_time+15;
%data_end_time = obs_end_time+15;
%vis_scan_time = vis_scan_time+15*60;

%l-t lat & r-b lat
left_top_lat = ncread(name_input_file, 'left_top_latitude');
right_bottom_lat = ncread(name_input_file, 'right_bottom_latitude');

% read IR channels
ir_latitude = ncread(name_input_file, 'ir_latitude');
ir_longitude = ncread(name_input_file, 'ir_longitude');
ir_scan_time = ncread(name_input_file, 'ir_scan_time');
%fprintf('%s\n','ir_scan_time');fprintf('%d\n',ir_scan_time(ir_scan_time>0)/1E4);
%pause;
%%20141023 
%ir_scan_time =ir_scan_time.+15*60;
%fprintf('%s\n','ir_scan_time');fprintf('%d\n',ir_scan_time(ir_scan_time>0)/1E4);
%pause;

ir1_number_of_levels = ncread(name_input_file, 'ir1_number_of_levels');
ir1_radiance_table = ncread(name_input_file, 'ir1_radiance_table');   
ir1_count = ncread(name_input_file, 'ir1_count');
ir2_number_of_levels = ncread(name_input_file, 'ir2_number_of_levels');
ir2_radiance_table = ncread(name_input_file, 'ir2_radiance_table');   
ir2_count = ncread(name_input_file, 'ir2_count');
ir3_number_of_levels = ncread(name_input_file, 'ir3_number_of_levels');
ir3_radiance_table = ncread(name_input_file, 'ir3_radiance_table');   
ir3_count = ncread(name_input_file, 'ir3_count');
ir4_number_of_levels = ncread(name_input_file, 'ir4_number_of_levels');
ir4_radiance_table = ncread(name_input_file, 'ir4_radiance_table');   
ir4_count = ncread(name_input_file, 'ir4_count');
%
ir1_temperature_table = ncread(name_input_file, 'ir1_temperature_table');
ir2_temperature_table = ncread(name_input_file, 'ir2_temperature_table');
ir3_temperature_table = ncread(name_input_file, 'ir3_temperature_table');
ir4_temperature_table = ncread(name_input_file, 'ir4_temperature_table');

% convert in radiance
vis_count_radiance = -ones(size(vis_count, 1), size(vis_count, 2));
reslocal = find(vis_count > 0);
vis_count_radiance(reslocal) = vis_radiance_table(vis_count(reslocal));
clear reslocal

ir1_count_radiance = -ones(size(ir1_count, 1), size(ir1_count, 2));
reslocal = find(ir1_count > 0);
ir1_count_radiance(reslocal) = ir1_radiance_table(ir1_count(reslocal));
ir1_count_temperature = -ones(size(ir1_count, 1), size(ir1_count, 2));
ir1_count_temperature(reslocal) = ir1_temperature_table(ir1_count(reslocal));
clear reslocal

ir2_count_radiance = -ones(size(ir2_count, 1), size(ir2_count, 2));
reslocal = find(ir2_count > 0);
ir2_count_radiance(reslocal) = ir2_radiance_table(ir2_count(reslocal));
ir2_count_temperature = -ones(size(ir2_count, 1), size(ir2_count, 2));
ir2_count_temperature(reslocal) = ir2_temperature_table(ir2_count(reslocal));
clear reslocal

ir3_count_radiance = -ones(size(ir3_count, 1), size(ir3_count, 2));
reslocal = find(ir3_count > 0);
ir3_count_radiance(reslocal) = ir3_radiance_table(ir3_count(reslocal));
ir3_count_temperature = -ones(size(ir3_count, 1), size(ir3_count, 2));
ir3_count_temperature(reslocal) = ir3_temperature_table(ir3_count(reslocal));
clear reslocal

ir4_count_radiance = -ones(size(ir4_count, 1), size(ir4_count, 2));
reslocal = find(ir4_count > 0);
ir4_count_radiance(reslocal) = ir4_radiance_table(ir4_count(reslocal));
ir4_count_temperature = -ones(size(ir4_count, 1), size(ir4_count, 2));
ir4_count_temperature(reslocal) = ir4_temperature_table(ir4_count(reslocal));
clear reslocal

vis_scan_time = 24.0*3600.0*(vis_scan_time - floor(vis_scan_time)); 
ir_scan_time = 24.0*3600.0*(ir_scan_time - floor(ir_scan_time)); 


