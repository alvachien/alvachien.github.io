---
layout: post
title:  "让Katex在Karmdown 2.3版本上正常显示(Katex)"
date:   2020-08-09 21:56:22 +0800
tags: [Math, Latex, Katex]
categories: [随心随笔]
---

随着Github page升级到[207版本](https://github.com/github/pages-gem/releases/tag/v207)，kramdown被升级到2.3.0，然后，原先的Latex（基于Katex）不能正常显示了。


正如Github 在release里面提到的：

> NOTE: This release changes the way Math is converted. It will now output inside backslash-square-brackets: `\[` ... `\]`. You may need to update your JavaScript (usually the MathJax library) to support this.


然后，发现了一堆的同样的问题：
- [Bump jekyll to v3.9.0, kramdown to v2.3.0 ](https://github.com/github/pages-gem/pull/704)
- [MathJax v3 no longer processes Kramdown's math engine's](https://github.com/gettalong/kramdown/issues/626)

Karmdown官方文档关于Math的支持，真的是寥寥数语，云里雾里。
[Math Block](https://kramdown.gettalong.org/syntax.html#math-blocks)



只能到处找现成的解决方案，找到一篇[Blog](https://gendignoux.com/blog/2020/05/23/katex.html)，试图去使用同样的方法来解决，遇到一堆的问题：

- 'Gem install' 和 'Gem update'的速度问题

一如既往，长城内外的区别。解决方法是使用国内镜像：

```ruby
source "https://gems.ruby-china.com"
```

- [kramdown-math-katex](https://github.com/kramdown/math-katex)

Karmdown官方文档关于[Katex支持](https://kramdown.gettalong.org/math_engine/katex.html)，延续了Jekyll一贯的风格，语焉不详之外，把所有的东西都指向了那个号称2.0版本之前一直内置、2.0版本就被剔除的Katex的转换包。

> Note: Until kramdown version 2.0.0 this math engine was part of the kramdown distribution.

打开这个数年没有维护的repo，更加是文档缺少，连一个example都没有。在github上搜索了一下关于这个包的引用，似乎只有基于Jekyll的[Fastpages](https://github.com/fastai/fastpages)默认使用了这个converter，随便找了几个repo，貌似没有一个真正把Katex用起来的。

为了试试这个converter，去Clone了[Personal-website](https://github.com/github/personal-website), 安装了这个converter（Gemfile添加并手动bundle install)，然而没有任何效果。

仔细看了看math-katex的文档，看到它要求一个javascript的runtime，试图安装列在最前面的[therubyracer](https://github.com/cowboyd/therubyracer)，发现又一个2年多没有更新的repo，还在V8引擎的3.0+版本，而V8引擎已经是版本8.0+了。即便修改了国内镜像源，这个包依旧没办法安装成功。

- 前台的问题用前台方案解决

本来已经打算放弃Katex，回归Karmdown一直被视为正统的Mathjax了，已经在估算所有Blog所需的工作量了，同时也在后悔当初为了Katex而耗费的千辛万苦。但还是打算瞅瞅Katex的文档看看是不是能直接支持backslash-square-brackets的新方法。


皇天不负有心人，在[AutoRender页面](https://katex.org/docs/autorender.html),发现了下述delimiter的设置：
```javascript
[
  {left: "$$", right: "$$", display: true},
  {left: "$", right: "$", display: false},
  {left: "\\(", right: "\\)", display: false},
  {left: "\\[", right: "\\]", display: true}
]
```

貌似已经可以完美解决这个问题了。试了试，果然！ :laugh:

搞定！

是为之记。   
Alva Chien   
2020.08.09
