# alvachien.github.io

This repo is the source of [My Blog](https://alvachien.github.io)

## 主题

本站使用 [Minimal Mistakes](https://github.com/mmistakes/minimal-mistakes) 主题。

## 插件

### Jekyll 插件

配置于 `_config.yml` 中：

| 插件 | 功能 |
|------|------|
| jemoji | 支持 GitHub 风格 emoji |
| jekyll-paginate | 分页功能 |
| jekyll-sitemap | 生成 sitemap.xml |
| jekyll-octicons | GitHub 图标支持 |
| jekyll-seo-tag | SEO 标签优化 |
| jekyll-feed | RSS 订阅支持 |
| jekyll-include-cache | 缓存包含文件以提升性能 |

## 本地运行

```bash
# 安装依赖
bundle install

# 运行本地服务器
bundle exec jekyll serve

# 构建生产版本
bundle exec jekyll build
```

## 文章发布

新文章放置于 `_posts/` 目录，命名格式为 `YYYY-MM-DD-title.md`。文章需包含 Front Matter：

```yaml
---
title: "文章标题"
date: YYYY-MM-DD
categories: [分类]
tags: [标签1, 标签2]
---
```