# 📱 SARA Voice Calling - Quick Start Guide

## 🎯 How to Use Voice Calling

### Starting a Call

1. **Open Chat Screen**
   - Navigate to the chat tab in the bottom navigation

2. **Tap the Phone Icon**
   - Located in the top-right corner of the header
   - Icon: 📞 Phone symbol

3. **Call Screen Opens**
   - Full-screen modal with gradient background
   - AIWave animation in the center
   - Control buttons at the bottom

---

## 🎤 During the Call

### Automatic Mode (Default)
```
1. Sara greets you: "مرحباً! أنا سارا..."
2. Recording starts automatically
3. Speak for up to 10 seconds
4. Recording stops automatically
5. Your speech is transcribed
6. Sara responds with voice
7. Loop continues
```

### Manual Mode (Push-to-Talk)
```
1. If recording doesn't auto-start
2. Tap "اضغط للتحدث" button
3. Speak your message
4. Recording stops after 10 seconds
5. Sara processes and responds
```

---

## 🎛️ Call Controls

### Bottom Control Bar
```
┌────────────────────────────────┐
│  [🎤]      [☎️]      [🔊]      │
│  Mute     End Call   Speaker   │
└────────────────────────────────┘
```

### Mute Button (Left)
- **Tap to mute** your microphone
- Icon changes: 🎤 → 🎤🚫
- Recording stops when muted
- Tap again to unmute

### End Call Button (Center)
- **Tap to end** the voice call
- Red gradient button
- Cleans up resources
- Returns to chat screen

### Speaker Button (Right)
- **Tap to toggle** speaker mode
- Icon changes: 🔊 → 🔇
- Controls audio output
- On by default

---

## 📊 Call States Visualization

### State Colors (AIWave)

```
🟢 GREEN (Welcoming/Answering)
   - Sara is greeting you
   - Sara is speaking a response
   - Smooth, calm animation

🔴 RED (Thinking/Processing)
   - Transcribing your speech
   - Generating AI response
   - Fast, intense animation

🟡 AMBER (Listening)
   - Recording your voice
   - Microphone is active
   - Medium-speed animation

🔵 BLUE (Connecting)
   - Initial connection
   - Call is starting
   - Slow, steady animation
```

---

## 💬 Transcript Display

### Live Transcript
```
┌──────────────────────────────┐
│  أنت: كيف حالك؟              │
│  سارا: بخير، شكراً لك        │
│  أنت: ما الطقس اليوم؟        │
└──────────────────────────────┘
```

- Shows last 3 messages
- Scrolls automatically
- "أنت:" = You
- "سارا:" = Sara

---

## ⏱️ Call Duration

### Timer Display
```
┌─────────────┐
│   00:42     │  ← Minutes:Seconds
└─────────────┘
```

- Starts when call connects
- Updates every second
- Displayed at the top

---

## 🎨 Visual Feedback

### What You'll See

#### 1. Call Status Text
```
"جاري الاتصال..."     - Connecting
"أستمع إليك..."       - Listening (recording)
"جاري المعالجة..."    - Processing
"سارا تتحدث..."       - Speaking
"انتهت المكالمة"      - Call ended
```

#### 2. AIWave Animation
- **Size**: 240px (larger than chat)
- **Pulsing**: Scales 1.0 → 1.2 during active states
- **Color**: Changes based on conversation state
- **Speed**: Varies by activity level

#### 3. Gradient Background
```
Top:    #0D7C66 (Dark Teal)
Middle: #41B8A7 (Teal)
Bottom: #BDE8CA (Light Mint)
```

---

## 🔊 Audio Settings

### Recording Parameters
- **Duration**: 10 seconds max per turn
- **Format**: M4A (AAC encoding)
- **Sample Rate**: 44100 Hz
- **Channels**: Stereo (2)
- **Quality**: High (128 kbps)

### Playback
- **Auto-play**: Enabled by default
- **Speaker**: On by default
- **Volume**: System volume control

---

## 🚨 Troubleshooting

### "Permission not granted"
**Solution**: 
1. Go to Settings
2. Find SARA app
3. Enable Microphone permission
4. Restart the app

### "No audio recorded"
**Solution**:
1. Ensure you're speaking during recording
2. Check if mute is OFF
3. Wait for "أستمع إليك..." status
4. Try manual push-to-talk button

