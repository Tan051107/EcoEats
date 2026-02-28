# EcoEats  
### AI-Powered Smart Food Management System  
Supporting SDG 12 (Responsible Consumption and Production) & SDG 3 (Good Health and Well-being)

---

## 1. Project Overview

EcoEats is a cloud-based smart food management application designed to reduce household food waste while promoting healthier eating habits. The system enables users to digitally manage groceries, receive expiry notifications, and generate recipe recommendations based on available ingredients and dietary goals.

Food waste remains a global sustainability challenge. At the same time, individuals struggle with managing groceries efficiently and making informed dietary decisions. EcoEats addresses both problems through intelligent inventory tracking and algorithm-based recommendations.

This project aligns with:

- **SDG 12** – Responsible Consumption and Production  
- **SDG 3** – Good Health and Well-being (through nutritional awareness and balanced meal planning; no medical or pharmaceutical functions are included)

---

## 2. Technical Implementation Overview

EcoEats is built using a scalable, serverless cloud architecture powered by Google technologies.

### 2.1 Core Technologies

- **Frontend:** Web-based application (React / modern JavaScript framework)
- **Backend:** Firebase (Serverless Architecture)
- **Database:** Cloud Firestore (NoSQL, real-time database)
- **Backend Logic:** Firebase Cloud Functions
- **Authentication:** Firebase Authentication
- **Hosting:** Firebase Hosting
- **Storage:** Cloud-based (no local dependency)

### 2.2 Google Tools Utilized

- Firebase Authentication  
- Cloud Firestore  
- Firebase Cloud Functions  
- Firebase Hosting  
- Firebase Cloud Messaging (for notifications)  

These tools ensure high availability, scalability, and real-time synchronization across devices.

---

## 3. System Architecture

EcoEats follows a modular and event-driven design:

1. User inputs grocery data (manual entry or barcode scan).
2. Data is stored in Cloud Firestore.
3. Cloud Functions trigger:
   - Expiry tracking logic
   - Notification scheduling
   - Recipe ranking algorithm
4. The frontend retrieves real-time updates from Firestore.
5. Users receive prioritized recipe recommendations.

Because the system avoids local storage dependency and relies entirely on cloud-based infrastructure, it supports:

- Real-time synchronization
- Cross-device access
- Secure data backup
- Horizontal scaling

---

## 4. Core Features

### 4.1 Smart Grocery Inventory
- Manual item entry
- Barcode scanning
- Auto-fill item database
- Expiry date tracking

### 4.2 Expiry Priority Color System
- Red: Expires within 2 days  
- Yellow: Expires within 5 days  
- Green: Fresh  

This visual system improves urgency recognition and decision efficiency.

### 4.3 Expiry-Based Recipe Recommendation Algorithm
The algorithm:
- Ranks ingredients by expiry proximity
- Prioritizes recipes using soon-to-expire items
- Aligns suggestions with user dietary goals

This ensures sustainability and nutritional awareness work simultaneously.

### 4.4 Personalized Dietary Goal Setting
Users may define:
- Calorie targets
- Balanced meal preferences
- Ingredient exclusions

Note: The system does not provide medical advice, medical reminders, or pharmaceutical notifications.

---

## 5. Innovation

EcoEats integrates sustainability and health awareness within a single intelligent framework.

Key innovations include:

- Expiry-driven recommendation logic (waste-first prioritization)
- Real-time cloud-based food lifecycle tracking
- Serverless architecture for cost-efficient scaling
- User-centered iteration based on structured testing

Unlike traditional recipe apps, EcoEats does not simply suggest meals—it dynamically adapts recommendations to reduce waste first.

---

## 6. User Testing and Iteration

### Testing Overview

- 12 real external users
  - 5 university students
  - 4 working adults
  - 3 family household users
- Duration: 7 days
- Tasks:
  - Input real groceries
  - Track expiry notifications
  - Use recipe suggestions

### Key Feedback & Improvements

1. Manual input was time-consuming  
   → Implemented barcode scanning & auto-fill  
   → Reduced input time by approximately 40%

2. Urgency was not visually clear  
   → Introduced color-coded expiry priority system  

3. Recipes did not strongly prioritize expiring items  
   → Updated algorithm to rank by expiry proximity  

This structured iteration significantly improved usability and user satisfaction.

---

## 7. Scalability

EcoEats is built on a serverless cloud architecture designed for growth.

### Why It Scales:

- Firebase automatically adjusts infrastructure
- Cloud Functions scale with event triggers
- Firestore supports horizontal data expansion
- No dependency on local storage

### Ready for Expansion:

- Multi-country deployment
- Multilingual support
- Retailer API integration
- AI-based image recognition
- Carbon footprint dashboard

The modular design allows new features to be added without restructuring the core system.

---

## 8. Challenges Faced

### 8.1 Balancing Sustainability and Usability
Early versions focused heavily on data accuracy but increased user friction. Iterative testing helped simplify workflows while maintaining system intelligence.

### 8.2 Algorithm Optimization
Prioritizing expiry proximity while maintaining dietary balance required ranking logic refinement and performance testing.

### 8.3 Real-Time Notification Efficiency
Ensuring timely expiry alerts without excessive triggering required careful event-based function design.

These challenges strengthened the architectural and logical robustness of the system.

---

## 9. Future Development

Planned enhancements include:

- AI image recognition for grocery identification
- Retailer integration via digital receipt syncing
- Community food-sharing network
- Smart auto-generated shopping lists
- Carbon footprint impact dashboard

These features will transform EcoEats from a food management tool into a broader sustainability intelligence platform.

---

## 10. Conclusion

EcoEats demonstrates how cloud-native technologies and intelligent algorithms can address real-world sustainability challenges. By combining expiry tracking, dietary personalization, and scalable infrastructure, the system provides a practical solution to reduce household food waste while encouraging healthier consumption patterns.

The project reflects strong alignment between technical implementation, user-centered design, and Sustainable Development Goals.

---

## License

This project is developed for academic and sustainability innovation purposes.
