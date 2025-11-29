import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialIcons } from '@expo/vector-icons';
import { colors } from '../constants/colors';
import { Message } from '../types';
import { MarkdownText } from './MarkdownText';

export const ChatBubble = ({ message, onPlay, isPlaying = false }: { message: Message; onPlay?: () => void; isPlaying?: boolean }) => {
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
  }
});
