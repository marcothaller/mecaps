find_package(CURL QUIET)
if (NOT TARGET CURL::libcurl)
    get_property(tmp GLOBAL PROPERTY PACKAGES_NOT_FOUND)
    list(FILTER tmp EXCLUDE REGEX CURL)
    set_property(GLOBAL PROPERTY PACKAGES_NOT_FOUND ${tmp})

    FetchContent_Declare(
        curl
        GIT_REPOSITORY https://github.com/curl/curl.git
        GIT_TAG curl-8_5_0
    )
    set(BUILD_TESTING OFF CACHE BOOL "Turn off testing" FORCE)
    set(BUILD_CURL_EXE OFF CACHE BOOL "Turn off curl executable" FORCE)

    # Force libcurl to be built as shared library despite global BUILD_SHARED_LIBS setting
    # this is necessary to be able to link faked functions to test executable
    option(BUILD_SHARED_LIBS_CURL ON CACHE BOOL "Build shared libraries" FORCE)
    option(BUILD_STATIC_LIBS_CURL OFF CACHE BOOL "Build static libraries" FORCE)
    set_target_properties(libcurl PROPERTIES BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS_CURL})
    set_target_properties(libcurl PROPERTIES BUILD_STATIC_LIBS ${BUILD_STATIC_LIBS_CURL})

    if (WIN32)
        set(CURL_USE_SCHANNEL ON CACHE BOOL "Use schannel to build libcurl" FORCE)
    else()
        set(CURL_USE_OPENSSL ON CACHE BOOL "Use OpenSSL to build libcurl" FORCE)
    endif()
    FetchContent_MakeAvailable(curl)
endif()
