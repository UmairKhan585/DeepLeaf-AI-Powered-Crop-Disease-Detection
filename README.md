# DeepLeaf: AI-Powered Crop Disease Detection

## Overview

DeepLeaf is a comprehensive system for detecting and classifying rice leaf diseases using advanced deep learning models. The project integrates a mobile app built with Flutter, a web interface developed in React, and a backend API powered by FastAPI and TensorFlow. This solution aids in early diagnosis and effective management of rice plant diseases.

## Key Points

- **Technologies Used**:
  - **Flutter**: For the mobile application interface.
  - **FastAPI**: For the backend API to handle image uploads and predictions.
  - **TensorFlow**: For the deep learning model used for disease classification.
  - **React**: For the web front-end interface.

- **Model Performance**: Utilizes EfficientNet-B1 for classifying rice leaf diseases with high accuracy (96.84%).

## Important Information about TensorFlow Addons in This Project

### Overview

This project utilizes the tf.keras.applications.VGG16 pre-trained model from TensorFlow Addons. Please note that TensorFlow Addons has reached its end-of-life (EOL) as of May 2024.

### Key Points

- **Limited Maintenance**: TensorFlow Addons will receive only minimal maintenance updates moving forward. No new features will be added, and the library will be maintained with critical updates only.
  
- **Alternatives**:
  - **Pre-trained Models in tf.keras.applications**: Explore other pre-trained models available directly in `tf.keras.applications`, which might offer similar or enhanced functionalities.
  - **PyTorch**: Consider migrating to PyTorch, which provides robust support for a variety of models and has an active development community.
  - **Keras**: For those who prefer not to use TensorFlow Addons, Keras (independent of TensorFlow Addons) is a strong alternative for building and training models.

- **Continued Use (Cautionary)**: If you decide to continue using TensorFlow Addons, be aware of potential issues due to the lack of active development. Regularly monitor the project for any critical security updates or necessary patches.

### Moving Forward

We recommend evaluating the alternatives mentioned above to ensure the long-term sustainability and support of your project. Transitioning to supported libraries or frameworks will help maintain compatibility and access to new features and improvements.

### Further Reading

For more information on the alternatives and their capabilities, you may refer to the following resources:
- [TensorFlow Pre-trained Models](https://www.tensorflow.org/api_docs/python/tf/keras/applications)
- [PyTorch Documentation](https://pytorch.org/docs/stable/index.html)
- [Keras Documentation](https://keras.io/api/)

## Project Structure

- **`main.dart`**: Flutter application entry point.
- **`widget_test.dart`**: Basic widget test for Flutter application.
- **`pubspec.yaml`**: Flutter project dependencies and configuration.
- **`requirements.txt`**: Python dependencies for the backend.
- **`main.py`**: FastAPI backend for image prediction.
- **`main-tf-serving.py`**: Alternative backend implementation using TensorFlow Serving.
- **`unicorn command.txt`**: Command to run the FastAPI application with Uvicorn.
- **`App.js`**: React component for the front-end application.
- **`App.test.js`**: Test file for React components.
- **`home.js`**: React component for handling image uploads and displaying results.
- **`index.css`**: CSS styles for the React application.
- **`index.js`**: Entry point for the React application.

## Contributing

Contributions are welcome! To propose changes, please fork the repository, make your changes, and submit a pull request.

## Authors
- **Umair Munir**
- **Muzaffar Waleed**
---

**🔍 Stay informed and ensure your project's sustainability by exploring new technologies and frameworks! 🚀**

---
