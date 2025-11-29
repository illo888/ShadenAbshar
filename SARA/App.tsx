import React, { useEffect, useState } from 'react';
import { I18nManager } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import * as ExpoSplashScreen from 'expo-splash-screen';
import { AppNavigator } from './src/navigation/AppNavigator';
import { SplashScreen } from './src/screens/SplashScreen';
import { UserProvider } from './src/context/UserContext';
import { OtpProvider } from './src/context/OtpContext';
import { useFonts, Tajawal_400Regular, Tajawal_700Bold } from '@expo-google-fonts/tajawal';

// Enable RTL layout for Arabic (stay passive in dev)
if (!I18nManager.isRTL) {
  I18nManager.allowRTL(true);
  I18nManager.forceRTL(true);
  // Reload required after changing layout; in Expo this may not take effect instantly but it's ok for demo
}

ExpoSplashScreen.preventAutoHideAsync();

export default function App() {
  const [fontsLoaded] = useFonts({ Tajawal_400Regular, Tajawal_700Bold });
  const [showSplash, setShowSplash] = useState(true);

  useEffect(() => {
    if (fontsLoaded) {
      const timer = setTimeout(() => ExpoSplashScreen.hideAsync(), 500);
      return () => clearTimeout(timer);
    }
  }, [fontsLoaded]);

  if (!fontsLoaded) return null;

  if (showSplash) {
    return <SplashScreen onFinish={() => setShowSplash(false)} />;
  }

  return (
    <UserProvider>
      <OtpProvider>
        <NavigationContainer>
          <AppNavigator />
        </NavigationContainer>
      </OtpProvider>
    </UserProvider>
  );
}
