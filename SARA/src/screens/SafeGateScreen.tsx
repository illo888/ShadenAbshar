import React, { useState, useEffect, useRef } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert, Linking, ScrollView, Platform } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../constants/colors';
import { MaterialIcons } from '@expo/vector-icons';
import { useOtp } from '../context/OtpContext';

// Emergency Saudi hotline numbers
const SAUDI_EMERGENCY_NUMBERS = {
  general: '112', // General emergency in Saudi Arabia
  police: '999',
  ambulance: '997',
  civilDefense: '998',
  safeGateSupport: '920003344' // Mock support number for Safe Gate service
};

// Mock OTP message generators
const OTP_SENDERS = [
  { name: 'مصرف الراجحي', icon: '🏦', purposes: ['تسجيل دخول', 'تحويل مالي', 'دفع فاتورة'] },
  { name: 'البنك الأهلي', icon: '🏦', purposes: ['تأكيد عملية', 'تسجيل دخول', 'شراء إلكتروني'] },
  { name: 'أبشر', icon: '🇸🇦', purposes: ['تسجيل دخول', 'طلب خدمة', 'تحديث بيانات'] },
  { name: 'وزارة العدل', icon: '⚖️', purposes: ['استعلام', 'طلب وثيقة', 'تأكيد موعد'] },
  { name: 'بنك الرياض', icon: '🏦', purposes: ['تحويل مالي', 'تسجيل دخول'] },
  { name: 'stc pay', icon: '💳', purposes: ['دفع', 'تسجيل دخول'] }
];

