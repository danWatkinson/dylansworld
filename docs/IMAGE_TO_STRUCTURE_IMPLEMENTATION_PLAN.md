# Image-to-Structure Generator - Implementation Plan

## Overview

Build a system that takes an image URL, analyzes it, and generates a Minecraft structure representation using a library of reusable architectural components.

## Architecture Overview

```
Image URL → Image Analyzer → Component Matcher → Structure Builder → Minecraft World
                ↓                    ↓                  ↓                    ↓
          Image Processor      Component Library   Block Placer      Player Controller
                ↓                    ↓                  ↓                    ↓
          Feature Extractor    Component Registry  World API         Snapshot Generator
                                                                           ↓
                                                                   Feedback Analyzer
                                                                           ↓
                                                                    Component Matcher
                                                                     (refinement loop)
```

### Feedback Loop

The system includes a live feedback loop that enables iterative refinement:

1. **Structure Generation**: Build structure in Minecraft world
2. **Player Control**: Teleport player to optimal viewing position, enable flight, orient camera
3. **Snapshot Capture**: Take in-game screenshot from controlled player perspective
4. **Comparison**: Compare snapshot to source image
5. **Analysis**: Identify differences and improvement opportunities
6. **Refinement**: Adjust component selection, placement, or generate new components
7. **Iterate**: Repeat until satisfactory match or iteration limit

This feedback loop allows the system to learn and improve structure generation in real-time.

## Core Components

1. **Image Processor** - Downloads, processes, and analyzes images
2. **Component Library** - Registry of reusable architectural components
3. **Component Matcher** - Matches image features to components
4. **Structure Builder** - Assembles components into structures
5. **World API Client** - Interacts with Minecraft server (PaperMC API) for block placement
6. **Player Controller** - Controls a player entity (teleport, fly, orientation) for snapshot capture
7. **Snapshot Generator** - Captures in-game screenshots from controlled player perspective
8. **Feedback Analyzer** - Compares generated structure snapshots to source images
9. **Iteration Controller** - Manages feedback loop and refinement cycles

## Implementation Phases

### Phase 0: Foundation & Testing Infrastructure

**Goal**: Set up testing framework and basic infrastructure

#### Tests to Write First (All Failing):

1. **Image Download Tests**
   ```
   - test_image_download_fails_on_invalid_url()
   - test_image_download_succeeds_on_valid_url()
   - test_image_download_handles_timeout()
   - test_image_download_validates_image_format()
   - test_image_download_provides_clear_error_messages()
   ```

2. **Image Processing Tests**
   ```
   - test_image_loading_fails_with_clear_error_on_invalid_file()
   - test_image_loading_succeeds_on_valid_image()
   - test_image_resizing_maintains_aspect_ratio()
   - test_image_to_array_conversion_produces_expected_dimensions()
   - test_image_color_extraction_handles_various_formats()
   ```

3. **Scale Input Validation Tests**
   ```
   - test_scale_validation_rejects_negative_values()
   - test_scale_validation_rejects_zero()
   - test_scale_validation_rejects_excessive_values()
   - test_scale_validation_accepts_valid_ranges()
   - test_scale_validation_provides_helpful_error_messages()
   ```

**Refactoring Opportunities**: 
- Extract error message constants
- Create validation utility classes
- Deduplicate URL/image format validation logic

---

### Phase 2: Component Library System

**Goal**: Create a registry system for reusable architectural components

#### Tests to Write First (All Failing):

1. **Component Definition Tests**
   ```
   - test_component_requires_name()
   - test_component_requires_block_pattern()
   - test_component_requires_dimensions()
   - test_component_validates_block_pattern_format()
   - test_component_stores_metadata_tags()
   - test_component_validation_provides_clear_errors()
   ```

