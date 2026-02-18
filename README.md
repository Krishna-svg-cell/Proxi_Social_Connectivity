# 🎭 Proxi: Dual-Persona Social Platform

**Proxi** is a next-generation social app that bridges the gap between digital networking and real-world interactions. It features a unique "Dual-Persona" system allowing users to toggle between professional and casual profiles instantly.

## 🚀 Key Features

* [cite_start]**Dual-Persona Mode:** Seamlessly toggle between "Professional" (Work) and "Casual" (Social) personas with dynamic UI adaptation[cite: 92].
* [cite_start]**Proximity Discovery:** Uses **Bluetooth and Wi-Fi scanning** to detect and connect with users in the immediate vicinity[cite: 94].
* [cite_start]**Real-Time Chat:** Engineered with **WebSockets** for instant messaging and multimedia file sharing[cite: 93].
* [cite_start]**Distinct Feeds:** Scalable backend managing separate content feeds (Stories/Posts) for formal and casual modes[cite: 95].

## 🛠️ Tech Stack

* **Mobile App:** Flutter
* **Backend:** Python (FastAPI)
* **Database:** MongoDB
* **Real-Time:** WebSockets, Bluetooth LE

## ⚙️ Installation

1.  **Backend Setup:**
    ```bash
    cd backend
    pip install -r requirements.txt
    python -m uvicorn main:app --reload --host 0.0.0.0
    ```

2.  **Mobile App Setup:**
    * Ensure your device is on the same Wi-Fi as the server.
    * Update the WebSocket URL in the app config.
    ```bash
    cd mobile_app
    flutter run
    ```

---
