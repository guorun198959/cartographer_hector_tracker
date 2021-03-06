-- Copyright 2016 The Cartographer Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "world",
  tracking_frame = "base_link",
  published_frame = "odom",
  odom_frame = "odom",
  provide_odom_frame = false,
  use_odometry = true,
  use_laser_scan = false,
  use_multi_echo_laser_scan = false,
  num_point_clouds = 1,
  lookup_transform_timeout_sec = 0.2,
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
}

TRAJECTORY_BUILDER_3D.scans_per_accumulation = 50
TRAJECTORY_BUILDER_3D.min_range = 1.5
TRAJECTORY_BUILDER_3D.max_range = 50
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.max_num_iterations = 50
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.rotation_weight = 5


TRAJECTORY_BUILDER_3D.submaps.high_resolution = 0.10
TRAJECTORY_BUILDER_3D.tsdfs.high_resolution = 0.10
TRAJECTORY_BUILDER_3D.tsdfs.projection_integrator.carving_enabled = true
TRAJECTORY_BUILDER_3D.submaps.low_resolution = 0.4
TRAJECTORY_BUILDER_3D.submaps.num_range_data = 200000000
TRAJECTORY_BUILDER_3D.tsdfs.num_range_data = 200000000
TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.hit_probability = 0.58
TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.miss_probability = 0.48

TRAJECTORY_BUILDER_3D.motion_filter.max_distance_meters = 0
TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter.min_num_points = 800.
-- TRAJECTORY_BUILDER_3D.kalman_local_trajectory_builder.odometer_rotational_variance = 1e-9
TRAJECTORY_BUILDER_3D.kalman_local_trajectory_builder.use_online_correlative_scan_matching = false
TRAJECTORY_BUILDER_3D.kalman_local_trajectory_builder.real_time_correlative_scan_matcher.linear_search_window = 0.
TRAJECTORY_BUILDER_3D.kalman_local_trajectory_builder.real_time_correlative_scan_matcher.angular_search_window = math.rad(15.)

MAP_BUILDER.use_trajectory_builder_3d = true
MAP_BUILDER.num_background_threads = 3
MAP_BUILDER.sparse_pose_graph.optimization_problem.huber_scale = 5e2
MAP_BUILDER.sparse_pose_graph.optimize_every_n_scans = 20000000
MAP_BUILDER.sparse_pose_graph.constraint_builder.sampling_ratio = 0.03
MAP_BUILDER.sparse_pose_graph.optimization_problem.ceres_solver_options.max_num_iterations = 10
MAP_BUILDER.sparse_pose_graph.optimization_problem.rotation_weight = 3e3

-- Reuse the coarser 3D voxel filter to speed up the computation of loop closure
-- constraints.
MAP_BUILDER.sparse_pose_graph.constraint_builder.adaptive_voxel_filter = TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter
MAP_BUILDER.sparse_pose_graph.constraint_builder.min_score = 0.65
MAP_BUILDER.sparse_pose_graph.constraint_builder.log_matches = true
MAP_BUILDER.use_tsdf = true

TRAJECTORY_BUILDER_3D.optimizing_local_trajectory_builder.scans_per_map_update = 50
TRAJECTORY_BUILDER_3D.optimizing_local_trajectory_builder.scans_per_optimization_update = 10


TRAJECTORY_BUILDER_3D.use = "KALMAN"
TRAJECTORY_BUILDER_3D.optimizing_local_trajectory_builder.high_resolution_grid_weight = 50.
TRAJECTORY_BUILDER_3D.optimizing_local_trajectory_builder.low_resolution_grid_weight = 15.
TRAJECTORY_BUILDER_3D.optimizing_local_trajectory_builder.velocity_weight = 4e0
TRAJECTORY_BUILDER_3D.optimizing_local_trajectory_builder.translation_weight = 1e2
TRAJECTORY_BUILDER_3D.optimizing_local_trajectory_builder.rotation_weight = 1e3
TRAJECTORY_BUILDER_3D.optimizing_local_trajectory_builder.odometry_translation_weight = 1e4

return options
