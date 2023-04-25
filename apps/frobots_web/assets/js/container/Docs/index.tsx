import React from 'react'
import { Container } from '@mui/material'
import { Layout as DocsLayout } from './layouts'
import { ArticleContent } from './article-content'

interface DocumentsProps {
  name: string
  article: string
  slug: string
}

export default (props: DocumentsProps) => {
  const { article, slug } = props

  return (
    <DocsLayout pathname={slug}>
      <Container maxWidth="lg" sx={{ pb: '120px' }}>
        <ArticleContent content={article || ''} />
      </Container>
    </DocsLayout>
  )
}
