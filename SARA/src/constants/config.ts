import Constants from 'expo-constants';

// Preferred: set via app.config.js or expo app extras, otherwise fallback to process.env
export const GROQ_API_KEY =
  (Constants?.manifest as any)?.extra?.GROQ_API_KEY || process.env.GROQ_API_KEY ||
  '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';

export const GROQ_BASE_URL = 'https://api.groq.com/openai/v1';
export const GROQ_CHAT_MODEL = (Constants?.manifest as any)?.extra?.GROQ_CHAT_MODEL || process.env.GROQ_CHAT_MODEL || 'groq/compound-mini';

export default {
  GROQ_API_KEY,
  GROQ_BASE_URL
  ,GROQ_CHAT_MODEL
};
