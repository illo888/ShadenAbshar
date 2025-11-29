import React, { useMemo } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Animated } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { mockUserData } from '../constants/mockData';
import { colors } from '../constants/colors';
import { ServiceCard } from '../components/ServiceCard';
import { MaterialIcons, FontAwesome } from '@expo/vector-icons';
import { Linking } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { User } from '../types';
import { AIWave } from '../components/AIWave';
import { AnimatedButton } from '../components/AnimatedButton';
import { useOtp } from '../context/OtpContext';

export function HomeScreen() {
  const navigation = useNavigation();
  const user: User = mockUserData;
  const scrollY = new Animated.Value(0);
  const { enabled: otpEnabled, messages: otpMessages } = useOtp();

  const activeServices = useMemo(() => user.services.filter((s) => s.status === 'نشط'), [user.services]);
  const activeServiceNames = activeServices.slice(0, 2).map((service) => service.nameAr).join(' • ');
  const notificationsPreview = user.notifications[0]?.titleAr ?? 'ما فيه تنبيهات جديدة';

  const quickStats = [
    {
      key: 'services',
      title: 'الخدمات الجاهزة',
      value: activeServices.length,
      subtitle: activeServiceNames || 'لا توجد خدمات مفعّلة حالياً',
      gradient: [colors.primary, '#0A6B58'] as [string, string],
  icon: 'check-circle' as const,
      chip: 'منصة أبشر',
      onPress: () => navigation.navigate('Services' as never)
    },
    {
      key: 'alerts',
      title: 'التنبيهات الحرجة',
      value: user.notifications.length,
      subtitle: notificationsPreview,
      gradient: ['#F59E0B', '#EA580C'] as [string, string],
      icon: 'notifications-active' as const,
      chip: user.notifications.length > 0 ? 'مطلوب متابعة' : 'كل شيء تحت السيطرة',
      onPress: () => navigation.navigate('Profile' as never)
    },
    {
      key: 'otp',
      title: 'رموز OTP الجديدة',
      value: otpEnabled ? otpMessages.length : 0,
      subtitle: otpEnabled
        ? `آخر رمز من ${otpMessages[0]?.sender || 'البنوك السعودية'}`
        : 'فعّل البوابة الآمنة لتستقبل الأكواد فوراً',
      gradient: ['#2563EB', '#1D4ED8'] as [string, string],
      icon: 'password' as const,
      chip: otpEnabled ? 'متوفرة لحظياً' : 'يتطلب تفعيل',
      onPress: () => navigation.navigate('SafeGate' as never)
    }
  ];

  const headerOpacity = scrollY.interpolate({
    inputRange: [0, 100],
    outputRange: [1, 0.8],
    extrapolate: 'clamp'
  });

  return (
    <View style={styles.container}>
      <LinearGradient 
        colors={['#FFFFFF', '#E8F8F3']} 
        style={StyleSheet.absoluteFillObject}
      />
      
      <ScrollView
        showsVerticalScrollIndicator={false}
        scrollEventThrottle={16}
        onScroll={Animated.event(
          [{ nativeEvent: { contentOffset: { y: scrollY } } }],
          { useNativeDriver: false }
        )}
      >
        <Animated.View style={[styles.header, { opacity: headerOpacity }]}>
          <View style={styles.headerTop}>
            <TouchableOpacity onPress={() => navigation.navigate('Profile' as never)}>
              <MaterialIcons name="person-outline" size={28} color={colors.primary} />
            </TouchableOpacity>
            <View style={styles.welcomeContainer}>
              <Text style={styles.welcomeLabel}>مرحباً بك</Text>
              <Text style={styles.welcome}>{user.name.split(' ')[0]} 👋</Text>
            </View>
            <TouchableOpacity onPress={() => Linking.openURL(`tel:${user.phone || '800123456'}`)}>
              <MaterialIcons name="phone" size={28} color={colors.primary} />
            </TouchableOpacity>
          </View>
        </Animated.View>

        <View style={styles.aiContainer}>
          <AIWave size={220} />
          <View style={styles.actionCenter}>
            <AnimatedButton title="ابدأ محادثة مع سارا" onPress={() => navigation.navigate('Chat' as never)} />
            <TouchableOpacity 
              style={styles.heart} 
              activeOpacity={0.7}
              onPress={() => console.log('Liked!')}
            >
              <FontAwesome name="heart" size={16} color="white" />
            </TouchableOpacity>
          </View>
        </View>

        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.statsContainer}
        >
          {quickStats.map((stat) => (
            <TouchableOpacity
              key={stat.key}
              style={styles.statCard}
              activeOpacity={0.8}
              onPress={stat.onPress}
            >
              <LinearGradient
                colors={stat.gradient}
                style={styles.statGradient}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
              >
                <View style={styles.statHeaderRow}>
                  <MaterialIcons name={stat.icon} size={24} color="#fff" />
                  <View style={styles.statValueWrapper}>
                    <Text style={styles.statNumber}>{stat.value}</Text>
                    <Text style={styles.statTitle}>{stat.title}</Text>
                  </View>
                </View>
                <Text style={styles.statSubtitle} numberOfLines={2}>{stat.subtitle}</Text>
                <View style={styles.statChip}>
                  <Text style={styles.statChipText}>{stat.chip}</Text>
                  <MaterialIcons name="bolt" size={14} color="#0D7C66" />
                </View>
              </LinearGradient>
            </TouchableOpacity>
          ))}
        </ScrollView>

        <View style={styles.servicesSection}>
          <View style={styles.sectionHeader}>
            <TouchableOpacity onPress={() => navigation.navigate('Services' as never)}>
              <Text style={styles.seeAll}>عرض الكل ←</Text>
            </TouchableOpacity>
            <Text style={styles.sectionTitle}>خدماتك</Text>
          </View>
          {user.services.map((item) => (
            <ServiceCard key={item.id} service={item} />
          ))}
        </View>
        
        <View style={{ height: 100 }} />
      </ScrollView>

      <TouchableOpacity
        style={styles.fab}
        activeOpacity={0.8}
        onPress={() => navigation.navigate('Chat' as never)}
      >
        <LinearGradient
          colors={[colors.primary, colors.accent]}
          style={styles.fabGradient}
        >
          <MaterialIcons name="chat" size={26} color="#fff" />
        </LinearGradient>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background
  },
  header: {
    paddingHorizontal: 20,
    paddingTop: 54,
    paddingBottom: 20
  },
  headerTop: {
    flexDirection: 'row-reverse',
    justifyContent: 'space-between',
    alignItems: 'center'
  },
  welcomeContainer: {
    alignItems: 'center',
    flex: 1
  },
  welcomeLabel: {
    fontSize: 12,
    color: colors.textLight,
    fontFamily: 'Tajawal_400Regular'
  },
  welcome: {
    fontSize: 20,
    fontWeight: '700',
    fontFamily: 'Tajawal_700Bold',
    color: colors.text,
    marginTop: 4
  },
  aiContainer: {
    marginTop: 10,
    marginBottom: 20,
    alignItems: 'center',
    justifyContent: 'center'
  },
  actionCenter: {
    position: 'absolute',
    alignItems: 'center',
    justifyContent: 'center'
  },
  heart: {
    marginTop: 16,
    backgroundColor: colors.secondary,
    padding: 10,
    borderRadius: 24,
    shadowColor: colors.secondary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 6,
    elevation: 4
  },
  statsContainer: {
    paddingHorizontal: 16,
    paddingBottom: 20,
    flexDirection: 'row-reverse'
  },
  statCard: {
    width: 240,
    marginLeft: 12,
    borderRadius: 20,
    overflow: 'hidden',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 8,
    elevation: 5
  },
  statGradient: {
    padding: 20,
    height: 180,
    justifyContent: 'space-between',
    alignItems: 'flex-end'
  },
  statTitle: {
    fontSize: 13,
    color: '#fff',
    marginTop: 8,
    fontFamily: 'Tajawal_400Regular'
  },
  statNumber: {
    fontSize: 32,
    fontWeight: '700',
    color: '#fff',
    marginTop: 4,
    fontFamily: 'Tajawal_700Bold'
  },
  statHeaderRow: {
    width: '100%',
    flexDirection: 'row-reverse',
    alignItems: 'center',
    justifyContent: 'space-between'
  },
  statValueWrapper: {
    alignItems: 'flex-end'
  },
  statSubtitle: {
    fontSize: 13,
    color: 'rgba(255,255,255,0.9)',
    fontFamily: 'Tajawal_400Regular',
    textAlign: 'right',
    marginTop: 12,
    lineHeight: 20
  },
  statChip: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    backgroundColor: 'rgba(255,255,255,0.9)',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 14,
    alignSelf: 'flex-end'
  },
  statChipText: {
    fontSize: 12,
    fontFamily: 'Tajawal_700Bold',
    color: '#0D7C66',
    marginLeft: 6
  },
  servicesSection: {
    paddingHorizontal: 16
  },
  sectionHeader: {
    flexDirection: 'row-reverse',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '700',
    fontFamily: 'Tajawal_700Bold',
    color: colors.text
  },
  seeAll: {
    fontSize: 14,
    color: colors.primary,
    fontFamily: 'Tajawal_400Regular'
  },
  fab: {
    position: 'absolute',
    bottom: 24,
    right: 24,
    width: 64,
    height: 64,
    borderRadius: 32,
    shadowColor: colors.primary,
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.4,
    shadowRadius: 10,
    elevation: 8,
    overflow: 'hidden'
  },
  fabGradient: {
    width: '100%',
    height: '100%',
    alignItems: 'center',
    justifyContent: 'center'
  }
});
