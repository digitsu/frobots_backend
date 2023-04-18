import React from 'react'

export const neutral = {
  50: '#F8F9FA',
  100: '#F3F4F6',
  200: '#E5E7EB',
  300: '#D2D6DB',
  400: '#9DA4AE',
  500: '#6C737F',
  600: '#4D5761',
  700: '#2F3746',
  800: '#1C2536',
  900: '#111927',
}

export const codeStyle = {
  'code[class*="language-"]': {
    color: neutral[50],
    background: 'none',
    textShadow: '0 1px rgba(0, 0, 0, 0.3)',
    fontFamily:
      "'Roboto Mono', Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace",
    fontSize: '14px',
    textAlign: 'left',
    whiteSpace: 'pre',
    wordSpacing: 'normal',
    wordBreak: 'normal',
    wordWrap: 'normal',
    lineHeight: '1.5',
    MozTabSize: '4',
    OTabSize: '4',
    tabSize: '4',
    WebkitHyphens: 'none',
    MozHyphens: 'none',
    msHyphens: 'none',
    hyphens: 'none',
  },
  'pre[class*="language-"]': {
    color: neutral[50],
    background: neutral[800],
    textShadow: '0 1px rgba(0, 0, 0, 0.3)',
    fontFamily:
      "'Roboto Mono', Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace",
    fontSize: '14px',
    textAlign: 'left',
    whiteSpace: 'pre',
    wordSpacing: 'normal',
    wordBreak: 'normal',
    wordWrap: 'normal',
    lineHeight: '1.5',
    MozTabSize: '4',
    OTabSize: '4',
    tabSize: '4',
    WebkitHyphens: 'none',
    MozHyphens: 'none',
    msHyphens: 'none',
    hyphens: 'none',
    padding: '1em',
    margin: '.5em 0',
    overflow: 'auto',
    borderRadius: '8px',
  },
  ':not(pre) > code[class*="language-"]': {
    background: neutral[800],
    padding: '.1em',
    borderRadius: '.3em',
    whiteSpace: 'normal',
  },
  comment: {
    color: '#6272a4',
  },
  prolog: {
    color: '#6272a4',
  },
  doctype: {
    color: '#6272a4',
  },
  cdata: {
    color: '#6272a4',
  },
  punctuation: {
    color: '#f8f8f2',
  },
  '.namespace': {
    Opacity: '.7',
  },
  property: {
    color: '#ff79c6',
  },
  tag: {
    color: '#ff79c6',
  },
  constant: {
    color: '#ff79c6',
  },
  symbol: {
    color: '#ff79c6',
  },
  deleted: {
    color: '#ff79c6',
  },
  boolean: {
    color: '#bd93f9',
  },
  number: {
    color: '#bd93f9',
  },
  selector: {
    color: '#50fa7b',
  },
  'attr-name': {
    color: '#50fa7b',
  },
  string: {
    color: '#50fa7b',
  },
  char: {
    color: '#50fa7b',
  },
  builtin: {
    color: '#50fa7b',
  },
  inserted: {
    color: '#50fa7b',
  },
  operator: {
    color: '#f8f8f2',
  },
  entity: {
    color: '#f8f8f2',
    cursor: 'help',
  },
  url: {
    color: '#f8f8f2',
  },
  '.language-css .token.string': {
    color: '#f8f8f2',
  },
  '.style .token.string': {
    color: '#f8f8f2',
  },
  variable: {
    color: '#f8f8f2',
  },
  atrule: {
    color: '#f1fa8c',
  },
  'attr-value': {
    color: '#f1fa8c',
  },
  function: {
    color: '#f1fa8c',
  },
  'class-name': {
    color: '#f1fa8c',
  },
  keyword: {
    color: '#8be9fd',
  },
  regex: {
    color: '#ffb86c',
  },
  important: {
    color: '#ffb86c',
    fontWeight: 'bold',
  },
  bold: {
    fontWeight: 'bold',
  },
  italic: {
    fontStyle: 'italic',
  },
}

export const articleStyle = (theme) => ({
  color: theme.palette.text.primary,
  fontFamily: theme.typography.fontFamily,
  '& blockquote': {
    borderLeft: `4px solid ${theme.palette.text.secondary}`,
    marginBottom: theme.spacing(2),
    paddingBottom: theme.spacing(1),
    paddingLeft: theme.spacing(2),
    paddingTop: theme.spacing(1),
    '& > p': {
      color: theme.palette.text.secondary,
      marginBottom: 0,
    },
  },
  '& code': {
    color: theme.palette.primary.main,
    fontFamily:
      "Inconsolata, Monaco, Consolas, 'Courier New', Courier, monospace",
    fontSize: 14,
    paddingLeft: 2,
    paddingRight: 2,
  },
  '& h1': {
    fontSize: 35,
    fontWeight: 500,
    letterSpacing: '-0.24px',
    marginBottom: theme.spacing(2),
    marginTop: theme.spacing(6),
  },
  '& h2': {
    fontSize: 29,
    fontWeight: 500,
    letterSpacing: '-0.24px',
    marginBottom: theme.spacing(2),
    marginTop: theme.spacing(6),
  },
  '& h3': {
    fontSize: 24,
    fontWeight: 500,
    letterSpacing: '-0.06px',
    marginBottom: theme.spacing(2),
    marginTop: theme.spacing(6),
  },
  '& h4': {
    fontSize: 20,
    fontWeight: 500,
    letterSpacing: '-0.06px',
    marginBottom: theme.spacing(2),
    marginTop: theme.spacing(4),
  },
  '& h5': {
    fontSize: 16,
    fontWeight: 500,
    letterSpacing: '-0.05px',
    marginBottom: theme.spacing(2),
    marginTop: theme.spacing(2),
  },
  '& h6': {
    fontSize: 14,
    fontWeight: 500,
    letterSpacing: '-0.05px',
    marginBottom: theme.spacing(2),
    marginTop: theme.spacing(2),
  },
  '& li': {
    fontSize: 14,
    lineHeight: 1.5,
    marginBottom: theme.spacing(2),
    marginLeft: theme.spacing(4),
  },
  '& p': {
    fontSize: 14,
    lineHeight: 1.5,
    marginBottom: theme.spacing(2),
    '& > a': {
      color: theme.palette.primary.main,
    },
  },
})