2. **Component Registry Tests**
   ```
   - test_registry_registers_component_successfully()
   - test_registry_rejects_duplicate_names()
   - test_registry_finds_component_by_name()
   - test_registry_finds_components_by_tags()
   - test_registry_provides_search_functionality()
   - test_registry_validates_component_before_registration()
   - test_registry_errors_are_descriptive()
   ```

3. **Component Loading Tests**
   ```
   - test_component_loading_from_json_succeeds()
   - test_component_loading_validates_json_schema()
   - test_component_loading_handles_missing_files()
   - test_component_loading_handles_invalid_json()
   - test_component_loading_provides_clear_error_messages()
   ```

**Initial Component Library Structure**:
```
components/
  walls/
    brick_wall.json
    stone_wall.json
    wood_wall.json
  columns/
    stone_column.json
    pillar.json
  roofs/
    flat_roof.json
    sloped_roof.json
  doors/
    wooden_door.json
    stone_door.json
  windows/
    glass_window.json
    arched_window.json
```

**Refactoring Opportunities**:
- Extract component validation logic
- Create component builder pattern
- Deduplicate tag/search functionality
- Create component schema validator

---

### Phase 3: Component Matching System

**Goal**: Match image features to available components

#### Tests to Write First (All Failing):

1. **Matching Algorithm Tests**
   ```
   - test_matcher_finds_best_component_for_feature()
   - test_matcher_provides_match_confidence_score()
   - test_matcher_handles_no_suitable_matches()
   - test_matcher_considers_multiple_features()
   - test_matcher_validates_inputs_before_matching()
   - test_matcher_errors_are_descriptive()
   ```

2. **Similarity Calculation Tests**
   ```
   - test_color_similarity_calculation_is_correct()
   - test_shape_similarity_calculation_is_correct()
   - test_size_similarity_calculation_considers_scale()
   - test_combined_similarity_score_is_weighted_correctly()
   ```

3. **Component Selection Tests**
   ```
   - test_selection_returns_top_n_matches()
   - test_selection_filters_by_minimum_confidence()
   - test_selection_handles_ties_appropriately()
   ```

**Refactoring Opportunities**:
- Extract similarity calculation strategies
- Create matching strategy pattern
- Deduplicate scoring logic
- Create match result DTOs

---

### Phase 4: Structure Assembly & Placement

**Goal**: Assemble matched components into coherent structures

#### Tests to Write First (All Failing):

1. **Layout Planning Tests**
   ```
   - test_layout_planner_creates_building_outline()
   - test_layout_planner_places_components_at_correct_positions()
   - test_layout_planner_handles_overlapping_components()
   - test_layout_planner_validates_component_fits_in_space()
   - test_layout_planner_provides_clear_errors_on_invalid_layout()
   ```

2. **Structure Assembly Tests**
   ```
   - test_assembler_combines_components_into_structure()
   - test_assembler_handles_missing_components_gracefully()
   - test_assembler_validates_structure_integrity()
   - test_assembler_provides_detailed_assembly_errors()
   ```

3. **Positioning Tests**
   ```
   - test_position_calculation_considers_scale()
   - test_position_calculation_aligns_components_correctly()
   - test_position_validation_prevents_out_of_bounds()
   ```

**Refactoring Opportunities**:
- Extract layout algorithms
- Create placement strategy pattern
- Deduplicate coordinate calculation logic
- Create structure blueprint DTO

---

### Phase 1: Minecraft World Integration & Player Control

**Goal**: Establish basic Minecraft integration for block placement and player control

**Rationale**: We need to be able to place blocks and control a player before we can capture snapshots. This establishes the foundation for the feedback loop infrastructure.

#### Tests to Write First (All Failing):

1. **World API Client Tests**
   ```
   - test_api_client_connects_to_server()
   - test_api_client_handles_connection_failures()
   - test_api_client_places_block_at_coordinates()
   - test_api_client_places_multiple_blocks_efficiently()
   - test_api_client_validates_coordinates_before_placing()
   - test_api_client_provides_clear_connection_errors()
   ```

