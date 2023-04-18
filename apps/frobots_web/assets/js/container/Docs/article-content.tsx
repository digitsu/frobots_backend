import React, { type FC } from 'react'
import Markdown from 'react-markdown'
import type { Components } from 'react-markdown/lib/ast-to-react'
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter'
import PropTypes from 'prop-types'
import { styled } from '@mui/material/styles'
import { articleStyle, codeStyle } from '../../theme/code-style'

const Code: Components['code'] = (props) => {
  const { node, inline, className, children, ...other } = props

  const language = /language-(\w+)/.exec(className || '')

  return !inline && language ? (
    <SyntaxHighlighter
      children={String(children).replace(/\n$/, '')}
      language={language[1]}
      PreTag="div"
      style={codeStyle}
      {...other}
    />
  ) : (
    <code className={className} {...other}>
      {children}
    </code>
  )
}

const Link: Components['link'] = (props) => {
  const { href, children } = props

  if (!href?.startsWith('http')) {
    return <a href={href}>{children}</a>
  }

  return (
    <a href={href} rel="nofollow noreferrer noopener" target="_blank">
      {children}
    </a>
  )
}

const components: Components = {
  link: Link,
  code: Code,
}

const ArticleContentRoot = styled('div')(({ theme }) => articleStyle(theme))

interface ArticleContentProps {
  content: string
}

export const ArticleContent: FC<ArticleContentProps> = (props) => {
  const { content } = props

  return (
    <ArticleContentRoot>
      <Markdown children={content} components={components} />
    </ArticleContentRoot>
  )
}

ArticleContent.propTypes = {
  content: PropTypes.string.isRequired,
}
