# EcoEats  
## Intelligent Food Inventory & Sustainability Management System  
<br>

### Project Alignment
| Sustainable Development Goals |
|--------------------------------|
| **SDG 12 – Responsible Consumption and Production** |
| **SDG 3 – Good Health and Well-being** |

> EcoEats supports sustainable consumption and balanced dietary awareness.  
> **Important:** The system does not provide medical advice, pharmaceutical reminders, or any form of medical notification system.

---

<br>

# 1. Project Overview
EcoEats is a cloud-based intelligent food management system designed to reduce household food waste while promoting mindful consumption habits.

The platform enables users to:

- Digitally manage grocery inventory  
- Track expiration dates in real time  
- Receive prioritized recipe recommendations  
- Improve food utilization efficiency  

By integrating inventory lifecycle tracking with an expiry-driven ranking algorithm, EcoEats transforms everyday grocery management into a sustainability-oriented decision process.

---

<br>

# 2. Technical Implementation Overview

## 2.1 Technology Stack

### Frontend
- Web-based interface (modern JavaScript framework)
- Responsive cross-device design

### Backend (Google Cloud & AI Ecosystem)

| Service | Purpose |
|----------|----------|
| Firebase Authentication | Secure user identity management |
| Cloud Firestore | Real-time NoSQL database |
| Firebase Cloud Functions | Event-driven backend logic |
| Firebase Hosting | Scalable web deployment |
| Firebase Cloud Messaging | Expiry notification delivery |
| Google ML Kit (Barcode Scanning) | Real-time grocery barcode recognition |
| Vertex AI | Scalable AI model integration |
| Gemini API | Intelligent recipe ranking & recommendation reasoning |

The system leverages a fully serverless architecture, eliminating manual infrastructure management while ensuring automatic scalability.

<br>

## 2.2 System Architecture
### Workflow Logic

1. Users input groceries (manual or barcode scan).
2. Data is stored in Firestore.
3. Cloud Functions automatically trigger:
   - Expiry monitoring
   - Notification scheduling
   - Recipe ranking updates
4. Frontend synchronizes in real time.
5. Users receive prioritized suggestions.

### Architecture Advantages

- Real-time synchronization  
- Cross-device accessibility  
- Centralized secure data management  
- Automatic traffic scaling  

---

<br>

# 3. Implementation Details
## 3.1 Grocery Input System
**Input Methods:**

- Manual entry  
- Barcode scanning  
- Auto-filled item database  

Result: Reduced input friction and improved efficiency.

<br>

## 3.2 Expiry Priority Visualization
To enhance clarity, EcoEats applies a structured priority logic:

| Status | Expiry Window | Purpose |
|--------|---------------|----------|
| High Priority | ≤ 2 days | Immediate consumption |
| Medium Priority | ≤ 5 days | Planned usage |
| Fresh | > 5 days | Standard inventory |

This visual classification simplifies urgency recognition and improves decision-making speed.

<br>

## 3.3 Expiry-Based Recommendation Engine
Unlike conventional recipe platforms, EcoEats applies a multi-factor ranking model:

### Ranking Criteria

1. Expiry proximity  
2. Ingredient availability  
3. User dietary preferences  

The algorithm ensures that soon-to-expire ingredients are prioritized without compromising the balanced composition of meals.

This creates a sustainability-first recommendation model.

<br>

## 3.4 AI & Machine Learning Integration
EcoEats incorporates Google AI technologies to enhance automation, intelligence, and scalability.

### Google ML Kit – Barcode Scanning

The grocery input system integrates Google ML Kit for real-time barcode scanning.  
This allows:

- Automatic product identification
- Faster grocery entry
- Reduced manual typing
- Improved user efficiency

Barcode recognition significantly reduced input time during testing.

<br>

### Vertex AI – Scalable AI Infrastructure

Vertex AI provides the foundation for scalable AI model deployment.  
It enables:

- Intelligent data processing
- Model hosting and scalability
- Future expansion into predictive food waste analytics

The architecture allows AI capabilities to scale with increasing user data.

<br>

### Gemini API – Intelligent Recommendation Enhancement

Gemini is integrated to enhance contextual reasoning in recipe recommendations.

The system uses Gemini to:

- Interpret ingredient combinations
- Improve natural language understanding
- Enhance recommendation diversity
- Support sustainability-first ranking logic

Gemini strengthens the algorithm’s ability to generate relevant, expiry-aware, and balanced suggestions.

<br>

These AI integrations transform EcoEats from a simple tracking tool into an intelligent food sustainability platform.

---

<br>

# 4. Innovation Highlights
## Sustainability-Driven Logic
Recommendations are structured to reduce waste before satisfying preference-based ranking.

## AI-Augmented Sustainability Engine

By combining Gemini reasoning capabilities, Vertex AI scalability, and ML Kit automation, EcoEats integrates artificial intelligence directly into sustainability decision-making.

This creates:

- Automated grocery recognition
- Intelligent recipe ranking
- Scalable AI-powered optimization

## Real-Time Lifecycle Monitoring
Food inventory dynamically updates via Firestore and Cloud Functions without manual recalculation.

## Serverless Cloud Design
Firebase infrastructure enables elasticity and reliability with minimal operational overhead.

## User-Centered Iteration
Structured testing resulted in measurable performance improvements.

---

<br>

# 5. User Testing & Iteration
## 5.1 Testing Overview
| Participant Type | Count |
|------------------|-------|
| University Students | 5 |
| Working Adults | 4 |
| Family Household Users | 3 |
| **Total Users** | **12** |

Testing Duration: **7 days**

### User Tasks
- Input real groceries  
- Track expiry notifications  
- Use recipe recommendations

<br>

## 5.2 Feedback → Improvement Mapping
| Feedback | Improvement | Result |
|-----------|-------------|--------|
| Manual entry too slow | Barcode scanning + auto-fill | 40% faster input |
| Expiry urgency unclear | Priority visualization system | Faster recognition |
| Recipes not prioritizing expiry | Algorithm refinement | Higher satisfaction |

This iterative refinement demonstrates structured, data-driven improvement.

---

<br>

# 6. Scalability & Future Expansion
## 6.1 Scalability
Built on Firebase serverless infrastructure:

- Automatic scaling  
- Horizontal database growth  
- Event-driven logic expansion  

Ready for:

- Multi-country deployment  
- Multilingual support  
- Thousands of concurrent users  
- Third-party API integrations  


## 6.2 Planned Future Enhancements
- AI-based grocery image recognition  
- Retailer digital receipt integration  
- Community food-sharing network  
- Smart auto-generated shopping lists  
- Carbon footprint impact dashboard  

These features aim to extend EcoEats into a comprehensive sustainability intelligence platform.

---

<br>

# 7. Challenges Faced
## Usability vs Data Precision
Balancing detailed tracking with a simplified interface required iterative UI refinement.

## Algorithm Optimization
Balancing expiry urgency and dietary alignment required logical tuning and performance testing.

## Real-Time Event Efficiency
Preventing excessive notification triggers required careful Cloud Function configuration.

These challenges strengthened architectural robustness.

---

<br>

# 8. Conclusion
EcoEats demonstrates how cloud-native Google technologies and intelligent algorithm design can deliver a practical solution to household food waste.

By integrating:

- Real-time inventory lifecycle tracking  
- Expiry-driven recommendation logic  
- Scalable serverless infrastructure  

The project effectively aligns technological implementation with measurable sustainability impact.

---

<br>

### Teammembers:
TAN YI YANG <br>
TAN YI WEN <br>
FOO TUN FENG <br>
