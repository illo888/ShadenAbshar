import React, { createContext, useContext, useState, useCallback, ReactNode } from 'react';

export interface OtpMessage {
  id: number;
  sender: string;
  senderIcon: string;
  code: string;
  purpose: string;
  time: string;
  date: string;
}

type AddMessageInput = Omit<OtpMessage, 'id'> & { id?: number };

interface OtpContextValue {
  enabled: boolean;
  messages: OtpMessage[];
  registerOtp: () => void;
  addOtpMessage: (message: AddMessageInput) => void;
  resetOtp: () => void;
}

const OtpContext = createContext<OtpContextValue | undefined>(undefined);

export function OtpProvider({ children }: { children: ReactNode }) {
  const [enabled, setEnabled] = useState(false);
  const [messages, setMessages] = useState<OtpMessage[]>([]);

  const registerOtp = useCallback(() => {
    setEnabled(true);
  }, []);

  const addOtpMessage = useCallback((message: AddMessageInput) => {
    const fullMessage: OtpMessage = {
      id: message.id ?? Date.now(),
      sender: message.sender,
      senderIcon: message.senderIcon,
      code: message.code,
      purpose: message.purpose,
      time: message.time,
      date: message.date
    };

    setMessages((prev) => [fullMessage, ...prev].slice(0, 10));
  }, []);

  const resetOtp = useCallback(() => {
    setEnabled(false);
    setMessages([]);
  }, []);

  return (
    <OtpContext.Provider value={{ enabled, messages, registerOtp, addOtpMessage, resetOtp }}>
      {children}
    </OtpContext.Provider>
  );
}

export function useOtp() {
  const context = useContext(OtpContext);
  if (!context) {
    throw new Error('useOtp must be used within an OtpProvider');
  }
  return context;
}
