#!/bin/bash
echo "Getting SHA-1 fingerprints for Firebase..."
echo "Debug SHA-1:"
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1
echo ""
echo "Add these SHA-1 fingerprints to your Firebase Console:"
echo "1. Go to Firebase Console > Project Settings > Your Apps > Android App"
echo "2. Add the SHA-1 fingerprints shown above"