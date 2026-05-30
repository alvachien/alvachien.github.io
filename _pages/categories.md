---
layout: archive
title: "Posts by Category"
permalink: /categories/
author_profile: true
---

{% for category in site.categories %}
* [{{ category[0] }}](/categories/{{ category[0] | cgi_escape }}/){: class="archive__item-title"} — {{ category[1].size }} 篇
{% endfor %}
