#include <WiFi.h>
#include <Firebase_ESP_Client.h>

#define WIFI_SSID ""          
#define WIFI_PASSWORD ""      
#define API_KEY ""       
#define DATABASE_URL ""       
  
FirebaseData fbdo;        
FirebaseAuth auth;        
FirebaseConfig config;    

bool signupOK = false;                      


const int trigPin = 12;
const int echoPin = 13;
const int UltrabuzzerPin = 14;
const int colorbuzzerPin =27;
const int s0 = 19;  
const int s1 = 18;
const int out = 15;  
const int s2 = 2;  
const int s3 = 4; 
long duration;
int distance;

int redValue, blueValue, greenValue, whiteValue;

void setup() {
  Serial.begin(115200);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(UltrabuzzerPin, OUTPUT);
  pinMode(colorbuzzerPin,OUTPUT);
  pinMode(s0, OUTPUT);  
  pinMode(s1, OUTPUT);  
  pinMode(s2, OUTPUT);  
  pinMode(s3, OUTPUT);  
  pinMode(out, INPUT);  
  digitalWrite(s0, HIGH);  
  digitalWrite(s1, HIGH);

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
  long duration;

  distance = calculateDistance();
  //Serial.println("Distance (cm): " + distance);
  Serial.print("Distance (cm): ");
  Serial.println(distance);

  if (distance < 15) {
    playTone(1000, 5);
  } else if (distance >= 15 && distance < 35) {
    playTone(500, 3);

  } else if (distance >= 35 && distance < 65) {
    playTone(10, 1);
  } else {
    noTone(UltrabuzzerPin);
  }

  delay(20);

  detectColor();
  //delay(500);
  Serial.println();
}

void playTone(int frequency, int repeats) {
  for (int i = 0; i < repeats; i++) {
    tone(UltrabuzzerPin, frequency);
    delay(200);  // Delay between each tone
    noTone(UltrabuzzerPin);
    delay(200); 
     // Delay between each repetition
  }
  for (int i = 0; i < repeats; i++) {
    tone(colorbuzzerPin, frequency);
    delay(200);  // Delay between each tone
    noTone(colorbuzzerPin);
    delay(200); 
     // Delay between each repetition
  }
}

int calculateDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;
  return distance;
}

void detectColor() {    
  // Read values
  digitalWrite(s2, LOW);  
  digitalWrite(s3, LOW);   
  delay(50); 
  redValue = pulseIn(out, LOW);

  digitalWrite(s2, LOW);
  digitalWrite(s3, HIGH); 
  delay(50);  
  blueValue = pulseIn(out, LOW);

  digitalWrite(s2, HIGH);
  digitalWrite(s3, HIGH);  
  delay(50);  
  greenValue = pulseIn(out, LOW);

  // Print values for calibration
  Serial.print("Red: ");
  Serial.print(redValue);
  Serial.print(", Green: ");
  Serial.print(greenValue);
  Serial.print(", Blue: ");
  Serial.println(blueValue);

  // Determine white based on high values across all colors
  String color = "Not Defined" ;
  if (redValue > 700 && blueValue > 700 && greenValue > 700) { 
    color = "White";
  } else if (redValue < blueValue && redValue < greenValue) {
    color = "Red";
  } else if (blueValue < redValue && blueValue < greenValue) {
    color = "Blue";
  } else if (greenValue < redValue && greenValue < blueValue) {
    color = "Green";
  } 
  Serial.print("Color: ");
  Serial.println(color);                             
  delay(100);                                       
  Firebase.RTDB.setString(&fbdo, "/Color", color); 
}