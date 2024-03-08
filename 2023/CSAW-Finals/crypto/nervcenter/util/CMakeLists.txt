add_executable(pack_images pack_images.c ../src/resources.c)
target_include_directories(pack_images PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/.. ${ZLIB_INCLUDE_DIRS})
target_link_libraries(pack_images ${ZLIB_LIBRARIES})
