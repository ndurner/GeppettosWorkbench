QT       += core gui webenginewidgets

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

VERSION = 1.0.0

SOURCES += \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    mainwindow.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

OTHER_FILES += \
    ui_mod.js

RESOURCES += \
    res.qrc

# Add a custom bundling configuration option
CONFIG += bundle

# Check if the target platform is Windows and the bundling option is enabled
win32:CONFIG(bundle, bundle|!bundle) {
    CONFIG(debug, debug|release) {
        DESTDIR = debug
    } else {
        DESTDIR = release
    }

    # Set the output directory for the bundled application
    BUNDLE_DIR = $$OUT_PWD/bundle

    # Create the bundle directory if it doesn't exist
    !exists($$BUNDLE_DIR) {
        QMAKE_POST_LINK += $$QMAKE_MKDIR $$shell_path($$BUNDLE_DIR)$$escape_expand(\\n\\t)
    }

    # Copy the application executable to the bundle directory
    QMAKE_POST_LINK += $$QMAKE_COPY $$shell_path($${OUT_PWD}/$$DESTDIR/$${TARGET}.exe) $$shell_path($$BUNDLE_DIR)$$escape_expand(\\n\\t)

    # Run windeployqt to collect dependencies and bundle them with the application
    QMAKE_POST_LINK += $$[QT_INSTALL_PREFIX]\bin\windeployqt --no-compiler-runtime --dir $$shell_path($$BUNDLE_DIR) $$shell_path($$BUNDLE_DIR)\\$${TARGET}.exe$$escape_expand(\\n\\t)

    # Get the Windows SDK and Visual Studio directories
    WINDOWS_SDK_DIR = $$getenv(WindowsSdkDir)
    UCRT_VERSION = $$getenv(UCRTVersion)
    VS_INSTALL_PATH = $$getenv(VSINSTALLDIR)
    VC_REDIST_PATH = $$files($$getenv(VCToolsRedistDir)\\x64\\Microsoft.VC*.CRT, 1)
    UCRT_SOURCE_PATH = $$WINDOWS_SDK_DIR\\Redist\\$$getenv(WindowsSDKVersion)\\ucrt\\DLLs\\x64

    QMAKE_POST_LINK += set$$escape_expand(\\n\\t)

    # Copy deps
    QMAKE_POST_LINK += xcopy /Y /I /E $$shell_quote($$shell_path($$UCRT_SOURCE_PATH)) $$shell_quote($$shell_path($$BUNDLE_DIR))$$escape_expand(\\n\\t)
    QMAKE_POST_LINK += xcopy /Y /I /E $$shell_quote($$shell_path($$VC_REDIST_PATH)) $$shell_quote($$shell_path($$BUNDLE_DIR))$$escape_expand(\\n\\t)


    # Create a ZIP file using PowerShell
    ARCHIVE_FILE = $$OUT_PWD\\$${TARGET}-$${VERSION}.7z
    QMAKE_POST_LINK += 7z.exe a -mx=9 -m0=LZMA2 -ms=on -mmt=on "$$ARCHIVE_FILE" "$$BUNDLE_DIR\*"$$escape_expand(\\n\\t)
    QMAKE_CLEAN += "$$ARCHIVE_FILE"
}
