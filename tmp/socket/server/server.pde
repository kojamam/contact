import processing.net.*;

Server server;

void setup() {
  server = new Server(this, 9998);
}

void draw() {
  Client c = server.available();
  if (c != null) {
    int s = c.read();
    println("server received: " + s);
  }
}