2. **Block Placement Tests**
   ```
   - test_block_placer_places_single_block()
   - test_block_placer_places_block_pattern()
   - test_block_placer_handles_invalid_block_types()
   - test_block_placer_batches_operations_for_performance()
   - test_block_placer_validates_world_bounds()
   - test_block_placer_errors_include_coordinate_info()
   ```

3. **Player Control Tests**
   ```
   - test_player_controller_gets_or_creates_control_player()
   - test_player_controller_teleports_player_to_location()
   - test_player_controller_enables_fly_mode()
   - test_player_controller_sets_player_orientation()
   - test_player_controller_validates_coordinates_before_teleport()
   - test_player_controller_provides_clear_errors_on_failure()
   - test_player_controller_calculates_optimal_view_position()
   - test_player_controller_sets_camera_angle_for_structure_view()
   ```

4. **Snapshot Capture Tests**
   ```
   - test_snapshot_captures_screen_from_player_perspective()
   - test_snapshot_saves_to_specified_location()
   - test_snapshot_handles_camera_positioning()
   - test_snapshot_validates_player_exists_before_capture()
   - test_snapshot_provides_clear_errors_on_failure()
   - test_snapshot_captures_at_correct_resolution()
   ```

**Refactoring Opportunities**:
- Extract API client abstraction
- Create block placement strategy
- Deduplicate coordinate validation
- Create operation batching logic
- Extract player control utilities
- Create snapshot capture service

---

### Phase 5: Image Analysis & Feature Extraction

**Goal**: Extract meaningful features from images that can guide structure generation

**Note**: Moved after Minecraft integration because we need the infrastructure in place, but we need image analysis before the feedback loop comparison can work meaningfully.

#### Tests to Write First (All Failing):

1. **Color Analysis Tests**
   ```
   - test_dominant_color_extraction_returns_most_common_color()
   - test_color_palette_extraction_returns_top_n_colors()
   - test_color_to_block_mapping_handles_edge_cases()
   - test_color_similarity_calculation_is_accurate()
   - test_color_analysis_provides_clear_error_on_empty_image()
   ```

2. **Shape/Structure Detection Tests**
   ```
   - test_rectangular_region_detection_identifies_buildings()
   - test_edge_detection_finds_structure_boundaries()
   - test_symmetry_detection_identifies_symmetric_elements()
   - test_vertical_line_detection_finds_columns_walls()
   - test_horizontal_line_detection_finds_floors_roofs()
   ```

3. **Feature Extraction Tests**
   ```
   - test_feature_extraction_returns_structured_data()
   - test_feature_extraction_handles_various_image_sizes()
   - test_feature_extraction_provides_confidence_scores()
   - test_feature_extraction_validates_input_before_processing()
   ```

**Refactoring Opportunities**:
- Extract color analysis into separate service
- Create feature extraction pipeline
- Deduplicate image preprocessing steps
- Create feature data transfer objects (DTOs)

---

### Phase 6: Feedback Loop & Image Comparison

**Goal**: Compare generated structure snapshots with source images and analyze differences

**Rationale**: Now that we can capture snapshots and analyze source images, we can implement the comparison and feedback mechanism.

#### Tests to Write First (All Failing):

1. **Image Comparison Tests**
   ```
   - test_comparison_calculates_similarity_score()
   - test_comparison_identifies_major_differences()
   - test_comparison_handles_different_image_sizes()
   - test_comparison_provides_detailed_difference_report()
   - test_comparison_validates_both_images_exist()
   - test_comparison_provides_clear_errors_on_failure()
   ```

2. **Feedback Analysis Tests**
   ```
   - test_feedback_analyzer_compares_snapshot_to_source()
   - test_feedback_analyzer_identifies_improvement_areas()
   - test_feedback_analyzer_generates_adjustment_suggestions()
   - test_feedback_analyzer_provides_clear_feedback_summary()
   - test_feedback_analyzer_calculates_similarity_percentage()
   - test_feedback_analyzer_identifies_color_mismatches()
   - test_feedback_analyzer_identifies_shape_mismatches()
   ```

