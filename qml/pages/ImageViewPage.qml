import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    property var _url

    Image {
        id: imageView
        width: parent.width
        height: width * (sourceSize.height / sourceSize.width)
        fillMode: Image.PreserveAspectFit
        source: _url

        PinchArea {
            anchors.fill: parent
            pinch.target: parent
            pinch.minimumScale: 1
            pinch.maximumScale: 4

            MouseArea {
                anchors.fill: parent
                drag.target: imageView
                drag.axis: Drag.XAndYAxis
                drag.minimumX: (parent.width - imageView.width * imageView.scale) / 2
                drag.minimumY: (parent.height - imageView.height * imageView.scale) / 2
                drag.maximumX: Math.abs(parent.width - imageView.width * imageView.scale) / 2
                drag.maximumY: Math.abs(parent.height - imageView.height * imageView.scale) / 2
                onClicked: drawer.open = !drawer.open
                onPositionChanged: { // TODO
                    console.log(drag.minimumX + " <= " + imageView.x + " <= " + drag.maximumX)
                    console.log(drag.minimumY + " <= " + imageView.y + " <= " + drag.maximumY)
                }
            }
        }
    }
}
