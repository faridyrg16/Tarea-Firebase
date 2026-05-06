# Project Blueprint

## Overview

This project is a Flutter application that serves as a hub for five different mini-applications, each demonstrating a different use case of Firebase with Flutter. The main screen will present a menu with five options, each navigating to one of the mini-apps.

## Style, Design, and Features

### Main Hub
*   **Minimalist Design:** A clean and simple layout with a numbered list of buttons.
*   **Navigation:** A central navigation screen to access the different applications.
*   **Routing:** Using `go_router` for declarative navigation.

### Mini-Applications (Placeholders)
1.  **Task Management App:**
    *   **Concept:** A to-do list with user authentication.
    *   **Features:** Create, read, update, delete tasks.
    *   **Firebase Services:** Authentication, Firestore.
2.  **Student Registration System:**
    *   **Concept:** A system for managing student records.
    *   **Features:** CRUD operations for students.
    *   **Firebase Services:** Firestore.
3.  **Real-time Chat:**
    *   **Concept:** A basic real-time chat application.
    *   **Features:** Send and receive messages instantly.
    *   **Firebase Services:** Authentication (Google Sign-In), Firestore.
4.  **Notes System with Images:**
    *   **Concept:** A personal note-taking app that supports images.
    *   **Features:** Create notes with text and images.
    *   **Firebase Services:** Authentication, Firestore, Storage.
5.  **Product Admin Panel:**
    *   **Concept:** A dashboard for managing products.
    *   **Features:** CRUD operations for products, role-based access.
    *   **Firebase Services:** Authentication, Firestore, Storage.

## Current Plan

1.  **Set up the project:** Create a new Flutter project and add the necessary dependencies (`go_router`).
2.  **Create the main screen:** Design a simple main screen with five buttons.
3.  **Set up routing:** Configure `go_router` to navigate to the different app screens.
4.  **Create placeholder screens:** Create a basic `StatelessWidget` for each of the five applications.
5.  **Implement the UI for the main screen:** Build the layout with the five navigation buttons.