### "Recording failed"
**Solution**:
1. Close other apps using microphone
2. Check microphone isn't blocked
3. Restart the app
4. Check iOS/Android permissions

### "Transcription failed"
**Solution**:
1. Speak clearly and at normal pace
2. Reduce background noise
3. Check internet connection
4. Try shorter utterances (5-8 seconds)

### "Response is slow"
**Explanation**:
- Normal latency: 5-10 seconds
- Includes: transcription (1-3s) + AI (2-5s) + TTS (1-2s)
- Dependent on internet speed
- Wait for Sara's response

---

## 💡 Pro Tips

### For Best Results

1. **Speak Clearly**
   - Normal conversational pace
   - Avoid mumbling or talking too fast
   - Reduce background noise

2. **Keep Messages Short**
   - 5-8 seconds ideal
   - One question at a time
   - Wait for response before next question

3. **Good Environment**
   - Quiet room preferred
   - Good internet connection
   - Phone not in silent mode

4. **Natural Conversation**
   - Speak as you would to a person
   - Use complete sentences
   - Arabic language works best

---

## 🎯 Example Conversations

### Example 1: Service Inquiry
```
You:  "كيف يمكنني تجديد رخصة القيادة؟"
Sara: "لتجديد رخصة القيادة، يمكنك استخدام تطبيق أبشر..."
You:  "كم تستغرق المدة؟"
Sara: "عادة تستغرق العملية من يومين إلى ثلاثة أيام..."
```

### Example 2: General Help
```
You:  "ما هي الخدمات المتاحة؟"
Sara: "نحن نقدم خدمات متنوعة مثل..."
You:  "شكراً لك"
Sara: "على الرحب والسعة! هل تحتاج مساعدة أخرى؟"
```

---

## 📱 Interface Overview

```
┌──────────────────────────────────┐
│    جاري الاتصال...  00:00       │ ← Status & Timer
├──────────────────────────────────┤
│                                  │
│                                  │
│         [AIWave Animation]       │ ← 240px animated
│           (Color State)          │
│                                  │
│                                  │
├──────────────────────────────────┤
│            سارا                  │ ← AI Name
│         المساعد الذكي            │
├──────────────────────────────────┤
│  ┌─────────────────────────┐   │
│  │ أنت: مرحباً              │   │ ← Transcript
│  │ سارا: أهلاً بك          │   │   (Last 3)
│  └─────────────────────────┘   │
├──────────────────────────────────┤
│                                  │
│  [🎤]      [☎️]      [🔊]        │ ← Controls
│  Mute     End Call   Speaker     │
│                                  │
│      [اضغط للتحدث]              │ ← Manual trigger
└──────────────────────────────────┘
```

---

## ⚡ Quick Actions

### Start Call
**ChatScreen → Phone Icon (top-right)**

### End Call
**Red button in center of controls**

### Mute/Unmute
**Left button in controls**

### Toggle Speaker
**Right button in controls**

### Manual Talk
**"اضغط للتحدث" button (when visible)**

---

## 🎓 Technical Details

### APIs Used
- **Groq Whisper**: Speech-to-text (Arabic)
- **Groq LLaMA 3.3**: AI responses
- **PlayAI TTS**: Text-to-speech (Arabic, Amira voice)

### Models
- `whisper-large-v3` for transcription
- `llama-3.3-70b-versatile` for AI
- `playai-tts-arabic` for voice synthesis

### Latency Breakdown
```
Recording:      10 seconds
Transcription:  1-3 seconds
AI Generation:  2-5 seconds
TTS Generation: 1-2 seconds
─────────────────────────────
Total:          ~5-10 seconds per turn
```

---

## 🔒 Privacy & Security

### What We Record
- ✅ Voice during call only
- ✅ Transcripts (temporary)
- ✅ AI responses

### What We Don't Record
- ❌ Calls are not saved permanently
- ❌ No background recording
- ❌ No sharing with third parties

### Permissions Required
- 🎤 Microphone access (essential)
- 🔊 Audio playback (auto-granted)

---

## ✅ Ready to Use!

Your voice calling feature is **fully implemented** and ready for testing.

**Just tap the phone icon** in the chat header to start your first voice call with Sara! 📞

---

**Questions?** Check `VOICE_CALLING_DOCS.md` for detailed technical documentation.
