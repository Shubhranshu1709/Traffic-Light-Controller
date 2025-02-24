# Traffic-Light-Controller
This project implements a traffic light control system for a highway and a country road using Verilog. The system ensures smooth traffic flow, giving priority to the highway while allowing vehicles from the country road to pass when detected.

Functionality
The highway light remains GREEN when no vehicle is on the country road.
When a car is detected (CAR_ON_CNTRY_RD = 1):
The highway signal transitions GREEN → YELLOW → RED (allowing cars to stop).
The country road signal transitions RED → GREEN, allowing vehicles to pass.
After some time, the country road transitions GREEN → YELLOW → RED.
The highway turns GREEN again, resuming normal traffic.
The system resets when CLEAR = 1, initializing to the default state.
