# Meal's Calories Tracker 🍎📊

A mobile application that helps you keep track of what you eat and how many calories you're consuming. Built with Flutter, this app makes it easy to log meals and see your eating patterns over time through simple charts and graphs.

## ✨ What You Can Do

*   **Log Your Meals:** Add your breakfast, lunch, dinner, and snacks quickly. You can categorize them and include details like portion size. 🍽️
*   **Track Calories:** See how many calories you're eating each day and compare it to your goals. 🔥
*   **View Analytics:** Check out charts that show your eating habits over time - helpful for seeing patterns! 📈
*   **Save Your Data:** All your meal information is stored right on your phone, so it's always there when you need it. 💾
*   **Search Food:** Look up different foods in a database to find their nutritional information and add them to your meals. 🌐
*   **User-Friendly Design:** The app has a clean, easy-to-use interface that works well on different devices. 📱

## 🛠️ Technologies Used

*   **Flutter:** The main framework I used to build the app. It works on both Android and iOS from the same code. 💙
*   **Riverpod:** This helps manage the app's data and state in a clean way. Makes everything run smoother. 🚀
*   **SQLite:** A local database that stores all your meal data on your phone. Uses the sqflite package to work with Flutter. 🗄️
*   **HTTP & Dio:** These packages help the app connect to external food APIs to get nutrition information. 📡
*   **UI Packages:**
    *   `google_fonts`: Makes the text look good throughout the app. ✍️
    *   `flutter_animate`: Adds smooth animations when switching between screens. ✨
    *   `fl_chart`: Used to create the nice-looking charts for analytics. 📊
*   **Helper Packages:**
    *   `intl`: For formatting dates and numbers properly. 🌍
    *   `shared_preferences`: For saving simple settings like daily calorie goals. ⚙️
    *   `uuid`: Helps generate unique IDs for each meal entry. 🆔
    *   `json_annotation` & `json_serializable`: Makes it easier to work with JSON data from APIs. 🔄

## 📸 App Screenshots

_Check out how the app looks! You can find screenshots in the `screenshots/` folder once I finish taking them._

## 🚀 Getting Started

1.  **Clone the repo:** `git clone [your-repo-url]`
2.  **Get dependencies:** Run `flutter pub get` in the project folder
3.  **Run the app:** `flutter run` to start it up

Make sure you have Flutter installed and set up on your machine!

## 🤝 Contributing

I'm still learning, so feel free to suggest improvements or report any issues you find. Pull requests are welcome!
