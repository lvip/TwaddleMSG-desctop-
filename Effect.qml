import QtQuick 2.0

ShaderEffect {
    property variant source
    property ListModel parameters: ListModel { }
    property bool divider: true
    property real dividerValue: 0.5
    property real targetWidth: 0
    property real targetHeight: 0
    property string fragmentShaderFilename
    property string vertexShaderFilename

    QtObject {
        id: d
        property string fragmentShaderCommon: "
            #ifdef GL_ES
                precision mediump float;
            #else
            #   define lowp
            #   define mediump
            #   define highp
            #endif // GL_ES
        "
    }

    // The following is a workaround for the fact that ShaderEffect
    // doesn't provide a way for shader programs to be read from a file,
    // rather than being inline in the QML file

    onFragmentShaderFilenameChanged:
        fragmentShader = d.fragmentShaderCommon + fileReader.readFile(fragmentShaderFilename)
    onVertexShaderFilenameChanged:
        vertexShader = fileReader.readFile(vertexShaderFilename)
}
