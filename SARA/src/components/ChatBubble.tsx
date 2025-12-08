import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialIcons } from '@expo/vector-icons';
import { colors } from '../constants/colors';
import { Message } from '../types';
import { MarkdownText } from './MarkdownText';

interface ChatBubbleProps {
  message: Message;
  onPlay?: () => void;
  isPlaying?: boolean;
  onCTAPress?: (action: string) => void;
}

export const ChatBubble = ({ message, onPlay, isPlaying = false, onCTAPress }: ChatBubbleProps) => {
  const isUser = message.role === 'user';
  const content = typeof message.text === 'string' ? message.text : JSON.stringify(message.text);
  return (
    <View style={[styles.wrapper, isUser ? styles.userWrapper : styles.aiWrapper]}>
      {isUser ? (
        <LinearGradient
          colors={[colors.primary, '#0A6B58']}
          style={[styles.container, styles.userBubble]}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
        >
          <MarkdownText content={content} variant="user" />
        </LinearGradient>
      ) : (
        <View style={[styles.container, styles.aiBubble]}>
          <View style={styles.aiHeader}>
            <View style={styles.aiAvatar}>
              <MaterialIcons name="smart-toy" size={16} color={colors.primary} />
            </View>
            <Text style={styles.aiName}>سارا</Text>
          </View>
          <MarkdownText content={content} variant="assistant" />
          {message.ctas && message.ctas.length > 0 && (
            <View style={styles.ctaRow}>
              {message.ctas.map((cta) => (
                <TouchableOpacity
                  key={cta.id}
                  style={[styles.ctaButton, cta.variant === 'primary' ? styles.ctaPrimary : styles.ctaSecondary]}
                  activeOpacity={0.8}
                  onPress={() => onCTAPress && onCTAPress(cta.action)}
                >
                  <Text style={[styles.ctaLabel, cta.variant === 'primary' ? styles.ctaLabelPrimary : styles.ctaLabelSecondary]}>
                    {cta.label}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>
          )}
          {onPlay && (
            <TouchableOpacity 
              style={styles.playBtn} 
              onPress={onPlay}
              activeOpacity={0.7}
            >
              <MaterialIcons 
                name={isPlaying ? 'pause-circle' : 'play-circle'} 
                size={24} 
                color={colors.primary} 
              />
            </TouchableOpacity>
          )}
        </View>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  wrapper: {
    marginVertical: 8,
    maxWidth: '85%'
  },
  userWrapper: {
    alignSelf: 'flex-start'
  },
  aiWrapper: {
    alignSelf: 'flex-end'
  },
  container: {
    padding: 16,
    borderRadius: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.12,
    shadowRadius: 8,
    elevation: 4
  },
  userBubble: {
    borderBottomLeftRadius: 6
  },
  aiBubble: {
    backgroundColor: '#FFFFFF',
    borderBottomRightRadius: 6,
    borderWidth: 1,
    borderColor: '#F0F0F0'
  },
  aiHeader: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    marginBottom: 10
  },
  aiAvatar: {
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: '#E8F8F3',
    alignItems: 'center',
    justifyContent: 'center',
    marginLeft: 8
  },
  aiName: {
    fontSize: 13,
    fontWeight: '700',
    fontFamily: 'Tajawal_700Bold',
    color: colors.primary
  },
  playBtn: {
    marginTop: 12,
    alignSelf: 'flex-start',
    padding: 4
  },
  ctaRow: {
    flexDirection: 'row-reverse',
    flexWrap: 'wrap',
    marginTop: 12,
    marginHorizontal: -4
  },
  ctaButton: {
    borderRadius: 18,
    paddingVertical: 10,
    paddingHorizontal: 18,
    minWidth: 120,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1.5,
    marginHorizontal: 4,
    marginBottom: 8
  },
  ctaPrimary: {
    backgroundColor: '#0D7C66',
    borderColor: '#0D7C66'
  },
  ctaSecondary: {
    backgroundColor: '#EEF7F4',
    borderColor: 'rgba(13,124,102,0.25)'
  },
  ctaLabel: {
    fontFamily: 'Tajawal_700Bold',
    fontSize: 14
  },
  ctaLabelPrimary: {
    color: '#FFFFFF'
  },
  ctaLabelSecondary: {
    color: colors.primary
  }
});
