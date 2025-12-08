export interface Service {
  id: number;
  nameAr: string;
  nameEn?: string;
  status: 'نشط' | 'منتهية' | string;
  expiryDate: string;
  icon?: string;
}

export interface Notification {
  id: number;
  titleAr: string;
  messageAr: string;
  date: string;
}

export interface User {
  nationalId: string;
  name: string;
  nameEn?: string;
  birthDate: string;
  nationality: string;
  city: string;
  phone?: string;
  services: Service[];
  notifications: Notification[];
}

export type Role = 'user' | 'assistant' | 'system';

export interface CTAAction {
  id: string;
  label: string;
  action: string;
  variant: 'primary' | 'secondary';
}

export interface Message {
  id: number;
  role: Role;
  text: string;
  ctas?: CTAAction[];
}
