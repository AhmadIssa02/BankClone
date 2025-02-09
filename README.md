
# 🏦 Bank Clone Project

This project is a **Bank Clone** application consisting of a **Flutter frontend** and a **.NET backend**. The system allows users to perform basic banking operations, view transaction history, and manage their accounts securely. 💳🔒

## 🚀 Project Structure

- **Frontend**: Flutter (Web) 🌐
- **Backend**: .NET Core API 💻

## 🔑 Features

- User Authentication (JWT) 🔐
- View Transaction History 📜
- Transfer Money to Other Users 💵
- Secure Encryption for Sensitive Data 🔒
- Responsive Design for Both Desktop and Mobile Web Browsers 📱💻
- Security fundementals and protection against SQLI, CSRF, XSS, SSRF and implementing CSP and CORS.🔒

## 🛠️ How to Run the Project

### 1. Run the Backend (🖥️ .NET Core API)

The backend is built using **.NET Core** and serves as an API for the frontend. Follow the steps below to run the backend locally.

1. **Clone the repository** (if not already cloned):

   ```bash
   git clone <repo-url>
   cd <backend-folder>
   ```

2. **Install dependencies**:

   Ensure that you have the .NET SDK installed. If not, you can download it from [here](https://dotnet.microsoft.com/download).

3. **Run the backend**:

   Use the following command to start the backend in development mode:

   ```bash
   dotnet watch run
   ```

   This will start the backend server on `https://localhost:5001`.

### 2. Run the Frontend (📱 Flutter Web)

The frontend is built using **Flutter** and runs as a web application.

1. **Clone the repository** (if not already cloned):

   ```bash
   git clone <repo-url>
   cd <frontend-folder>
   ```

2. **Install dependencies**:

   Make sure you have Flutter installed. If not, follow the installation instructions from [here](https://flutter.dev/docs/get-started/install).

3. **Run the Flutter app**:

   Use the following command to run the Flutter web app:

   ```bash
   flutter run --web-port=8080
   ```

   The frontend should now be available at `http://localhost:8080`. 🎉

---

## 🌍 Environment Variables

### 1. Frontend (🔐)

In the frontend directory, you need to add a `.env` file with the following environment variable for encryption:

```env
ENCRYPTION_KEY=your-encryption-key-here
```

### 2. Backend (🔑)

In the backend's `appsettings.json` file, make sure to add the following settings for JWT authentication and encryption:

```json
{
  "Jwt": {
    "Issuer": "https://localhost:5001",
    "SecretKey": "MySuperLongSecretKey1234567890123",
    "Lifetime": "60"
  },
  "EncryptionSettings": {
    "Key": "supersecretkey123456789012345678"
  }
}
```

### 3. Additional Setup 🛠️

Make sure to configure your API to securely handle **JWT authentication** and **encryption** based on the above settings.

---

## 📸 Screenshots

### 1. Landing Screen

![Landing Screen](images/landing.png)

### 2. Login Screen

![Login Screen](images/login.png)

### 3. Register Screen

![Register Screen](images/register.png)

### 4. Dashboard Screen

![Dashboard Screen](images/dashboard.png)
![Dashboard Screen](images/dashboard2.png)

### 5. Transfer Money Screen 

![Transfer Screen](transfer.png)

### 6. Transaction History

![Transaction History](transactionHistory.png)

### 7. User Management Screen

![Settings](settings.png)
![Settings](settings2.png)

---

