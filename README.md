# 🤝 Deal or No Deal

**Deal or No Deal** is a game app based on the popular American TV show of the same name. It offers players an engaging and interactive experience with stunning animations, graphics, sound effects, and background music.

## 🌟 Overview
**Name**: Deal or No Deal  
**Purpose**: To provide an immersive and interactive gaming experience based on the popular TV show.  
**Target Audience**: Fans of the TV show and anyone who enjoys interactive, suspenseful games.  
**Unique Selling Proposition**: Combines the thrill of the TV show with interactive animations and high-quality sound effects.

## 🎮 Game Rules
- **Initial Setup**: There are 20 cases, each containing a different amount of money ranging from one dollar to one million dollars.
- **Case Selection**: At the beginning of the game, the player selects one case at random.
- **Objective**: The player aims to sell their selected case back to The Banker for the highest possible amount.
- **Game Rounds**: The game consists of 6 rounds. In each round, the player opens a set number of cases, revealing the amounts inside. These amounts are then eliminated from the game.
- **Banker's Offer**: After each round, The Banker will call with an offer to buy the player’s case.
- **Decision Making**: The player can choose to accept the offer or continue opening cases. If all offers are refused, the player will win the amount in their initially chosen case.
  
![IMG_7212](https://github.com/AlexMarcus17/DealOrNoDealGame/assets/67654354/d3b4fd69-10d9-47e2-b498-995965c2d570)

## 🛠️ Tech Stack
- **Development**: Flutter, Dart
- **Animations**: Lottie, Rive
- **Monetization**: Google Mobile Ads
- **Sound Effects and Music**: just_audio
- **State Management**: Provider
- **Dependency Injection**: get_it
- **Local Storage**: Shared Preferences

## 🏗️ Architecture
- **Screens**: The game comprises 5 main screens.
- **Widgets**: Includes several reusable widgets to enhance code reusability and maintainability.
- **Sound Management**: A dedicated sound manager to handle sound effects and music.
- **State Management**: GameProvider is used to maintain the state of the game.
- **Routing**: A route generator is used for managing

## 📄 License

GNU General Public License v3.0
