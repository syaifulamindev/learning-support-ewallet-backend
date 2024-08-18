## Learning Support: eWallet Backend

Welcome to the **eWallet Backend** project! This repository provides a backend server designed specifically to support students learning iOS development. 

### Overview

This backend is not a fully-fledged eWallet application but rather a foundational setup to help students connect their iOS applications to a server. The primary goal is to give students a hands-on experience with backend integration, API interactions, and networking fundamentals.

### Key Features

- **Authentication**: JWT authentication mechanisms to help students understand user management and security.
- **Wallet**: see saldo on walet
- **Transaction**: create transaction request, pay, and update wallet
- **Topup**: using midtrans payment gateway


### How to Use

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/yourusername/ewallet-backend.git
   ```

2. **Install Tools**:
   Navigate to the project directory and install the necessary dependencies.

   install vapor (optional) 
   ```sh
   brew install vapor
   ```

   install qrencode for generate qrcode, qrencode is also available on linux
   ```sh
   brew install qrencode
   ```

   install mongodb
   ```sh
   brew tap mongodb/brew
   brew install mongodb-community@7.0
   ```
   

3. **Run the Server**:
    start mongodb as background process, please read mongodb documentatioin if this doesn't work
    ```sh
    mongod --config /opt/homebrew/etc/mongod.conf --fork
    ```

    for the first run, plese run migration script
    ```sh
        swift run App migrate
    ```

    after that you can run via xcode with play button or via terminal
    ```sh
    swift run
    ```

4. **Configure Payment Gateway**:
    We use midtrans for topup.
    
    - Setup Payment notification URL, goto https://dashboard.sandbox.midtrans.com/settings/payment/notification
    and change the Payment notification URL to <base_url>/midtrans/notifications
    - Create .env file in root folder, and create SERVER_KEY='<server_key>', get your server key at https://dashboard.sandbox.midtrans.com/settings/config_info

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
