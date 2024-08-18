## Learning Support: eWallet Backend

Welcome to the **eWallet Backend** project! This repository provides a backend server designed specifically to support students learning iOS development.

### Overview

This backend is not a fully-fledged eWallet application but rather a foundational setup to help students connect their iOS applications to a server. The primary goal is to give students a hands-on experience with backend integration, API interactions, and networking fundamentals.

### Key Features

- **Authentication**: JWT authentication mechanisms to help students understand user management and security.
- **Wallet**: View wallet balance.
- **Transaction**: Create transaction requests, process payments, and update wallet balances.
- **Topup**: Integrate with the Midtrans payment gateway for wallet top-ups.

### How to Use

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/syaifulamindev/learning-support-ewallet-backend.git
   ```

2. **Install Tools**:
   Navigate to the project directory and install the necessary dependencies.

   - Install Vapor (optional):
     ```sh
     brew install vapor
     ```

   - Install `qrencode` for generating QR codes (available on Linux as well):
     ```sh
     brew install qrencode
     ```

   - Install MongoDB:
     ```sh
     brew tap mongodb/brew
     brew install mongodb-community@7.0
     ```

3. **Run the Server**:
   - Start MongoDB as a background process. Please refer to the MongoDB documentation if this command does not work:
     ```sh
     mongod --config /opt/homebrew/etc/mongod.conf --fork
     ```

   - For the first run, execute the migration script:
     ```sh
     swift run App migrate
     ```

   - After that, you can run the server via Xcode (using the play button) or via the terminal:
     ```sh
     swift run
     ```

4. **Configure Payment Gateway**:
   We use Midtrans for top-ups.
   
   - Set up the Payment Notification URL by going to [Midtrans Dashboard](https://dashboard.sandbox.midtrans.com/settings/payment/notification) and changing the Payment Notification URL to `<base_url>/midtrans/notifications`.
   - Create a `.env` file in the root folder with the following content:
     ```env
     SERVER_KEY='<your_server_key>'
     ```
     Get your server key from [Midtrans Dashboard](https://dashboard.sandbox.midtrans.com/settings/config_info).
     
### Postman Collection

To help you test the API endpoints, a Postman collection is available. You can import this collection into Postman to get a pre-configured set of requests.

- **Postman Collection**: [eWallet Backend Postman Collection](postman/eWallet_Backend_Collection.json)

  - Download the Postman collection JSON file from the `postman` directory in this repository.
  - Open Postman and go to `File` -> `Import`.
  - Choose the downloaded JSON file to import the collection.
    
### Contributions

This project is intended for educational purposes, so contributions from students and educators are welcome. Feel free to open issues, suggest improvements, or submit pull requests to enhance the learning experience.

### License

This project is licensed under the [WTFPL License](LICENSE). 
You can do whatever you want with this project—no restrictions, no limitations. 
For more details, see the [WTFPL license file](LICENSE).