function generateOTPCode(): string {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

function getCurrentTime(): string {
  const now = new Date();
  return now.toLocaleTimeString('ar-SA', { hour: '2-digit', minute: '2-digit', hour12: true });
}

function getCurrentDate(): string {
  const now = new Date();
  return now.toLocaleDateString('ar-SA', { year: 'numeric', month: 'long', day: 'numeric' });
}

export function SafeGateScreen() {
  const { enabled: otpRegistered, registerOtp, addOtpMessage, messages: otpMessages } = useOtp();
  const [vpnEnabled, setVpnEnabled] = useState(false);
  const intervalRef = useRef<NodeJS.Timeout | null>(null);
  const stopTimerRef = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    if (otpRegistered && otpMessages.length === 0) {
      startOTPSimulation();
    }
  }, [otpRegistered, otpMessages.length]);

  useEffect(() => {
    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
      if (stopTimerRef.current) {
        clearTimeout(stopTimerRef.current);
      }
    };
  }, []);

  function startOTPSimulation() {
    addNewOTPMessage();

    if (intervalRef.current) {
      clearInterval(intervalRef.current);
    }
    if (stopTimerRef.current) {
      clearTimeout(stopTimerRef.current);
    }

    intervalRef.current = setInterval(() => {
      addNewOTPMessage();
    }, Math.random() * 10000 + 5000);

    stopTimerRef.current = setTimeout(() => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
        intervalRef.current = null;
      }
    }, 60000);
  }

  function addNewOTPMessage() {
    const sender = OTP_SENDERS[Math.floor(Math.random() * OTP_SENDERS.length)];
    const purpose = sender.purposes[Math.floor(Math.random() * sender.purposes.length)];

    addOtpMessage({
      id: Date.now(),
      sender: sender.name,
      senderIcon: sender.icon,
      code: generateOTPCode(),
      purpose,
      time: getCurrentTime(),
      date: getCurrentDate()
    });
  }

  function registerOTP() {
    if (!otpRegistered) {
      registerOtp();
    }
    Alert.alert('✅ تم التسجيل', 'تم ربط رقمك السعودي بخدمة OTP الآمنة. سوف تبدأ استقبال الرموز الآن...');
  }

  function enableVPN() {
    setVpnEnabled(true);
    Alert.alert('تم التفعيل', 'تم تفعيل VPN السعودي الاستثنائي للبنوك والتطبيقات الحكومية');
  }

  function criticalCall() {
    Alert.alert(
      'اتصال طارئ لمدة 10 دقائق',
      'سيتم فتح اتصال مباشر داخل السعودية. اختر الرقم:',
      [
        {
          text: 'الطوارئ العامة (112)',
          onPress: () => makeCall(SAUDI_EMERGENCY_NUMBERS.general)
        },
        {
          text: 'دعم البوابة الآمنة',
          onPress: () => makeCall(SAUDI_EMERGENCY_NUMBERS.safeGateSupport)
        },
        {
          text: 'الشرطة (999)',
          onPress: () => makeCall(SAUDI_EMERGENCY_NUMBERS.police)
        },
        {
          text: 'إلغاء',
          style: 'cancel'
        }
      ],
      { cancelable: true }
    );
  }

  async function makeCall(phoneNumber: string) {
    const url = `tel:${phoneNumber}`;
    const canOpen = await Linking.canOpenURL(url);
    
    if (canOpen) {
      await Linking.openURL(url);
    } else {
      Alert.alert('خطأ', 'لا يمكن إجراء المكالمة من هذا الجهاز');
    }
  }

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <LinearGradient colors={[colors.primary, '#0A6B58']} style={styles.header}>
        <Text style={styles.title}>Saudi Safe Security Gate 🇸🇦</Text>
        <Text style={styles.subtitle}>بوابة آمنة للسعوديين خارج المملكة</Text>
      </LinearGradient>

      <ScrollView 
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>مزايا البوابة</Text>
        <View style={styles.card}>
          <View style={styles.row}>
            <MaterialIcons name="password" size={22} color={colors.primary} />
            <Text style={styles.cardText}>إدارة رموز OTP للتطبيقات السعودية</Text>
          </View>
          <View style={styles.row}>
            <MaterialIcons name="vpn-lock" size={22} color={colors.primary} />
            <Text style={styles.cardText}>VPN سعودي استثنائي للبنوك والخدمات</Text>
          </View>
          <View style={styles.row}>
            <MaterialIcons name="call" size={22} color={colors.primary} />
            <Text style={styles.cardText}>اتصال طارئ لمدة 10 دقائق داخل السعودية</Text>
          </View>
        </View>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>الإجراءات</Text>

        <TouchableOpacity style={styles.actionBtn} onPress={registerOTP} activeOpacity={0.8}>
          <LinearGradient colors={[colors.primary, colors.accent]} style={styles.actionGrad}>
            <MaterialIcons name="password" size={20} color="#fff" />
            <Text style={styles.actionText}>{otpRegistered ? 'تم ربط OTP' : 'ربط OTP الآمن'}</Text>
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity style={styles.actionBtn} onPress={enableVPN} activeOpacity={0.8}>
          <LinearGradient colors={[colors.primary, colors.accent]} style={styles.actionGrad}>
            <MaterialIcons name="vpn-lock" size={20} color="#fff" />
            <Text style={styles.actionText}>{vpnEnabled ? 'VPN مفعّل' : 'تفعيل VPN السعودي'}</Text>
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity style={styles.actionBtn} onPress={criticalCall} activeOpacity={0.8}>
          <LinearGradient colors={['#DC2626', '#B91C1C']} style={styles.actionGrad}>
            <MaterialIcons name="call" size={22} color="#fff" />
            <Text style={styles.actionText}>اتصال طارئ مباشر (LIVE) 🔴</Text>
          </LinearGradient>
        </TouchableOpacity>
        
        <View style={styles.liveCallNote}>
          <MaterialIcons name="phone-in-talk" size={18} color="#DC2626" />
          <Text style={styles.liveCallText}>
            المكالمة مباشرة وحقيقية - سيتم فتح تطبيق الهاتف للاتصال بالأرقام الطارئة السعودية
          </Text>
        </View>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>✨ اشترك الآن</Text>
        
        {/* Premium Subscription Card */}
        <LinearGradient 
          colors={['#FFFFFF', '#F0FDF4']} 
          style={styles.subscriptionCard}
        >
          {/* Badge */}
          <View style={styles.popularBadge}>
            <MaterialIcons name="star" size={14} color="#FBBF24" />
            <Text style={styles.popularText}>الأكثر شعبية</Text>
          </View>

          {/* Price Section */}
          <View style={styles.priceContainer}>
            <View style={styles.priceRow}>
              <Text style={styles.currency}>ريال</Text>
              <Text style={styles.price}>29</Text>
            </View>
            <Text style={styles.pricePeriod}>شهرياً فقط</Text>
            <View style={styles.savingsBadge}>
              <Text style={styles.savingsText}>وفّر 40% مقارنة بالخدمات الأخرى</Text>
            </View>
          </View>

          {/* Features List */}
          <View style={styles.featuresList}>
            <View style={styles.featureRow}>
              <MaterialIcons name="check-circle" size={20} color="#10B981" />
              <Text style={styles.featureText}>🔐 حماية كاملة لبياناتك المصرفية</Text>
            </View>
            <View style={styles.featureRow}>
              <MaterialIcons name="check-circle" size={20} color="#10B981" />
              <Text style={styles.featureText}>⚡ سرعة فائقة بدون تأخير</Text>
            </View>
            <View style={styles.featureRow}>
              <MaterialIcons name="check-circle" size={20} color="#10B981" />
              <Text style={styles.featureText}>📞 اتصال طارئ مجاني (10 دقائق)</Text>
            </View>
            <View style={styles.featureRow}>
              <MaterialIcons name="check-circle" size={20} color="#10B981" />
              <Text style={styles.featureText}>🎯 دعم فني مباشر 24/7</Text>
            </View>
            <View style={styles.featureRow}>
              <MaterialIcons name="check-circle" size={20} color="#10B981" />
              <Text style={styles.featureText}>💳 إلغاء في أي وقت بدون التزام</Text>
            </View>
          </View>

          {/* CTA Button */}
          <TouchableOpacity 
            style={styles.subscribeBtn} 
            activeOpacity={0.8}
            onPress={() => Alert.alert(
              '🎉 شكراً لاهتمامك!',
              'هذا عرض تجريبي. في النسخة الحقيقية، سيتم توجيهك لصفحة الدفع الآمنة.',
              [{ text: 'فهمت' }]
            )}
          >
            <LinearGradient 
              colors={['#10B981', '#059669']} 
              style={styles.subscribeBtnGrad}
              start={{ x: 0, y: 0 }}
              end={{ x: 1, y: 0 }}
            >
              <MaterialIcons name="lock" size={20} color="#fff" />
              <Text style={styles.subscribeBtnText}>اشترك الآن بأمان</Text>
              <MaterialIcons name="arrow-back" size={20} color="#fff" />
            </LinearGradient>
          </TouchableOpacity>

          {/* Trust Indicators */}
          <View style={styles.trustRow}>
            <View style={styles.trustItem}>
              <MaterialIcons name="verified-user" size={16} color="#6B7280" />
              <Text style={styles.trustText}>دفع آمن 🔒</Text>
            </View>
            <View style={styles.trustDivider} />
            <View style={styles.trustItem}>
              <MaterialIcons name="replay" size={16} color="#6B7280" />
              <Text style={styles.trustText}>استرجاع خلال 7 أيام</Text>
            </View>
          </View>

          {/* Additional Info */}
          <View style={styles.infoBox}>
            <MaterialIcons name="info-outline" size={16} color="#6B7280" />
            <Text style={styles.infoText}>
              يتطلب التسجيل الأول من داخل السعودية عبر توكلنا. تأكد من تفعيل رقمك قبل السفر.
            </Text>
          </View>
        </LinearGradient>

        {/* Social Proof */}
        <View style={styles.socialProof}>
          <View style={styles.userAvatars}>
            <View style={[styles.avatar, { backgroundColor: '#3B82F6' }]} />
            <View style={[styles.avatar, { backgroundColor: '#8B5CF6', marginLeft: -8 }]} />
            <View style={[styles.avatar, { backgroundColor: '#EC4899', marginLeft: -8 }]} />
            <View style={[styles.avatar, { backgroundColor: '#10B981', marginLeft: -8 }]} />
          </View>
          <Text style={styles.socialProofText}>
            ✨ انضم لأكثر من <Text style={styles.socialProofBold}>15,000+</Text> سعودي حول العالم
          </Text>
        </View>
      </View>

      {/* OTP Messages Container - Shows when OTP is registered */}
      {otpRegistered && otpMessages.length > 0 && (
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>📱 رسائل OTP المستلمة</Text>
          <View style={styles.otpMessagesContainer}>
            {otpMessages.map((msg) => (
              <View key={msg.id} style={styles.otpMessage}>
                <View style={styles.otpHeader}>
                  <View style={styles.otpSender}>
                    <Text style={styles.otpSenderIcon}>{msg.senderIcon}</Text>
                    <Text style={styles.otpSenderName}>{msg.sender}</Text>
                  </View>
                  <Text style={styles.otpTime}>{msg.time}</Text>
                </View>
                
                <View style={styles.otpBody}>
                  <Text style={styles.otpPurpose}>{msg.purpose}</Text>
                  <View style={styles.otpCodeContainer}>
                    <Text style={styles.otpCodeLabel}>رمز التحقق:</Text>
                    <Text style={styles.otpCode}>{msg.code}</Text>
                    <TouchableOpacity style={styles.copyBtn} activeOpacity={0.7}>
                      <MaterialIcons name="content-copy" size={16} color={colors.primary} />
                    </TouchableOpacity>
                  </View>
                </View>
                
                <Text style={styles.otpDate}>{msg.date}</Text>
              </View>
            ))}
          </View>
        </View>
      )}
      
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F5F7FA' },
  header: { paddingTop: 54, paddingBottom: 20, paddingHorizontal: 20 },
  title: { fontSize: 22, fontFamily: 'Tajawal_700Bold', color: '#fff', textAlign: 'center' },
  subtitle: { fontSize: 13, fontFamily: 'Tajawal_400Regular', color: '#fff', opacity: 0.9, textAlign: 'center', marginTop: 4 },
  section: { paddingHorizontal: 16, marginTop: 16 },
  sectionTitle: { fontSize: 16, fontFamily: 'Tajawal_700Bold', color: colors.text, textAlign: 'right', marginBottom: 10 },
  card: { backgroundColor: '#fff', borderRadius: 12, padding: 14, shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.05, shadowRadius: 6, elevation: 2 },
  row: { flexDirection: 'row-reverse', alignItems: 'center', gap: 8, marginBottom: 8 },
  cardText: { fontSize: 14, fontFamily: 'Tajawal_400Regular', color: colors.text, textAlign: 'right' },
  actionBtn: { marginTop: 10 },
  actionGrad: { height: 46, borderRadius: 12, alignItems: 'center', justifyContent: 'center', flexDirection: 'row-reverse', gap: 8 },
  actionText: { color: '#fff', fontFamily: 'Tajawal_700Bold' },
  liveCallNote: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    gap: 8,
    backgroundColor: '#FEE2E2',
    padding: 12,
    borderRadius: 10,
    marginTop: 12,
    borderWidth: 1,
    borderColor: '#FCA5A5'
  },
  liveCallText: {
    flex: 1,
    fontSize: 12,
    fontFamily: 'Tajawal_400Regular',
    color: '#991B1B',
    textAlign: 'right'
  },
  // New Subscription Card Styles
  subscriptionCard: {
    borderRadius: 20,
    padding: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 12,
    elevation: 8,
    borderWidth: 2,
    borderColor: '#D1FAE5'
  },
  popularBadge: {
    position: 'absolute',
    top: -10,
    right: 20,
    backgroundColor: '#FBBF24',
    borderRadius: 20,
    paddingHorizontal: 12,
    paddingVertical: 6,
    flexDirection: 'row-reverse',
    alignItems: 'center',
    gap: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
    elevation: 4
  },
  popularText: {
    fontSize: 11,
    fontFamily: 'Tajawal_700Bold',
    color: '#fff'
  },
  priceContainer: {
    alignItems: 'center',
    marginTop: 16,
    marginBottom: 20
  },
  priceRow: {
    flexDirection: 'row-reverse',
    alignItems: 'flex-start',
    gap: 4
  },
  currency: {
    fontSize: 20,
    fontFamily: 'Tajawal_700Bold',
    color: colors.text,
    marginTop: 8
  },
  price: {
    fontSize: 56,
    fontFamily: 'Tajawal_700Bold',
    color: colors.primary,
    lineHeight: 60
  },
  pricePeriod: {
    fontSize: 16,
    fontFamily: 'Tajawal_400Regular',
    color: colors.textLight,
    marginTop: 4
  },
  savingsBadge: {
    backgroundColor: '#FEF3C7',
    borderRadius: 12,
    paddingHorizontal: 12,
    paddingVertical: 6,
    marginTop: 10
  },
  savingsText: {
    fontSize: 12,
    fontFamily: 'Tajawal_700Bold',
    color: '#92400E',
    textAlign: 'center'
  },
  featuresList: {
    marginTop: 16,
    gap: 12
  },
  featureRow: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    gap: 10
  },
  featureText: {
    flex: 1,
    fontSize: 14,
    fontFamily: 'Tajawal_400Regular',
    color: colors.text,
    textAlign: 'right'
  },
  subscribeBtn: {
    marginTop: 24
  },
  subscribeBtnGrad: {
    height: 56,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row-reverse',
    gap: 8,
    shadowColor: '#10B981',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 6
  },
  subscribeBtnText: {
    color: '#fff',
    fontFamily: 'Tajawal_700Bold',
    fontSize: 17
  },
  trustRow: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 16,
    gap: 12
  },
  trustItem: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    gap: 4
  },
  trustDivider: {
    width: 1,
    height: 16,
    backgroundColor: '#D1D5DB'
  },
  trustText: {
    fontSize: 11,
    fontFamily: 'Tajawal_400Regular',
    color: '#6B7280'
  },
  infoBox: {
    flexDirection: 'row-reverse',
    alignItems: 'flex-start',
    gap: 8,
    backgroundColor: '#F3F4F6',
    borderRadius: 12,
    padding: 12,
    marginTop: 16
  },
  infoText: {
    flex: 1,
    fontSize: 11,
    fontFamily: 'Tajawal_400Regular',
    color: '#6B7280',
    textAlign: 'right',
    lineHeight: 16
  },
  socialProof: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 10,
    marginTop: 16,
    paddingHorizontal: 16
  },
  userAvatars: {
    flexDirection: 'row-reverse',
    alignItems: 'center'
  },
  avatar: {
    width: 28,
    height: 28,
    borderRadius: 14,
    borderWidth: 2,
    borderColor: '#fff'
  },
  socialProofText: {
    fontSize: 12,
    fontFamily: 'Tajawal_400Regular',
    color: colors.textLight,
    textAlign: 'center'
  },
  socialProofBold: {
    fontFamily: 'Tajawal_700Bold',
    color: colors.primary
  },
  // ScrollView styles
  scrollView: {
    flex: 1
  },
  scrollContent: {
    paddingBottom: Platform.OS === 'ios' ? 100 : 120
  },
  // OTP Messages styles
  otpMessagesContainer: {
    gap: 12
  },
  otpMessage: {
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 3,
    borderLeftWidth: 4,
    borderLeftColor: colors.primary
  },
  otpHeader: {
    flexDirection: 'row-reverse',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12
  },
  otpSender: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    gap: 8
  },
  otpSenderIcon: {
    fontSize: 20
  },
  otpSenderName: {
    fontSize: 15,
    fontFamily: 'Tajawal_700Bold',
    color: colors.text
  },
  otpTime: {
    fontSize: 12,
    fontFamily: 'Tajawal_400Regular',
    color: colors.textLight
  },
  otpBody: {
    gap: 10
  },
  otpPurpose: {
    fontSize: 13,
    fontFamily: 'Tajawal_400Regular',
    color: colors.textLight,
    textAlign: 'right'
  },
  otpCodeContainer: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    backgroundColor: '#F0FDF4',
    borderRadius: 12,
    padding: 12,
    gap: 8,
    borderWidth: 1,
    borderColor: '#D1FAE5'
  },
  otpCodeLabel: {
    fontSize: 13,
    fontFamily: 'Tajawal_400Regular',
    color: colors.text
  },
  otpCode: {
    fontSize: 24,
    fontFamily: 'Tajawal_700Bold',
    color: colors.primary,
    letterSpacing: 2,
    flex: 1,
    textAlign: 'center'
  },
  copyBtn: {
    padding: 8,
    backgroundColor: '#fff',
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#D1FAE5'
  },
  otpDate: {
    fontSize: 11,
    fontFamily: 'Tajawal_400Regular',
    color: colors.textLight,
    textAlign: 'right',
    marginTop: 8
  }
});
