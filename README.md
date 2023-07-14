# Savings App: Flutter Simulation Project
This application aims to provide users the ability to plan and keep track of their expenses.

To get started in running this project locally, first clone this repo with the following comman

```
git clone git@github.com:framgia/sph-flutter.git
```

Make sure that you have access to this repository and that your machine's SSH is set up and authorized with your account

# Prerequisites
- Flutter (latest version from stable channel)
- Laravel
- Android Studio
  - Android Emulator (From Android Studio)
  - Android Device (optional)
- VSCode
  - Extensions:
  - Dart
  - Flutter
  - Pubspec Assist

# Frontend (Flutter)
The frontend is currently running the latest build of Flutter in the *stable* channel. <br>
**You will need Flutter to be able to run this application.**

If you do not have Flutter installed, you can follow the guide below. <br>
https://docs.flutter.dev/get-started/install

### Running the application
First, make sure you have a working Android emulator set up.

**(OPTIONAL)**
You can connect an Android device with **USB Debugging** enabled in the developer settings.

Then, at the bottom right of your IDE, click on the device selector.

It is found usually the same place you can see *Linux (linux-x64)*
![image](https://github.com/framgia/sph-flutter/assets/99173155/6aa1ce4c-18ae-42be-8333-78927f6f242d)

After clicking, you can select which device you can run the application in. Select the device most appropriate to you. <br>
Once done selecting, click on the upper right *play* button to start running the application
![image](https://github.com/framgia/sph-flutter/assets/99173155/82dfc361-ec23-4b1c-ad0b-c34f45b9b44b)

# Backend (Laravel)
Laravel utilizes Composer to manage its dependencies. So, before using Laravel, make sure you have Composer installed on your machine.
Here is the link to Composer: https://getcomposer.org/

First, download the Laravel installer using Composer by running the command:

**composer global require laravel/installer**

*Make sure to place Composer's system-wide vendor bin directory in your $PATH so the laravel executable can be located by your system.

## Running the application
1. First, get your computer's ip address
2. Run the command: **php artisan serve --host \<ip> --port 80**
3. example **php artisan serve --host 192.168.1.4 --port 80**
4. update frontend's .env "BACKEND_URL" to http://\<ip>:\<port>, example **BACKEND_URL=http://192.168.1.4:80**

### To know all the commands
Run the command: **php artisan**

# Creating Docker setup for database
### Prerequisites
- Docker and MySQL
- Update.env file
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3308
DB_DATABASE=savings
DB_USERNAME=root
DB_PASSWORD=root
```

### Steps
- install docker in your machine, refer to this link: https://docs.docker.com/desktop/install/windows-install/
- make sure [PR02](https://github.com/framgia/sph-flutter/pull/2) is already included in your latest branch
- run "docker-compose up" in the backend dir
- check if Backend container was successfully created
- then run the migration command "php artisan migrate"

## Database Seeders
[Laravel Documentation](https://laravel.com/docs/8.x/seeding#introduction)
### Running a seeder class
`php artisan db:seed --class=UserSeeder`

### Running a database wipe and seeding at the same time
`php artisan migrate:fresh --seed`  
or  
`php artisan migrate:fresh --seeder=UserSeeder`

## Thunder client
### Download vscode extension for Thunder Client
### Thunder client extension settings
- update on User Settings
  - for JSON, `"thunder-client.saveToWorkspace": true,`
  - for UI, search "Thunder Client", tick on "Save to Workspace" option
### Setting up collection
- open thunder client on side bar
  - goto Collections, click menu ☰
  - import, import collections by json
### Setting up environments
- open thunder client on side bar
  - goto Env, click menu ☰
  - import, import env by json
  - create your own env and mark it as active
  - for this project, setup your own "host" since every may have different host in your own environments
- for other environment variables used in the project, set them up in global environment, not local env, not collection env, not custom env