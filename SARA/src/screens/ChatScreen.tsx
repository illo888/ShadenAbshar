import React, { useState, useRef, useEffect, useMemo } from 'react';
import { View, Text, StyleSheet, FlatList, TextInput, TouchableOpacity, KeyboardAvoidingView, Platform, ActivityIndicator, ScrollView } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../constants/colors';
import { ChatBubble } from '../components/ChatBubble';
import { VoiceRecorder } from '../components/VoiceRecorder';
import { VoiceCallScreen } from './VoiceCallScreen';
import { sendMessageToGroq } from '../services/groqAPI';
import { convertTextToSpeech } from '../services/voiceTTS';
import { MaterialIcons } from '@expo/vector-icons';
import audioAdapter from '../services/audioAdapter';
import { CTAAction, Message } from '../types';
import { AIWave } from '../components/AIWave';
import { useUser } from '../context/UserContext';
import { buildAssistantContext } from '../constants/assistantProfiles';
import { useOtp } from '../context/OtpContext';
import { CTAIntent, executeSaimaltorAction } from '../services/saimaltorAPI';

const CTA_BLOCK_REGEX = /```cta[\s\S]*?```/i;

function extractAssistantPayload(raw: string): { text: string; ctas: CTAAction[] } {
  if (!raw || typeof raw !== 'string') {
    return { text: '', ctas: [] };
  }

  let working = raw;
  let ctas: CTAAction[] = [];

  const match = raw.match(/```cta([\s\S]*?)```/i);
  if (match) {
    let block = match[1]?.trim() ?? '';
    if (block) {
      block = block.replace(/^(json|JSON)/, '').trim();
      try {
        const parsed = JSON.parse(block);
        const parsedCtas = Array.isArray(parsed)
          ? parsed
          : Array.isArray(parsed?.ctas)
          ? parsed.ctas
          : [];

        if (Array.isArray(parsedCtas)) {
          const stamp = Date.now().toString(36);
          ctas = parsedCtas
            .map((cta: any, index) => {
              const label = typeof cta?.label === 'string' ? cta.label.trim() : '';
              const action = typeof cta?.action === 'string' ? cta.action.trim() : '';
              if (!label && !action) return null;
              return {
                id: `${stamp}-${index}`,
                label: label || action,
                action: action || label,
                variant: cta?.variant === 'primary' ? 'primary' : 'secondary'
              } as CTAAction;
            })
            .filter(Boolean) as CTAAction[];
        }
      } catch (err) {
        console.warn('Failed to parse CTA block from assistant response', err);
      }
    }
    working = working.replace(CTA_BLOCK_REGEX, '').trim();
  }

  return { text: working.trim(), ctas };
}

function hydrateCTAIntents(intents?: CTAIntent[]): CTAAction[] | undefined {
  if (!intents || intents.length === 0) return undefined;
  const stamp = Date.now().toString(36);
  return intents
    .map((intent, idx) => {
      if (!intent?.label || !intent?.action) return null;
      return {
        id: `${stamp}-svc-${idx}`,
        label: intent.label,
        action: intent.action,
        variant: intent.variant === 'primary' ? 'primary' : 'secondary'
      } as CTAAction;
    })
    .filter(Boolean) as CTAAction[];
}

