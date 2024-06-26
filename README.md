# Amazon_clone

Made an Amazon clone using Flutter and NodeJS.

## Running Locally

After cloning this repository, migrate to the Amazon_clone folder. Then, follow the following steps:

- Create MongoDB Project & Cluster
- Click on Connect, follow the process where you will get the uri.- Replace the MongoDB uri with yours in server/index.js.
- Head to lib/constants/global_variables.dart file, replace with your IP Address.

Then run the following commands to run your app:

### Server Side
  
  ```console
  cd server
  npm install
  npm run dev (for continuous development)
  OR
  npm start (to run script 1 time)
  ```

### Client Side
  
  ```console
  flutter pub get
  open -a simulator (to get iOS Simulator)
  flutter run
  ```