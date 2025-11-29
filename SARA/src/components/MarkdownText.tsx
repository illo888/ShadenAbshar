import React, { useMemo } from 'react';
import { View, Text, StyleSheet } from 'react-native';

type Variant = 'user' | 'assistant';

type MarkdownBlock =
  | { type: 'paragraph'; text: string }
  | { type: 'bullet'; items: string[] }
  | { type: 'ordered'; items: Array<{ index: string; text: string }> }
  | { type: 'code'; text: string };

interface MarkdownTextProps {
  content: string;
  variant: Variant;
}

export function MarkdownText({ content, variant }: MarkdownTextProps) {
  const blocks = useMemo(() => {
    const parsed = parseMarkdown(content);
    if (parsed.length === 0 && content.trim()) {
      return [{ type: 'paragraph', text: content.trim() }] as MarkdownBlock[];
    }
    return parsed;
  }, [content]);

  if (!content || !content.trim()) {
    return null;
  }

  return (
    <View>
      {blocks.map((block, idx) => {
        switch (block.type) {
          case 'paragraph':
            return (
              <View key={`p-${idx}`} style={styles.blockSpacing}>
                <Text style={[styles.body, variant === 'user' ? styles.userBody : styles.assistantBody]}>
                  {renderInline(block.text, variant, `p-${idx}`)}
                </Text>
              </View>
            );
          case 'bullet':
            return (
              <View key={`b-${idx}`} style={styles.blockSpacing}>
                {block.items.map((item, itemIdx) => (
                  <View key={`b-${idx}-${itemIdx}`} style={styles.listItemRow}>
                    <Text
                      style={[styles.listBullet, variant === 'user' ? styles.userBullet : styles.assistantBullet]}
                    >
                      •
                    </Text>
                    <Text
                      style={[styles.body, variant === 'user' ? styles.userBody : styles.assistantBody, styles.listText]}
                    >
                      {renderInline(item, variant, `b-${idx}-${itemIdx}`)}
                    </Text>
                  </View>
                ))}
              </View>
            );
          case 'ordered':
            return (
              <View key={`o-${idx}`} style={styles.blockSpacing}>
                {block.items.map((item, itemIdx) => (
                  <View key={`o-${idx}-${itemIdx}`} style={styles.listItemRow}>
                    <Text
                      style={[styles.listNumber, variant === 'user' ? styles.userBullet : styles.assistantBullet]}
                    >
                      {`${item.index}.`}
                    </Text>
                    <Text
                      style={[styles.body, variant === 'user' ? styles.userBody : styles.assistantBody, styles.listText]}
                    >
                      {renderInline(item.text, variant, `o-${idx}-${itemIdx}`)}
                    </Text>
                  </View>
                ))}
              </View>
            );
          case 'code':
            return (
              <View
                key={`c-${idx}`}
                style={[
                  styles.codeBlock,
                  variant === 'user' ? styles.userCodeBlock : styles.assistantCodeBlock
                ]}
              >
                <Text
                  style={[
                    styles.codeText,
                    variant === 'user' ? styles.userCodeText : styles.assistantCodeText
                  ]}
                >
                  {block.text}
                </Text>
              </View>
            );
          default:
            return null;
        }
      })}
    </View>
  );
}

function parseMarkdown(content: string): MarkdownBlock[] {
  const lines = content.split(/\r?\n/);
  const blocks: MarkdownBlock[] = [];
  let index = 0;

  while (index < lines.length) {
    const rawLine = lines[index];
    const trimmed = rawLine.trim();

    if (trimmed === '') {
      index += 1;
      continue;
    }

    if (trimmed.startsWith('```')) {
      const codeLines: string[] = [];
      index += 1;
      while (index < lines.length && !lines[index].trim().startsWith('```')) {
        codeLines.push(lines[index]);
        index += 1;
      }
      if (index < lines.length) {
        index += 1;
      }
      blocks.push({ type: 'code', text: codeLines.join('\n').trimEnd() });
      continue;
    }

    const bulletMatch = trimmed.match(/^[-*•]\s+(.*)$/);
    if (bulletMatch) {
      const items: string[] = [];
      while (index < lines.length) {
        const lineTrim = lines[index].trim();
        const match = lineTrim.match(/^[-*•]\s+(.*)$/);
        if (!match) break;
        items.push(match[1]);
        index += 1;
      }
      if (items.length) {
        blocks.push({ type: 'bullet', items });
      }
      continue;
    }

    const orderedMatch = trimmed.match(/^(\d+)[.)]\s+(.*)$/);
    if (orderedMatch) {
      const items: Array<{ index: string; text: string }> = [];
      while (index < lines.length) {
        const lineTrim = lines[index].trim();
        const match = lineTrim.match(/^(\d+)[.)]\s+(.*)$/);
        if (!match) break;
        items.push({ index: match[1], text: match[2] });
        index += 1;
      }
      if (items.length) {
        blocks.push({ type: 'ordered', items });
      }
      continue;
    }

    const paragraphLines: string[] = [];
    while (index < lines.length) {
      const current = lines[index];
      const currentTrim = current.trim();
      if (currentTrim === '') break;
      if (currentTrim.startsWith('```')) break;
      if (currentTrim.match(/^[-*•]\s+/) || currentTrim.match(/^(\d+)[.)]\s+/)) break;
      paragraphLines.push(currentTrim);
      index += 1;
    }

    const paragraphText = paragraphLines.join(' ').replace(/\s+/g, ' ').trim();
    if (paragraphText) {
      blocks.push({ type: 'paragraph', text: paragraphText });
    }
  }

  return blocks;
}