3. **Iteration Control Tests**
   ```
   - test_iteration_controller_limits_max_iterations()
   - test_iteration_controller_stops_on_satisfactory_match()
   - test_iteration_controller_tracks_iteration_history()
   - test_iteration_controller_provides_iteration_summary()
   - test_iteration_controller_handles_iteration_failures_gracefully()
   ```

**Refactoring Opportunities**:
- Extract image comparison service
- Create feedback processing pipeline
- Deduplicate comparison logic
- Extract iteration strategy
- Create feedback DTOs

---

## Component Library Schema

```json
{
  "name": "brick_wall",
  "tags": ["wall", "brick", "exterior"],
  "dimensions": {
    "width": 1,
    "height": 3,
    "depth": 1
  },
  "block_pattern": [
    ["minecraft:bricks"]
  ],
  "features": {
    "color": "#8B4513",
    "shape": "rectangular",
    "symmetry": "vertical"
  },
  "variants": [
    {
      "name": "brick_wall_weathered",
      "block_pattern": [["minecraft:cracked_bricks"]]
    }
  ]
}
```

## Error Message Standards

All error messages should:
1. Be clear and actionable
2. Include context (what operation failed, why)
3. Suggest possible solutions
4. Include relevant data (coordinates, URLs, etc.) when helpful
5. Use consistent formatting

Example:
```
Error: Failed to download image from URL
  URL: https://example.com/image.jpg
  Reason: Connection timeout after 30 seconds
  Suggestion: Check URL validity and network connection
```

## Testing Strategy

1. **Unit Tests**: Each component in isolation
2. **Integration Tests**: Component interactions
3. **End-to-End Tests**: Full pipeline from image URL to structure
4. **Mock Tests**: Use mocks for external dependencies (Minecraft server, image downloads)

## Refactoring Checklist

After each test phase passes:
- [ ] Identify duplicated code
- [ ] Extract common patterns
- [ ] Simplify complex methods
- [ ] Improve naming clarity
- [ ] Add/improve documentation
- [ ] Review error messages
- [ ] Check for unused code
- [ ] Verify test coverage

## Technology Stack Suggestions

- **Language**: Java (for PaperMC plugin) or Kotlin
- **Build Tool**: Gradle (standard for Minecraft plugins)
- **Testing**: JUnit 5, Mockito
- **Image Processing**: Java ImageIO, or consider JavaCV for advanced features
- **JSON Processing**: Gson or Jackson
- **HTTP Client**: Java 11+ HttpClient or OkHttp

## Implementation Order Summary

**Revised Order (Feedback Loop First Approach)**:

1. **Phase 0**: Foundation (image download, validation, error handling, testing infrastructure)
2. **Phase 1**: Minecraft integration & player control (block placement, player teleport/fly, snapshot capture)
3. **Phase 2**: Component library (registry, loading, validation)
4. **Phase 3**: Component matching (algorithm, similarity scoring)
5. **Phase 4**: Structure assembly (layout, positioning)
6. **Phase 5**: Image analysis (color, shape detection) - *moved after structure building*
7. **Phase 6**: Feedback loop (image comparison, feedback analysis, iteration control)
8. **Phase 7**: Iteration & refinement (automated improvement cycles)

**Rationale for New Order**:
- Get Minecraft integration working early so we can test with real structures
- Establish player control and snapshot infrastructure early to enable feedback loop testing
- Move image analysis after structure assembly since we need source images to compare against
- Feedback loop comes after we can generate structures and analyze source images
- This allows manual testing of the feedback loop earlier in development

Each phase follows: Write failing tests → Implement functionality → Refactor → Next phase

