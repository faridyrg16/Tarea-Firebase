# Project Blueprint

## Overview

This project is a Flutter application that serves as a hub for five different mini-applications, each demonstrating a different use case of Firebase with Flutter. The main screen will present a menu with five options, each navigating to one of the mini-apps.

## Style, Design, and Features

### Main Hub
*   **Minimalist Design:** A clean and simple layout with a numbered list of buttons.
*   **Navigation:** A central navigation screen to access the different applications.
*   **Routing:** Using `go_router` for declarative navigation.

### Mini-Applications

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

## Current Plan: Task Management App

1.  **Firebase Setup:**
    *   Add `firebase_core`, `firebase_auth`, and `cloud_firestore` dependencies.
    *   Configure Firebase in the Flutter project.
2.  **Authentication:**
    *   Create a login and registration screen.
    *   Implement user sign-up and sign-in with email and password using Firebase Authentication.
    *   Create a landing page that directs users to the login screen or the task list based on their authentication state.
3.  **Task Management (Firestore):**
    *   Create a `Task` model.
    *   Develop the UI for displaying the task list.
    *   Implement functionality to add, edit, delete, and mark tasks as complete.
    *   Use Firestore to store tasks, ensuring each user can only see their own tasks.
    *   Utilize real-time streams from Firestore to update the UI instantly.
4.  **UI/UX:**
    *   Create a clean and intuitive interface for managing tasks.
    *   Add a form (e.g., in a dialog) for creating and editing tasks.
    *   Implement filtering options to view all, pending, or completed tasks.
