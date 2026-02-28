# EcoEats  
## Intelligent Food Inventory & Sustainability Management System  

**Aligned with SDG 12 (Responsible Consumption and Production) and SDG 3 (Good Health and Well-being)**

---

## 1. Project Overview

EcoEats is a cloud-based intelligent food management system designed to reduce household food waste while promoting balanced and mindful consumption habits. The application enables users to digitally manage groceries, track expiration dates, and receive recipe recommendations that prioritize ingredients nearing expiry.

Food waste is a major contributor to environmental degradation and inefficient resource consumption. Simultaneously, individuals often struggle with organizing groceries and planning meals efficiently. EcoEats addresses these issues by integrating real-time inventory tracking with algorithm-driven recommendation logic.

### SDG Alignment

- **SDG 12 – Responsible Consumption and Production**  
  Reduces avoidable household food waste through proactive expiry tracking.

- **SDG 3 – Good Health and Well-being**  
  Supports balanced meal planning and dietary awareness.  
  **Important:** EcoEats does not provide medical advice, pharmaceutical reminders, or any form of medical notification system.

---

## 2. Technical Implementation Overview

EcoEats is developed using a modern, scalable, serverless architecture powered primarily by Google Cloud technologies.

### 2.1 Technology Stack

#### Frontend
- Web-based user interface (modern JavaScript framework)
- Responsive design for cross-device usability

#### Backend (Google Technologies)
- **Firebase Authentication** – Secure user login and identity management  
- **Cloud Firestore** – Real-time NoSQL cloud database  
- **Firebase Cloud Functions** – Event-driven backend logic  
- **Firebase Hosting** – Secure and scalable web hosting  
- **Firebase Cloud Messaging** – Expiry notification system  

---

### 2.2 Architecture Design

EcoEats follows a serverless, event-driven architecture:

1. Users input grocery items (manual entry or barcode scanning).
2. Data is stored in Cloud Firestore.
3. Cloud Functions trigger automated processes:
   - Expiry date monitoring
   - Notification scheduling
   - Recipe recommendation ranking
4. The frontend retrieves updated data in real time.
5. Users receive prioritized suggestions and alerts.

Because the system operates fully in the cloud and avoids local device storage dependency, it supports:

- Real-time synchronization  
- Cross-device access  
- Secure centralized data management  
- Automatic scaling with increased traffic  

---

## 3. Implementation Details

### 3.1 Grocery Input System

Users can:

- Manually enter grocery items  
- Use barcode scanning for faster data entry  
- Automatically populate item names through database lookup  

This design reduces user friction and improves usability efficiency.

---

### 3.2 Expiry Priority Logic

To enhance clarity and urgency recognition, EcoEats implements a color-coded priority system:

- 🔴 **Red** – Expires within 2 days  
- 🟡 **Yellow** – Expires within 5 days  
- 🟢 **Green** – Fresh items  

This visual classification simplifies decision-making and encourages timely consumption.

---

### 3.3 Expiry-Based Recommendation Algorithm

The core innovation lies in the recommendation engine. Unlike conventional recipe platforms, EcoEats ranks recipes based on:

- Expiry proximity of ingredients  
- Ingredient availability  
- User-defined dietary preferences  

The algorithm prioritizes recipes that maximize the usage of soon-to-expire items while maintaining balanced meal composition. This approach integrates sustainability logic directly into the food selection process.

---

## 4. Innovation

EcoEats introduces several innovative elements:

### 4.1 Sustainability-First Recommendation Model
Rather than focusing solely on taste preference, the system prioritizes waste reduction through expiry-driven ranking logic.

### 4.2 Real-Time Cloud Lifecycle Tracking
Using Firestore and Cloud Functions, food lifecycle events are monitored dynamically without requiring manual updates.

### 4.3 Serverless Scalable Design
Firebase services eliminate infrastructure management overhead while ensuring reliability and elasticity.

### 4.4 User-Centered Iterative Refinement
The system was refined through structured user testing and measurable improvements based on feedback.

---

## 5. User Testing and Iteration

### 5.1 Testing Overview

- **12 external users** (outside the development team)  
  - 5 university students  
  - 4 working adults  
  - 3 household family users  
- Testing duration: **7 days**

Users were instructed to:

- Input real groceries  
- Monitor expiry notifications  
- Use recipe suggestions  

---

### 5.2 Key Feedback and Improvements

**Feedback 1:** Manual entry required too much time.  
→ Implemented barcode scanning and auto-fill database.  
→ Achieved approximately **40% reduction in input time**.

**Feedback 2:** Expiry urgency was not visually clear.  
→ Introduced color-coded priority system.  
→ Improved clarity and faster decision-making.

**Feedback 3:** Recipes should prioritize expiring ingredients.  
→ Refined ranking algorithm to emphasize expiry proximity.  
→ Increased user satisfaction and perceived usefulness.

This structured iteration demonstrates systematic improvement based on real user behavior.

---

## 6. Scalability and Future Expansion

### 6.1 Scalability

EcoEats is built on a serverless architecture:

- Firebase automatically scales infrastructure  
- Cloud Functions expand with user-triggered events  
- Firestore supports horizontal data scaling  

With minimal modification, the system can:

- Support multi-country deployment  
- Enable multilingual interfaces  
- Handle thousands of concurrent users  
- Integrate external APIs (e.g., retailers)  

---

### 6.2 Planned Future Features

- AI-based grocery image recognition  
- Integration with grocery retailers (digital receipt sync)  
- Community food-sharing network  
- Smart auto-generated shopping lists  
- Carbon footprint impact dashboard  

These enhancements aim to expand EcoEats into a comprehensive sustainability intelligence platform.

---

## 7. Challenges Faced

### 7.1 Usability vs. Data Accuracy
Balancing detailed tracking with user convenience required iterative interface simplification.

### 7.2 Algorithm Optimization
Designing a ranking system that balances expiry urgency and dietary preferences required logical refinement and performance testing.

### 7.3 Real-Time Event Management
Efficient notification scheduling without excessive triggers required careful Cloud Function configuration.

These challenges strengthened the system’s robustness and scalability.

---

## 8. Conclusion

EcoEats demonstrates how cloud-native technologies and intelligent algorithm design can address real-world sustainability challenges. By combining food lifecycle tracking, expiry-driven recommendations, and scalable Google Cloud infrastructure, the system provides a practical and measurable solution for reducing household food waste.

The project reflects strong integration between technical implementation, innovation, user-centered design, and global sustainability objectives.

---

**Academic Sustainability & Technology Innovation Project**
