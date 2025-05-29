# 🐔 IoT Chicken House Project

### 📚 Academic IoT Project  
A smart monitoring and automation system for poultry farms using IoT and a Flutter mobile app.

---

## 📱 Flutter Mobile App

A cross-platform mobile application developed in **Flutter** to visualize sensor data and control devices remotely via Wi-Fi (or optionally cloud services like Firebase).

---

## 🛠️ Overview

This project is an IoT-based system designed to **monitor and control the environment inside a chicken house**. It leverages sensors and actuators to automate tasks and ensure a healthy environment for chickens.

---

## 📌 Features

- 🌡️ **Temperature Visualization**  
  Displays real-time temperature data via sensors.
  
- 💧 **Humidity Visualization**  
  Displays current humidity levels for optimal air conditions.

- ❄️ **Air Conditioning (AC) Control**  
  Automatically activates the AC unit if the temperature exceeds a defined threshold.

- 🚿 **Water Pump Control**  
  Automatically or manually activates the water pump to maintain humidity or hydration levels.

- 💡 **Light Control**  
  Manual ON/OFF toggle or automatic based on motion sensors or schedule.

---

## 🔧 Tech Stack

### 🧱 Hardware Components

- **Microcontroller**: ESP32 
- **Sensors**: DHT11 (Temperature & Humidity), optional motion sensor
- **Actuators**: Relays to control:
  - Air Conditioner (AC)
  - Water Pump
  - Lighting system
- **Connectivity**: Wi-Fi (ESP32)

### 💻 Software Components

- **Firmware**: Arduino (C++) / MicroPython
- **Mobile App**: Flutter (Dart)
- **Communication**: 
  - REST API (over Wi-Fi)
  - Firebase integration

