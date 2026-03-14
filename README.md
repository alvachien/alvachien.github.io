# alvachien.github.io

This repo is the source of [My Blog](https://alvachien.github.io)

## 主题

本站使用 [beautiful-jekyll-theme](https://github.com/daattali/beautiful-jekyll) 主题。

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

### 自定义插件 (`_plugins`)

`_plugins/generator.rb` 自动生成以下页面：

- **标签页**: 自动为每个 tag 生成独立页面，布局使用 `tag.html`
- **分类页**: 自动为每个 category 生成独立页面，布局使用 `category.html`
- **归档页**: 按年份生成归档页面，布局使用 `archive.html`

## 布局

`_layouts/` 目录包含以下布局文件：

| 布局 | 用途 |
|------|------|
| `home.html` | 首页布局 |
| `post.html` | 文章详情页布局 |
| `page.html` | 普通页面布局 |
| `tag.html` | 标签聚合页布局 |
| `category.html` | 分类聚合页布局 |
| `archive.html` | 年度归档页布局 |

## 自定义包含

`_includes/head_custom.html` - 用于在 `<head>` 标签中添加自定义内容。

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


