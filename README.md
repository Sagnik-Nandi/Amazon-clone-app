# Amazon_clone

Made an Amazon clone using Flutter and NodeJS.

## Running Locally

After cloning this repository, migrate to the Amazon_clone folder. Then, follow the following steps:

- Create MongoDB Project & Cluster
- Click on Connect, follow the process where you will get the uri.- Replace the MongoDB uri with yours in server/index.js.
- Head to lib/constants/global_variables.dart file, replace with your IP Address.
- Create Cloudinary Project, enable unsigned operation in settings.
- Head to lib/features/admin/services/admin_services.dart, replace dkdwpotx5 and unpxckbx with your Cloud Name and Upload Preset respectively.
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

## References

- [Rivaan Ranawat's](https://github.com/RivaanRanawat) [Youtube tutorial](https://www.youtube.com/watch?v=ylJz7N-dv1E)
- [Flutter Documentation](https://docs.flutter.dev/)
