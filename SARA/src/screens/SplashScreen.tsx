import React, { useEffect, useRef } from 'react';
import { View, Text, StyleSheet, Animated, Dimensions, Easing } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../constants/colors';
import { MaterialIcons } from '@expo/vector-icons';
import { SaraLogo } from '../components/SaraLogo';

const { width, height } = Dimensions.get('window');

interface SplashScreenProps {
  onFinish: () => void;
}

export function SplashScreen({ onFinish }: SplashScreenProps) {
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const scaleAnim = useRef(new Animated.Value(0.3)).current;
  const slideUp1 = useRef(new Animated.Value(50)).current;
  const slideUp2 = useRef(new Animated.Value(80)).current;
  const slideUp3 = useRef(new Animated.Value(110)).current;
  const taglineOpacity = useRef(new Animated.Value(0)).current;
  const taglineTranslate = useRef(new Animated.Value(20)).current;
  const progressAnim = useRef(new Animated.Value(0)).current;
  const particleAnims = useRef(Array.from({ length: 20 }, () => new Animated.Value(0))).current;
  const progressWidth = progressAnim.interpolate({
    inputRange: [0, 1],
    outputRange: ['0%', '100%']
  });

  useEffect(() => {
    // Staggered entry animation
    Animated.stagger(100, [
      Animated.parallel([
        Animated.spring(scaleAnim, {
          toValue: 1,
          friction: 5,
          tension: 30,
          useNativeDriver: true
        }),
        Animated.timing(fadeAnim, {
          toValue: 1,
          duration: 1000,
          useNativeDriver: true
        })
      ]),
      Animated.timing(slideUp1, {
        toValue: 0,
        duration: 600,
        useNativeDriver: true
      }),
      Animated.timing(slideUp2, {
        toValue: 0,
        duration: 700,
        useNativeDriver: true
      }),
      Animated.timing(slideUp3, {
        toValue: 0,
        duration: 800,
        useNativeDriver: true
      })
    ]).start();

    // Floating particles animation
    particleAnims.forEach((anim, idx) => {
      Animated.loop(
        Animated.sequence([
          Animated.delay(idx * 150),
          Animated.timing(anim, {
            toValue: 1,
            duration: 3000 + idx * 200,
            useNativeDriver: true
          }),
          Animated.timing(anim, {
            toValue: 0,
            duration: 0,
            useNativeDriver: true
          })
        ])
      ).start();
    });

    Animated.sequence([
      Animated.delay(600),
      Animated.parallel([
        Animated.timing(taglineOpacity, {
          toValue: 1,
          duration: 600,
          useNativeDriver: true
        }),
        Animated.timing(taglineTranslate, {
          toValue: 0,
          duration: 600,
          useNativeDriver: true
        })
      ])
    ]).start();

    Animated.timing(progressAnim, {
      toValue: 1,
      duration: 2600,
      easing: Easing.out(Easing.exp),
      useNativeDriver: false
    }).start();

    const timer = setTimeout(() => {
      Animated.parallel([
        Animated.timing(taglineOpacity, {
          toValue: 0,
          duration: 400,
          useNativeDriver: true
        }),
        Animated.timing(fadeAnim, {
          toValue: 0,
          duration: 500,
          useNativeDriver: true
        }),
        Animated.timing(scaleAnim, {
          toValue: 1.2,
          duration: 500,
          useNativeDriver: true
        })
      ]).start(() => onFinish());
    }, 3500);

    return () => clearTimeout(timer);
  }, []);

  return (
    <View style={styles.container}>
      {/* Animated gradient background */}
      <LinearGradient
        colors={['#0D7C66', '#41B8A7', '#BDE8CA', '#F3FFFE']}
        style={StyleSheet.absoluteFillObject}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
      />

      {/* Floating particles */}
      {particleAnims.map((anim, idx) => {
        const x = (idx % 5) * (width / 5);
        const y = Math.floor(idx / 5) * (height / 4);
        const translateY = anim.interpolate({
          inputRange: [0, 1],
          outputRange: [0, -height]
        });
        const opacity = anim.interpolate({
          inputRange: [0, 0.5, 1],
          outputRange: [0, 0.4, 0]
        });
        return (
          <Animated.View
            key={idx}
            style={{
              position: 'absolute',
              left: x,
              top: y,
              width: 4 + (idx % 3) * 2,
              height: 4 + (idx % 3) * 2,
              borderRadius: (4 + (idx % 3) * 2) / 2,
              backgroundColor: idx % 2 === 0 ? '#fff' : '#41B8A7',
              opacity,
              transform: [{ translateY }]
            }}
          />
        );
      })}

      {/* Main content */}
      <Animated.View
        style={[
          styles.content,
          {
            opacity: fadeAnim,
            transform: [{ scale: scaleAnim }]
          }
        ]}
      >
        {/* Logo component */}
        <SaraLogo size={160} animated={true} />
      </Animated.View>

      <Animated.View
        style={[
          styles.taglineWrapper,
          {
            opacity: taglineOpacity,
            transform: [{ translateY: taglineTranslate }]
          }
        ]}
      >
        <Text style={styles.taglinePrimary}>نجهز منصاتك الحكومية</Text>
        <Text style={styles.taglineSecondary}>سارة تفعّل OTP، ترتب مواعيد أبشر، وتجهز لك كل الخدمات قبل ما تبدأ</Text>
        <View style={styles.progressTrack}>
          <Animated.View style={[styles.progressFill, { width: progressWidth }]} />
        </View>
      </Animated.View>

      {/* Bottom elements */}
      <Animated.View
        style={[
          styles.bottomContent,
          {
            opacity: fadeAnim,
            transform: [{ translateY: slideUp3 }]
          }
        ]}
      >
        <View style={styles.badge}>
          <MaterialIcons name="verified" size={20} color="#0D7C66" />
          <Text style={styles.badgeText}>خدمة حكومية معتمدة</Text>
          <Text style={styles.badgeFlag}>🇸🇦</Text>
        </View>
        
        <Text style={styles.poweredBy}>Powered by Groq AI</Text>
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#0D7C66'
  },
  content: {
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1
  },
  bottomContent: {
    position: 'absolute',
    bottom: 60,
    alignItems: 'center',
    gap: 12
  },
  taglineWrapper: {
    alignItems: 'center',
    paddingHorizontal: 40
  },
  taglinePrimary: {
    fontSize: 22,
    fontFamily: 'Tajawal_700Bold',
    color: '#F9FAFB',
    textAlign: 'center'
  },
  taglineSecondary: {
    fontSize: 13,
    fontFamily: 'Tajawal_400Regular',
    color: 'rgba(255,255,255,0.8)',
    textAlign: 'center',
    marginTop: 8,
    lineHeight: 20
  },
  progressTrack: {
    width: width * 0.6,
    height: 6,
    borderRadius: 3,
    backgroundColor: 'rgba(255,255,255,0.2)',
    marginTop: 16,
    overflow: 'hidden'
  },
  progressFill: {
    height: '100%',
    borderRadius: 3,
    backgroundColor: '#FDE68A'
  },
  badge: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    gap: 8,
    backgroundColor: 'rgba(255,255,255,0.98)',
    paddingHorizontal: 20,
    paddingVertical: 12,
    borderRadius: 25,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 6
  },
  badgeText: {
    fontSize: 14,
    fontFamily: 'Tajawal_700Bold',
    color: '#0D7C66'
  },
  badgeFlag: {
    fontSize: 20
  },
  poweredBy: {
    fontSize: 11,
    fontFamily: 'Tajawal_400Regular',
    color: 'rgba(255,255,255,0.7)',
    letterSpacing: 1
  }
});
