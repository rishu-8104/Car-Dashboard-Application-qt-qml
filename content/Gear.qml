import QtQuick 2.0

Item {
    id: id_root

    property int value: 0

    Rectangle {
        id: id_gear

        anchors.centerIn: parent
        height: Math.min(id_root.width, id_root.height)
        width: height
        radius: width/2
        color: "black"
        border.color: "light green"
        border.width: id_gear.height * 0.02
        property string apiKey: "2a0f475a6b80a2bb6a8c0f62a057c874"
            property string apiUrl: "http://api.openweathermap.org/data/2.5/weather"
            property var weatherData: undefined
            property string city: "Tampere"
        function fetchWeather() {
               var queryString = apiUrl + "?q=" + city + "&appid=" + apiKey;

               var request = new XMLHttpRequest();
               request.open("GET", queryString);
               request.onreadystatechange = function() {
                   if (request.readyState === XMLHttpRequest.DONE) {
                       if (request.status === 200) {
                           weatherData = JSON.parse(request.responseText);
                           updateUI();
                       } else {
                           console.error("Error fetching weather data:", request.status, request.statusText);
                       }
                   }
               };
               request.send();
           }

           function updateUI() {
               // Update UI with weather data
               gearPositionText.text = "City: "+ city + "\n" + "Temp: "+  (weatherData.main.temp - 273.15).toFixed(1) + " °C," + "\n" + weatherData.weather[0].description;
               weatherIcon.source = getWeatherIcon(weatherData.weather[0].icon);
           }

           function getWeatherIcon(iconCode) {
               var iconPrefix = "http://openweathermap.org/img/w/";
               return iconPrefix + iconCode + ".png";
           }

           Component.onCompleted: fetchWeather()

        Repeater {
            model: 7

            Item {
                height: id_gear.height/2
                transformOrigin: Item.Bottom
                rotation: index * 30 + 200
                x: id_gear.width/2

                Rectangle {
                    height: id_gear.height * 0.12 + index * id_gear.height * 0.01
                    width: height
                    color: index == value ? "light green" : "grey"
                    radius: width/2
                    antialiasing: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: id_gear.height * 0.05

                    Text {
                        anchors.centerIn: parent
                        color: "black"
                        text: index
                        font.pixelSize: parent.height * 0.5
                        font.family: "Comic Sans MS"
                    }

                }
            }
        }
    }

    // Weather Data Display replacing "Gear Position" Text
            Text {
                id: gearPositionText
                anchors.centerIn: parent
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 200
                color: "light green"
                font.pixelSize: id_gear.height * 0.05
                font.family: "Comic Sans MS"
            }

            // Weather Icon
            Image {
                id: weatherIcon
                width: 100
                height: 100
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: gearPositionText.top
            }
}
