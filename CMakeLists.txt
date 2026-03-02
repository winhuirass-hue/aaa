cmake_minimum_required(VERSION 3.18)
project(noru_compositor LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui                        # ← required by QtQuick.Window (QWindow base)
    Quick
    Qml
    WaylandCompositor
)

qt_policy(SET QTP0001 NEW)

qt_add_executable(noru-compositor
    src/main.cpp
)

qt_add_qml_module(noru-compositor
    URI NCompositor
    VERSION 1.0
    QML_FILES
        src/qml/main.qml
)

target_link_libraries(noru-compositor
    PRIVATE
        Qt6::Core
        Qt6::Gui                # ← add this
        Qt6::Quick
        Qt6::Qml
        Qt6::WaylandCompositor
)
