// audioAdapter.ts
// This adapter prefers `expo-audio` if available; otherwise falls back to `expo-av`.
// Exposes a small subset of the Audio API used by the SARA app: Sound helpers and Recording helpers.

// We use dynamic require() style to avoid static bundling errors if a package does not exist.

let AudioImpl: any = null;
let RecordingAudioImpl: any = null;

try {
  // Prefer the new package for playback if available
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  AudioImpl = require('expo-audio');
} catch (err) {
  // Ignore; we'll try expo-av below
}

try {
  // Always attempt to load expo-av to ensure recording support
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  const expoAV = require('expo-av');
  const resolvedAV = expoAV?.Audio || expoAV || null;

  RecordingAudioImpl = resolvedAV;

  if (!AudioImpl) {
    AudioImpl = resolvedAV;
  }
} catch (err) {
  if (!AudioImpl) {
    console.warn('audioAdapter: no audio implementation found; ensure expo-audio or expo-av is installed.');
    AudioImpl = null;
  }
}

export const Audio = AudioImpl?.Audio || AudioImpl || RecordingAudioImpl || null;

function getRecordingAPI() {
  return RecordingAudioImpl || Audio;
}

function buildFallbackRecordingOptions() {
  return {
    isMeteringEnabled: true,
    android: {
      extension: '.m4a',
      outputFormat: 2, // MPEG_4
      audioEncoder: 3, // AAC
      sampleRate: 44100,
      numberOfChannels: 2,
      bitRate: 128000
    },
    ios: {
      extension: '.m4a',
      audioQuality: 127,
      outputFormat: 'mpeg4aac',
      sampleRate: 44100,
      numberOfChannels: 2,
      bitRate: 128000,
      linearPCMBitDepth: 16,
      linearPCMIsBigEndian: false,
      linearPCMIsFloat: false
    }
  };
}

export function getRecordingOptions() {
  const RecordingAPI = getRecordingAPI();
  if (!RecordingAPI) return buildFallbackRecordingOptions();

  const presets =
    RecordingAPI?.RecordingOptionsPresets || RecordingAPI?.Audio?.RecordingOptionsPresets;

  if (presets?.HIGH_QUALITY) {
    return {
      ...presets.HIGH_QUALITY,
      isMeteringEnabled: true
    };
  }

  return buildFallbackRecordingOptions();
}

// Small helper to create an Audio.Sound from a base64 audio (mp3/wav) string
export async function createSoundFromBase64(base64: string, format: string = 'mp3') {
  if (!Audio) throw new Error('Audio module not available');
  
  // For expo-audio (new API)
  if (AudioImpl && !AudioImpl.Audio) {
    try {
      const uri = `data:audio/${format};base64,${base64}`;
      const player = await AudioImpl.createAudioPlayer({ uri });
      return player;
    } catch (err) {
      console.error('expo-audio createAudioPlayer error:', err);
      throw err;
    }
  }
  
  // For expo-av (legacy API)
  if (Audio && Audio.Sound) {
    const uri = `data:audio/${format};base64,${base64}`;
    const result = await Audio.Sound.createAsync({ uri } as any);
    return result?.sound;
  }
  
  throw new Error('No audio implementation available');
}

export async function playSound(sound: any) {
  if (!sound) return;
  try {
    // expo-audio uses .play(), expo-av uses .playAsync()
    if (sound.play && typeof sound.play === 'function') {
      await sound.play();
    } else if (sound.playAsync && typeof sound.playAsync === 'function') {
      await sound.playAsync();
    }
  } catch (err) {
    console.warn('audioAdapter.playSound error', err);
  }
}

export async function stopSound(sound: any) {
  if (!sound) return;
  try {
    // expo-audio uses .pause() + .remove(), expo-av uses .stopAsync()
    if (sound.pause && typeof sound.pause === 'function') {
      await sound.pause();
      if (sound.remove && typeof sound.remove === 'function') {
        await sound.remove();
      }
    } else if (sound.stopAsync && typeof sound.stopAsync === 'function') {
      await sound.stopAsync();
    }
  } catch (err) {
    console.warn('audioAdapter.stopSound error', err);
  }
}

export function setOnPlaybackStatusUpdate(sound: any, handler: (status: any) => void) {
  if (!sound) return;
  try {
    sound.setOnPlaybackStatusUpdate(handler);
  } catch (err) {
    // Some builds might not export setOnPlaybackStatusUpdate; fallback noop
  }
}

// Recording utilities
export async function requestRecordingPermissions() {
  const RecordingAPI = getRecordingAPI();
  if (!RecordingAPI) return { status: 'denied' };
  try {
    // audio permission call differs between modules. For backwards compat we attempt both.
    if (RecordingAPI.requestPermissionsAsync) {
      return await RecordingAPI.requestPermissionsAsync();
    }

    if (RecordingAPI.getPermissionsAsync) {
      return await RecordingAPI.getPermissionsAsync();
    }

    // Some audio modules expose a different permission flow, return granted for demo
    return { status: 'granted' };
  } catch (err) {
    console.warn('audioAdapter.requestRecordingPermissions error', err);
    return { status: 'denied' };
  }
}

export async function setAudioModeAsync(opts: any) {
  const RecordingAPI = getRecordingAPI();
  if (!RecordingAPI) return;
  try {
    if (RecordingAPI.setAudioModeAsync) {
      await RecordingAPI.setAudioModeAsync(opts);
    }
  } catch (err) {
    console.warn('audioAdapter.setAudioModeAsync error', err);
  }
}

export function createRecording() {
  const RecordingAPI = getRecordingAPI();
  if (!RecordingAPI) throw new Error('Audio module not available');
  // return a new Recording instance
  try {
    if (RecordingAPI.Recording) {
      return new RecordingAPI.Recording();
    }

    if (RecordingAPI?.Audio?.Recording) {
      return new RecordingAPI.Audio.Recording();
    }

    if (AudioImpl && AudioImpl.Recording) {
      return new AudioImpl.Recording();
    }

    throw new Error('Recording class not found in audio implementation');
  } catch (err) {
    console.warn('audioAdapter.createRecording failed', err);
    throw new Error('Failed to create recording');
  }
}

export default {
  Audio,
  createSoundFromBase64,
  playSound,
  stopSound,
  setOnPlaybackStatusUpdate,
  requestRecordingPermissions,
  setAudioModeAsync,
  createRecording,
  getRecordingOptions
};