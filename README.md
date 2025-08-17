# Mother Bet

Mother Bet is a cross-platform Flutter application designed to provide a seamless experience for users and administrators in managing food ordering, payments, and account details. 

## Features

- **User Authentication:** Secure registration and login using Firebase Auth.
- **Admin Dashboard:** Dedicated screens for admin users to manage and monitor activities.
- **Payment Integration:** Manage payments directly within the app.
- **Detail & Summary Views:** Users can view detailed information and summaries of their food order status 
- **Navigation:** Intuitive navigation with multi-page support.
- **Local Storage:** Uses Hive for fast, reliable on-device storage.
- **State Management:** Riverpod ensures robust and scalable state management across the app.
- **Cross-Platform:** Runs on mobile, web, Windows, and Linux.

## Getting Started

1. **Clone the repository**
    ```bash
    git clone https://github.com/BekaluEshete/mother-bet-.git
    cd mother-bet-
    ```

2. **Install dependencies**
    ```bash
    flutter pub get
    ```

3. **Run the app**
    - For mobile/web:
      ```bash
      flutter run
      ```
    - For desktop (Windows/Linux):
      ```bash
      flutter run -d windows
      # or
      flutter run -d linux
      ```

## Configuration

Make sure to set up Firebase and Hive as per your environment needs. The app uses Firebase for authentication and core services, and Hive for local storage.

## Contributing

Feel free to submit issues, feature requests, or pull requests!

## License

This project is licensed under the MIT License.

