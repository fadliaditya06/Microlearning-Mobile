// src/firebaseConfig.js

// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";

// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyB5CyBpLb-xf4rQFNU3fGutSHxyKyc-5U4",
  authDomain: "microlearning-ea3cc.firebaseapp.com",
  projectId: "microlearning-ea3cc",
  storageBucket: "microlearning-ea3cc.appspot.com",
  messagingSenderId: "382985641726",
  appId: "1:382985641726:web:2a140afb622ab19d294faf",
  measurementId: "G-SVTGG733PB"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

export { app, analytics };
