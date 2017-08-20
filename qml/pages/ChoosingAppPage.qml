import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: applicationsDialog

    property string name
    property string exec

    SilicaListView {
        anchors.fill: parent

        model: applications

        header: PageHeader {
            title: qsTr("Installed applications")
        }

        delegate: ListItem {
            width: parent.width
            height: Theme.itemSizeSmall

            Label {
                anchors.centerIn: parent
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: appName
            }

            onClicked: {
                name = appName
                exec = appExec
                accept()
            }
        }

        VerticalScrollDecorator {}
    }
}
