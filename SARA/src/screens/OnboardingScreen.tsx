import React, { useState } from 'react';
import { View, Text, StyleSheet, TextInput, TouchableOpacity, ActivityIndicator } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../constants/colors';
import { MaterialIcons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import { determineScenario, validateSaudiId } from '../utils/saudiId';
import { nafathVerifyMock } from '../services/mockBackend';
import { useUser, generateUserFromScenario } from '../context/UserContext';

export type ScenarioType = 'safe_gate' | 'in_saudi' | 'elder' | 'guest';

export function OnboardingScreen() {
  const nav = useNavigation();
  const { setUserData } = useUser();
  const [id, setId] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function continueFlow() {
    setError(null);
    if (!validateSaudiId(id)) {
      setError('الهوية الوطنية غير صحيحة. يجب أن تكون 10 أرقام وتبدأ بـ 1');
      return;
    }
    setIsLoading(true);

    // Simulate Nafath login (3-4 seconds)
    await nafathVerifyMock(id);

    const scenario: ScenarioType = determineScenario(id);
    
    // Generate and save user data based on scenario
    const userData = generateUserFromScenario(id, scenario);
    setUserData(userData);
    
    // Route by scenario - AI first means Chat for most scenarios
    switch (scenario) {
      case 'safe_gate':
        nav.navigate('SafeGate' as never);
        break;
      case 'elder':
        nav.navigate('ElderMode' as never);
        break;
      case 'guest':
        nav.navigate('GuestHelp' as never);
        break;
      case 'in_saudi':
      default:
        // Default to Chat (AI-first)
        nav.navigate('Chat' as never);
        break;
    }
    setIsLoading(false);
  }

  return (
    <View style={styles.container}>
      <LinearGradient colors={[colors.primary, '#0A6B58']} style={styles.header}>
        <Text style={styles.title}>مرحبا بك في سارة</Text>
        <Text style={styles.subtitle}>المساعدة الذكية للخدمات الحكومية السعودية</Text>
      </LinearGradient>

      <View style={styles.form}>
        <Text style={styles.label}>رقم الهوية الوطنية (10 أرقام)</Text>
        <View style={styles.inputRow}>
          <MaterialIcons name="badge" size={20} color={colors.textLight} />
          <TextInput
            value={id}
            onChangeText={setId}
            keyboardType="number-pad"
            maxLength={10}
            placeholder="1XXXXXXXXX"
            style={styles.input}
            textAlign="right"
          />
        </View>

        {error && <Text style={styles.error}>{error}</Text>}

        <TouchableOpacity onPress={continueFlow} activeOpacity={0.8} style={styles.cta} disabled={isLoading}>
          <LinearGradient colors={[colors.primary, colors.accent]} style={styles.ctaGradient}>
            {isLoading ? (
              <ActivityIndicator color="#fff" />
            ) : (
              <>
                <MaterialIcons name="login" size={20} color="#fff" />
                <Text style={styles.ctaText}>متابعة عبر نفاذ</Text>
              </>
            )}
          </LinearGradient>
        </TouchableOpacity>

        {/* Demo IDs for quick testing */}
        <View style={styles.demoSection}>
          <Text style={styles.demoTitle}>معرفات تجريبية للاختبار</Text>
          
          <View style={styles.demoGrid}>
            <TouchableOpacity 
              style={styles.demoCard} 
              onPress={() => setId('1000000000')}
              activeOpacity={0.7}
            >
              <MaterialIcons name="vpn-lock" size={20} color={colors.primary} />
              <Text style={styles.demoLabel}>البوابة الآمنة</Text>
              <Text style={styles.demoId}>1000000000</Text>
            </TouchableOpacity>

            <TouchableOpacity 
              style={styles.demoCard} 
              onPress={() => setId('1000000005')}
              activeOpacity={0.7}
            >
              <MaterialIcons name="smart-toy" size={20} color={colors.primary} />
              <Text style={styles.demoLabel}>محادثة سارا</Text>
              <Text style={styles.demoId}>1000000005</Text>
            </TouchableOpacity>

            <TouchableOpacity 
              style={styles.demoCard} 
              onPress={() => setId('1000000007')}
              activeOpacity={0.7}
            >
              <MaterialIcons name="elderly" size={20} color={colors.primary} />
              <Text style={styles.demoLabel}>وضع كبار السن</Text>
              <Text style={styles.demoId}>1000000007</Text>
            </TouchableOpacity>

            <TouchableOpacity 
              style={styles.demoCard} 
              onPress={() => setId('1000000009')}
              activeOpacity={0.7}
            >
              <MaterialIcons name="help-outline" size={20} color={colors.primary} />
              <Text style={styles.demoLabel}>مساعدة ضيف</Text>
              <Text style={styles.demoId}>1000000009</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.scenarioInfo}>
            <MaterialIcons name="info-outline" size={16} color={colors.textLight} />
            <Text style={styles.scenarioText}>
              آخر رقم: 0-2 (بوابة آمنة) • 3-6 (محادثة) • 7-8 (كبار سن) • 9 (ضيف)
            </Text>
          </View>
        </View>

        <TouchableOpacity onPress={() => nav.navigate('GuestHelp' as never)} style={styles.link}>
          <Text style={styles.linkText}>لا أملك وصول — أحتاج مساعدة</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F5F7FA' },
  header: { paddingTop: 60, paddingBottom: 24, paddingHorizontal: 20 },
  title: { fontSize: 22, fontFamily: 'Tajawal_700Bold', color: '#fff', textAlign: 'center' },
  subtitle: { fontSize: 13, fontFamily: 'Tajawal_400Regular', color: '#fff', opacity: 0.9, textAlign: 'center', marginTop: 4 },
  form: { paddingHorizontal: 16, paddingTop: 18 },
  label: { fontSize: 13, color: colors.textLight, textAlign: 'right', fontFamily: 'Tajawal_400Regular' },
  inputRow: { flexDirection: 'row-reverse', alignItems: 'center', backgroundColor: '#fff', borderRadius: 12, paddingHorizontal: 12, height: 48, marginTop: 6 },
  input: { flex: 1, fontSize: 15, fontFamily: 'Tajawal_400Regular', color: colors.text },
  error: { color: '#EF4444', fontFamily: 'Tajawal_700Bold', textAlign: 'right', marginTop: 10 },
  cta: { marginTop: 18 },
  ctaGradient: { height: 48, borderRadius: 12, alignItems: 'center', justifyContent: 'center', flexDirection: 'row-reverse', gap: 8 },
  ctaText: { color: '#fff', fontFamily: 'Tajawal_700Bold' },
  demoSection: {
    marginTop: 24,
    padding: 16,
    backgroundColor: '#fff',
    borderRadius: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 8,
    elevation: 2
  },
  demoTitle: {
    fontSize: 14,
    fontFamily: 'Tajawal_700Bold',
    color: colors.text,
    textAlign: 'center',
    marginBottom: 12
  },
  demoGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    gap: 8
  },
  demoCard: {
    width: '48%',
    backgroundColor: '#F9FAFB',
    borderRadius: 12,
    padding: 12,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#E5E7EB'
  },
  demoLabel: {
    fontSize: 11,
    fontFamily: 'Tajawal_700Bold',
    color: colors.text,
    textAlign: 'center',
    marginTop: 6
  },
  demoId: {
    fontSize: 13,
    fontFamily: 'Tajawal_400Regular',
    color: colors.primary,
    textAlign: 'center',
    marginTop: 4
  },
  scenarioInfo: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
    marginTop: 12,
    paddingTop: 12,
    borderTopWidth: 1,
    borderTopColor: '#E5E7EB'
  },
  scenarioText: {
    fontSize: 10,
    fontFamily: 'Tajawal_400Regular',
    color: colors.textLight,
    textAlign: 'center'
  },
  link: { marginTop: 16, alignItems: 'center' },
  linkText: { color: colors.primary, fontFamily: 'Tajawal_700Bold' }
});