export function ChatScreen() {
  const { userData } = useUser();
  const assistantProfile = useMemo(() => buildAssistantContext(userData), [userData]);
  const assistantContext = assistantProfile.context;
  const suggestions = assistantProfile.suggestions;
  const greeting = assistantProfile.greeting;
  const { enabled: otpEnabled, messages: otpMessages } = useOtp();

  const otpContext = useMemo(() => {
    if (!otpEnabled || otpMessages.length === 0) return '';
    const lines = otpMessages.slice(0, 5).map((msg, index) => {
      const label = index === 0 ? 'الأحدث' : `رمز ${index + 1}`;
      return `${label}: ${msg.code} من ${msg.sender} لغرض ${msg.purpose} (الوقت: ${msg.time})`;
    });
    return `سجل OTP الأخيرة:
${lines.join('\n')}

اذا طلب المستخدم رمز التحقق، أعطه الرقم الأحدث بالأرقام من غير تقسيم انجليزي واذكر الجهة والغرض باختصار.`;
  }, [otpEnabled, otpMessages]);

  const combinedContext = useMemo(() => {
    if (!otpContext) return assistantContext;
    return `${assistantContext}\n\n${otpContext}`;
  }, [assistantContext, otpContext]);

  const displaySuggestions = useMemo(() => {
    if (!otpEnabled) return suggestions;
    const otpPrompt = 'قولي وش آخر رمز تحقق وصلني';
    if (suggestions.includes(otpPrompt)) return suggestions;
    return [otpPrompt, ...suggestions];
  }, [suggestions, otpEnabled]);

  const [messages, setMessages] = useState<Message[]>([]);
  const [text, setText] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [ctaProcessing, setCtaProcessing] = useState<string | null>(null);
  const [waveState, setWaveState] = useState<'idle' | 'welcoming' | 'answering' | 'thinking' | 'listening'>('idle');
  const [showVoiceCall, setShowVoiceCall] = useState(false);
  const flatRef = useRef<any>(null);
  const soundRef = useRef<any>(null);
  const hasWelcomedRef = useRef(false);
  const lastOtpAnnouncedRef = useRef<number | null>(null);

  const latestAssistantMessage = useMemo(
    () => messages.find((msg) => msg.role === 'assistant'),
    [messages]
  );

  const canSpeak = Boolean(
    latestAssistantMessage && typeof latestAssistantMessage.text === 'string' && latestAssistantMessage.text.trim().length > 0
  );

  useEffect(() => {
    if (hasWelcomedRef.current) return;
    setWaveState('welcoming');
    const welcomeMsg: Message = {
      id: Date.now(),
      role: 'assistant',
      text: greeting || 'هلا! انا سارة، وش تحب ننجزه اليوم؟'
    };
    setMessages([welcomeMsg]);
    hasWelcomedRef.current = true;
    setTimeout(() => setWaveState('idle'), 3000);
  }, [greeting]);

  useEffect(() => {
    if (!otpEnabled || otpMessages.length === 0 || !hasWelcomedRef.current) {
      return;
    }

    const latest = otpMessages[0];
    if (!latest || lastOtpAnnouncedRef.current === latest.id) {
      return;
    }

    lastOtpAnnouncedRef.current = latest.id;
    const announcement: Message = {
      id: Date.now(),
      role: 'assistant',
      text: `📲 **رمز جديد من ${latest.sender}:** \`${latest.code}\`\nالغرض: ${latest.purpose}\nالوقت: ${latest.time}`
    };

    setMessages((prev) => [announcement, ...prev]);

    const spokenCode = latest.code.split('').join(' ');
    playTTS(`جاك رمز جديد من ${latest.sender}. الرقم هو ${spokenCode}.`);
  }, [otpEnabled, otpMessages]);

  async function handleUserMessage(rawText: string) {
    const content = rawText.trim();
    if (!content || isLoading) return;

    const userMsg: Message = { id: Date.now(), role: 'user', text: content };
    const historySource = [userMsg, ...messages]
      .filter((msg) => msg.role === 'user' || msg.role === 'assistant')
      .slice(0, 6)
      .reverse()
      .map((msg) => ({
        role: msg.role as 'user' | 'assistant',
        content: typeof msg.text === 'string' ? msg.text : JSON.stringify(msg.text)
      }));

    setMessages((m) => [userMsg, ...m]);
    setIsLoading(true);
    setWaveState('thinking');

    try {
      const reply = await sendMessageToGroq(content, {
        context: combinedContext,
        history: historySource
      });
      setWaveState('answering');
      const parsedReply = extractAssistantPayload(reply);
      const aiMsg: Message = {
        id: Date.now() + 1,
        role: 'assistant',
        text: parsedReply.text,
        ctas: parsedReply.ctas
      };
      setMessages((m) => [aiMsg, ...m]);

      setTimeout(() => setWaveState('idle'), 1500);
    } catch (error) {
      console.error('Error sending message:', error);
      setWaveState('idle');
      const errorMsg: Message = {
        id: Date.now() + 2,
        role: 'assistant',
        text: 'عذراً، حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.'
      };
      setMessages((m) => [errorMsg, ...m]);
    } finally {
      setIsLoading(false);
    }
  }

  async function sendText() {
    if (!text.trim() || isLoading) return;
    const currentText = text;
    setText('');
    await handleUserMessage(currentText);
  }

  function handleSuggestionPress(prompt: string) {
    if (isLoading) return;
    handleUserMessage(prompt);
  }

  async function handleCTAAction(action: string) {
    if (!action) return;

    if (action.startsWith('saimaltor:')) {
      if (ctaProcessing) return;
      setCtaProcessing(action);
      setWaveState('thinking');
      try {
        const result = await executeSaimaltorAction(action, { user: userData });
        setWaveState('answering');
        const serviceMsg: Message = {
          id: Date.now(),
          role: 'assistant',
          text: result.message,
          ctas: hydrateCTAIntents(result.ctas)
        };
        setMessages((m) => [serviceMsg, ...m]);
      } catch (error) {
        console.error('Saimaltor action failed', error);
        const failMsg: Message = {
          id: Date.now(),
          role: 'assistant',
          text: 'تعذر تنفيذ الخدمة في Saimaltor الحين، حاول بعد لحظات أو اطلب خدمة ثانية.'
        };
        setMessages((m) => [failMsg, ...m]);
      } finally {
        setCtaProcessing(null);
        setTimeout(() => setWaveState('idle'), 1000);
      }
      return;
    }

    if (isLoading) return;
    await handleUserMessage(action);
  }

  async function playTTS(textToPlay: string) {
    if (soundRef.current) {
      try {
        await audioAdapter.stopSound(soundRef.current);
      } catch (err) {
        console.warn('Failed to stop existing sound before TTS', err);
      } finally {
        soundRef.current = null;
      }
    }

    try {
      setWaveState('answering');
      const sound = await convertTextToSpeech(textToPlay);
      if (sound) {
        soundRef.current = sound;
        audioAdapter.setOnPlaybackStatusUpdate(sound, (status: any) => {
          if (status && status.didJustFinish) {
            soundRef.current = null;
            setWaveState('idle');
          }
        });
      } else {
        setWaveState('idle');
      }
    } catch (error) {
      console.error('TTS Error:', error);
      soundRef.current = null;
      setWaveState('idle');
    }
  }

  async function handleVoiceRecording(uri: string) {
    // For now, just show a message that voice was recorded
    // In production, you'd transcribe this with a speech-to-text API
    setWaveState('listening');
    const voiceMsg: Message = {
      id: Date.now(),
      role: 'user',
      text: '[تم إرسال رسالة صوتية]'
    };
    setMessages((m) => [voiceMsg, ...m]);
    
    setTimeout(() => setWaveState('idle'), 2000);
    const response: Message = {
      id: Date.now() + 1,
      role: 'assistant',
      text: 'عذراً، معالجة الرسائل الصوتية قيد التطوير. يرجى استخدام الرسائل النصية حالياً.'
    };
    setMessages((m) => [response, ...m]);
  }

  function startVoiceCall() {
    setShowVoiceCall(true);
  }

  async function speakLatestAssistantMessage() {
    if (!latestAssistantMessage) {
      return;
    }

    const textToSpeak =
      typeof latestAssistantMessage.text === 'string'
        ? latestAssistantMessage.text
        : JSON.stringify(latestAssistantMessage.text);

    await playTTS(textToSpeak);
  }

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      {/* Header */}
      <LinearGradient
        colors={['#0D7C66', '#0A6B58']}
        style={styles.header}
      >
        <View style={styles.headerContent}>
          <TouchableOpacity onPress={startVoiceCall} style={styles.callButton}>
            <MaterialIcons name="phone" size={24} color="#fff" />
          </TouchableOpacity>
          
          <View style={styles.headerCenter}>
            <View style={styles.headerWaveContainer}>
              <AIWave size={50} state={waveState} />
            </View>
            <Text style={styles.headerTitle}>سارا 🤖</Text>
            <Text style={styles.headerSubtitle}>مساعدتك الذكية</Text>
          </View>
          
          <View style={styles.callButton} />
        </View>
      </LinearGradient>

      {/* Messages Area */}
      <FlatList
        ref={flatRef}
        data={messages}
        inverted
        keyExtractor={(item) => String(item.id)}
        renderItem={({ item }) => (
          <ChatBubble 
            message={item}
            onCTAPress={item.role === 'assistant' ? handleCTAAction : undefined}
          />
        )}
        contentContainerStyle={styles.messageList}
        showsVerticalScrollIndicator={false}
        style={styles.messageArea}
      />

      {/* Typing Indicator */}
      {isLoading && (
        <View style={styles.loadingContainer}>
          <View style={styles.typingDots}>
            <View style={[styles.dot, styles.dot1]} />
            <View style={[styles.dot, styles.dot2]} />
            <View style={[styles.dot, styles.dot3]} />
          </View>
          <Text style={styles.loadingText}>سارا تكتب...</Text>
        </View>
      )}

      {/* Input Controls - ALWAYS VISIBLE */}
      <KeyboardAvoidingView 
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        keyboardVerticalOffset={Platform.OS === 'ios' ? 0 : 20}
      >
        <View style={styles.controlsWrapper}>
          <View style={styles.controls}>
            {displaySuggestions.length > 0 && (
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.suggestionList}
              >
                {displaySuggestions.map((prompt) => (
                  <TouchableOpacity
                    key={prompt}
                    onPress={() => handleSuggestionPress(prompt)}
                    style={styles.suggestionChip}
                    activeOpacity={0.75}
                    disabled={isLoading}
                  >
                    <Text style={styles.suggestionText}>{prompt}</Text>
                  </TouchableOpacity>
                ))}
              </ScrollView>
            )}
            <View style={styles.inputRow}>
              {/* Send Button */}
              <TouchableOpacity 
                onPress={sendText} 
                style={[styles.sendBtn, (!text.trim() || isLoading) && styles.sendBtnDisabled]}
                disabled={!text.trim() || isLoading}
                activeOpacity={0.7}
              >
                <LinearGradient
                  colors={text.trim() && !isLoading ? [colors.primary, colors.accent] : ['#ccc', '#aaa']}
                  style={styles.sendBtnGradient}
                >
                  {isLoading ? (
                    <ActivityIndicator size="small" color="#fff" />
                  ) : (
                    <MaterialIcons name="send" size={22} color="#fff" />
                  )}
                </LinearGradient>
              </TouchableOpacity>
              
              {/* Text Input */}
              <TextInput
                value={text}
                onChangeText={setText}
                placeholder="اكتب رسالتك هنا..."
                style={styles.input}
                placeholderTextColor={colors.textLight}
                multiline
                maxLength={500}
                returnKeyType="send"
                onSubmitEditing={sendText}
                editable={!isLoading}
              />
              
              {/* Voice Recorder */}
              <VoiceRecorder onFinished={handleVoiceRecording} />
              
              {/* Speak Latest Response */}
              <TouchableOpacity 
                onPress={speakLatestAssistantMessage} 
                style={styles.iconBtn}
                activeOpacity={canSpeak ? 0.7 : 1}
                disabled={!canSpeak}
              >
                <MaterialIcons 
                  name="volume-up" 
                  size={24} 
                  color={canSpeak ? colors.primary : colors.textLight} 
                />
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </KeyboardAvoidingView>

      {/* Voice Call Screen */}
      <VoiceCallScreen visible={showVoiceCall} onClose={() => setShowVoiceCall(false)} />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { 
    flex: 1, 
    backgroundColor: '#F5F7FA'
  },
  header: {
    paddingTop: 12,
    paddingBottom: 12,
    paddingHorizontal: 16
  },
  headerContent: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    justifyContent: 'space-between'
  },
  headerCenter: {
    flex: 1,
    alignItems: 'center'
  },
  callButton: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: 'rgba(255,255,255,0.2)',
    alignItems: 'center',
    justifyContent: 'center'
  },
  headerWaveContainer: {
    marginBottom: 6
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: '700',
    fontFamily: 'Tajawal_700Bold',
    color: '#fff',
    textAlign: 'center'
  },
  headerSubtitle: {
    fontSize: 11,
    fontFamily: 'Tajawal_400Regular',
    color: '#fff',
    opacity: 0.85,
    marginTop: 2,
    textAlign: 'center'
  },
  messageArea: {
    flex: 1,
    backgroundColor: '#FAFBFC'
  },
  messageList: {
    padding: 20,
    paddingBottom: 20
  },
  loadingContainer: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 12,
    paddingHorizontal: 20,
    backgroundColor: '#fff',
    marginHorizontal: 16,
    marginBottom: 8,
    borderRadius: 16,
    shadowColor: colors.primary,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 8,
    elevation: 3
  },
  typingDots: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginLeft: 8
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: colors.primary
  },
  dot1: {
    opacity: 0.4
  },
  dot2: {
    opacity: 0.7
  },
  dot3: {
    opacity: 1
  },
  loadingText: {
    fontSize: 14,
    fontFamily: 'Tajawal_700Bold',
    color: colors.primary,
    marginRight: 8
  },
  controlsWrapper: {
    backgroundColor: '#fff',
    borderTopWidth: 1,
    borderTopColor: '#E5E7EB',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: -4 },
    shadowOpacity: 0.1,
    shadowRadius: 12,
    elevation: 10,
    paddingBottom: Platform.OS === 'ios' ? 100 : 120
  },
  controls: {
    paddingHorizontal: 16,
    paddingVertical: 16,
    paddingBottom: 0
  },
  suggestionList: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    paddingBottom: 16
  },
  suggestionChip: {
    backgroundColor: '#EEF7F4',
    borderRadius: 20,
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderWidth: 1,
    borderColor: 'rgba(13, 124, 102, 0.2)',
    marginLeft: 10
  },
  suggestionText: {
    fontFamily: 'Tajawal_700Bold',
    color: colors.primary,
    fontSize: 14,
    textAlign: 'right'
  },
  inputRow: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    gap: 12
  },
  input: {
    flex: 1,
    backgroundColor: '#F9FAFB',
    borderRadius: 26,
    paddingVertical: 16,
    paddingHorizontal: 20,
    textAlign: 'right',
    fontFamily: 'Tajawal_400Regular',
    fontSize: 16,
    maxHeight: 120,
    minHeight: 52,
    borderWidth: 1.5,
    borderColor: '#E5E7EB',
    color: '#1F2937'
  },
  sendBtn: {
    width: 52,
    height: 52,
    borderRadius: 26,
    overflow: 'hidden',
    shadowColor: colors.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.35,
    shadowRadius: 8,
    elevation: 6
  },
  sendBtnDisabled: {
    opacity: 0.5,
    shadowOpacity: 0
  },
  sendBtnGradient: {
    width: '100%',
    height: '100%',
    alignItems: 'center',
    justifyContent: 'center'
  },
  iconBtn: {
    width: 52,
    height: 52,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 26,
    backgroundColor: '#F9FAFB',
    borderWidth: 1.5,
    borderColor: '#E5E7EB'
  }
});
