cmake_minimum_required(VERSION 3.16)

project(BubblyWash VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Find Qt6
find_package(Qt6 6.2 REQUIRED COMPONENTS
    Core
    Quick
    Qml
)

# Source files (CHANGED TARGET NAME TO appBubblyWash HERE)
qt_add_executable(BubblyWash
    main.cpp
    OrderManager.cpp
    OrderManager.h
)

# QML Module with Resources
qt_add_qml_module(BubblyWash
    URI BubblyWash
    VERSION 1.0
    QML_FILES
        main.qml
        Dashboard.qml
        AddOrder.qml
        OrderList.qml
        Receipt.qml
    RESOURCES
        fonts/AfacadFlux-Bold.ttf
        fonts/Poppins-Regular.ttf
        fonts/Poppins-Medium.ttf
        fonts/Poppins-SemiBold.ttf
        fonts/Poppins-Bold.ttf
        RESOURCES fonts/resources.qrc
        RESOURCES source.qrc
        RESOURCES source.qrc
)

# Link libraries
target_link_libraries(BubblyWash PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
)

# Platform settings
if(WIN32)
    set_target_properties(BubblyWash PROPERTIES WIN32_EXECUTABLE TRUE)
endif()

if(APPLE)
    set_target_properties(BubblyWash PROPERTIES MACOSX_BUNDLE TRUE)
endif()

# Install
install(TARGETS BubblyWash
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)