function renderInline(text: string, variant: Variant, keyPrefix: string) {
  const segments: Array<string | { type: 'bold' | 'code'; value: string }> = [];
  const regex = /(\*\*[^*]+\*\*|`[^`]+`)/g;
  let lastIndex = 0;
  let match: RegExpExecArray | null;

  while ((match = regex.exec(text)) !== null) {
    const start = match.index ?? 0;
    if (start > lastIndex) {
      segments.push(text.slice(lastIndex, start));
    }

    const token = match[0];
    if (token.startsWith('**')) {
      segments.push({ type: 'bold', value: token.slice(2, -2) });
    } else if (token.startsWith('`')) {
      segments.push({ type: 'code', value: token.slice(1, -1) });
    }

    lastIndex = start + token.length;
  }

  if (lastIndex < text.length) {
    segments.push(text.slice(lastIndex));
  }

  return segments.map((segment, idx) => {
    const key = `${keyPrefix}-${idx}`;
    if (typeof segment === 'string') {
      return segment;
    }

    if (segment.type === 'bold') {
      return (
        <Text key={key} style={styles.bold}>
          {segment.value}
        </Text>
      );
    }

    return (
      <Text
        key={key}
        style={[
          styles.codeInline,
          variant === 'user' ? styles.userCodeInline : styles.assistantCodeInline
        ]}
      >
        {segment.value}
      </Text>
    );
  });
}

const styles = StyleSheet.create({
  blockSpacing: {
    marginBottom: 8
  },
  body: {
    fontSize: 16,
    lineHeight: 26,
    textAlign: 'right',
    writingDirection: 'rtl',
    fontFamily: 'Tajawal_400Regular'
  },
  userBody: {
    color: '#FFFFFF'
  },
  assistantBody: {
    color: '#2D3748'
  },
  bold: {
    fontFamily: 'Tajawal_700Bold'
  },
  codeInline: {
    fontFamily: 'Courier',
    borderRadius: 6,
    paddingHorizontal: 6,
    paddingVertical: 2,
    marginHorizontal: 2
  },
  userCodeInline: {
    backgroundColor: 'rgba(255,255,255,0.2)',
    color: '#F6F9FF'
  },
  assistantCodeInline: {
    backgroundColor: 'rgba(15, 23, 42, 0.1)',
    color: '#111827'
  },
  listItemRow: {
    flexDirection: 'row-reverse',
    alignItems: 'flex-start',
    marginBottom: 4
  },
  listBullet: {
    fontSize: 12,
    marginLeft: 8,
    marginTop: 6
  },
  userBullet: {
    color: 'rgba(255,255,255,0.9)'
  },
  assistantBullet: {
    color: '#0D7C66'
  },
  listNumber: {
    fontSize: 13,
    marginLeft: 8,
    marginTop: 4,
    fontFamily: 'Tajawal_700Bold'
  },
  listText: {
    flex: 1
  },
  codeBlock: {
    borderRadius: 12,
    padding: 12,
    marginVertical: 6
  },
  userCodeBlock: {
    backgroundColor: 'rgba(255,255,255,0.15)',
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.2)'
  },
  assistantCodeBlock: {
    backgroundColor: '#0F172A'
  },
  codeText: {
    fontFamily: 'Courier',
    fontSize: 14,
    lineHeight: 22,
    textAlign: 'left',
    writingDirection: 'ltr'
  },
  userCodeText: {
    color: '#F8FAFC'
  },
  assistantCodeText: {
    color: '#E2E8F0'
  }
});
