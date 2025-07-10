#include <TinyGPSPlus.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <SoftwareSerial.h>

#define DATABASE_URL ""
#define API_KEY ""
#define WIFI_SSID ""          
#define WIFI_PASSWORD "" 


//Define FirebaseESP32 data object
FirebaseJson json;

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

TinyGPSPlus gps;
SoftwareSerial gpsSerial(13,12);

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;

void setup() {
  Serial.begin(115200);
  gpsSerial.begin(9600);
  // Initialize WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println(" connected.");
  Serial.println(WiFi.localIP());
 
  // Firebase configuration
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  // This will show detailed debug information
  Firebase.begin(&config, &auth);

  // Sign up or sign in must be completed in your Firebase project
  if (Firebase.signUp(&config, &auth, "", "")) { // Sign up anonymously
    Serial.println("Firebase connected");
    signupOK = true;
  } else {
    Serial.printf("Sign up failed: %s\n", config.signer.signupError.message.c_str());
  }

  Firebase.reconnectWiFi(true);
}


void loop() {

  //updateSerial();
  while (gpsSerial.available() > 0)
    if (gps.encode(gpsSerial.read()))
      displayInfo();
  if (millis() > 5000 && gps.charsProcessed() < 10){
    Serial.println(F("No GPS detected: check wiring."));
    while (true);
  }

}


void displayInfo(){
  Serial.print(F("Location: "));
  if (gps.location.isValid()) {
    Serial.print("Lat: ");
    Serial.print(gps.location.lat(), 6);
    Serial.print(F(","));
    Serial.print("Lng: ");
    Serial.print(gps.location.lng(), 6);
    Serial.println();
    String address =  "https://maps.google.com/?q=" + String( gps.location.lat()) + "," + String (gps.location.lng());
    Serial.println(address);

  
    Serial.print(gps.location.lat());
    Serial.print(",");
    Serial.print(gps.location.lng());
    delay(100);

    Firebase.RTDB.setString(&fbdo, "/MyApp/Address/Link", address); 
    Firebase.RTDB.setDouble(&fbdo, "/MyApp/Address/latitude ", gps.location.lat());
    Firebase.RTDB.setDouble(&fbdo, "/MyApp/Address/longitude ", gps.location.lng());
  }
  else{
    Serial.println(F("Invalid"));
  }
}

