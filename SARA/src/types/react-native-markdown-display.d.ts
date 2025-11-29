declare module 'react-native-markdown-display' {
  import * as React from 'react';
  import { StyleProp, TextStyle } from 'react-native';

  interface MarkdownProps {
    children: React.ReactNode;
    style?: { [key: string]: StyleProp<TextStyle> } | StyleProp<TextStyle>;
  }

  export default class Markdown extends React.Component<MarkdownProps> {}
}
