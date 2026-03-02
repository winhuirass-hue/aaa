cmake_minimum_required(VERSION 3.18)
project(noru_compositor LANGUAGES CXX)

# 1) Auto-tools for Qt’s MOC/RCC/UIC
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 2) Qt 6
find_package(Qt6 REQUIRED COMPONENTS Quick Qml WaylandCompositor)

# Optional: adopt the new QML resource prefix policy
qt_policy(SET QTP0001 NEW)

# 3) Launcher exe
qt_add_executable(noru-compositor
    src/main.cpp
)

# 4) Package QML as a module
qt_add_qml_module(noru-compositor
    URI NCompositor
    VERSION 1.0
    QML_FILES
        main.qml
    PATH src/qml
    # RESOURCE_PREFIX "/"   # (optional explicit prefix instead of qt_policy)
)

# 5) Link the required Qt targets
target_link_libraries(noru-compositor
    PRIVATE
        Qt6::Quick
        Qt6::Qml
        Qt6::WaylandCompositor
)
