import processing.net.*;

Server server;

void setup() {
  server = new Server(this, 9998);
}

void draw() {
  Client c = server.available();
  if (c != null) {
    String s = c.readStringUntil('\n').trim();
    println("server received: " + s);
    //server.write("488");
  }
}