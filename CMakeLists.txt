cmake_minimum_required(VERSION 3.18)
project(noru_compositor LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick WaylandCompositor)  # Qt 6
qt_add_executable(noru-compositor main.cpp)

qt_add_qml_module(noru-compositor
    URI NCompositor
    VERSION 1.0
    QML_FILES main.qml
)

target_link_libraries(noru-compositor PRIVATE Qt6::Quick Qt6::WaylandCompositor)
