---
layout: archive
title: "Posts by Tag"
permalink: /tags/
author_profile: true
---

{% for tag in site.tags %}
* [{{ tag[0] }}](#{{ tag[0] | slugify }}){: class="archive__item-title"} — {{ tag[1].size }} 篇
{% endfor %}
