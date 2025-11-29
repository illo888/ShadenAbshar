import React, { createContext, useContext, useState, ReactNode } from 'react';
import { ScenarioType } from '../utils/saudiId';

export interface UserData {
  saudiId: string;
  scenario: ScenarioType;
  name: string;
  city: string;
  phone: string;
}

interface UserContextType {
  userData: UserData | null;
  setUserData: (data: UserData) => void;
  clearUserData: () => void;
}

const UserContext = createContext<UserContextType | undefined>(undefined);

export function UserProvider({ children }: { children: ReactNode }) {
  const [userData, setUserData] = useState<UserData | null>(null);

  const clearUserData = () => setUserData(null);

  return (
    <UserContext.Provider value={{ userData, setUserData, clearUserData }}>
      {children}
    </UserContext.Provider>
  );
}

export function useUser() {
  const context = useContext(UserContext);
  if (!context) {
    throw new Error('useUser must be used within UserProvider');
  }
  return context;
}

// Generate mock data based on scenario
export function generateUserFromScenario(saudiId: string, scenario: ScenarioType): UserData {
  const scenarioNames = {
    safe_gate: 'أحمد المغترب',
    in_saudi: 'محمد السعيد',
    elder: 'عبدالله الكبير',
    guest: 'زائر مساعد'
  };

  const scenarioCities = {
    safe_gate: 'لندن، المملكة المتحدة',
    in_saudi: 'الرياض',
    elder: 'جدة',
    guest: 'غير محدد'
  };

  const scenarioPhones = {
    safe_gate: '+44 7700 900123',
    in_saudi: '+966 50 123 4567',
    elder: '+966 50 987 6543',
    guest: 'غير متاح'
  };

  return {
    saudiId,
    scenario,
    name: scenarioNames[scenario],
    city: scenarioCities[scenario],
    phone: scenarioPhones[scenario]
  };
}
