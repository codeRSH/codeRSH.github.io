---
layout: base
title: Tags
permalink: /tags/
---

{% assign tags_list = '' | split: '' %}

{% for post in site.posts %}
  {% if post.tags %}
    {% for tag in post.tags %}
      {% assign tags_list = tags_list | push: tag %}
    {% endfor %}
  {% endif %}
{% endfor %}

{% assign tags = tags_list | uniq %}

{% comment %}Create array of tags with their counts{% endcomment %}
{% assign tag_counts = '' | split: '' %}
{% assign max_count = 0 %}
{% assign min_count = site.posts.size %}

{% for tag in tags %}
  {% assign count = 0 %}
  {% for post in site.posts %}
    {% if post.tags contains tag %}
      {% assign count = count | plus: 1 %}
    {% endif %}
  {% endfor %}
  
  {% if count > max_count %}
    {% assign max_count = count %}
  {% endif %}
  {% if count < min_count %}
    {% assign min_count = count %}
  {% endif %}
  
  {% capture tag_with_count %}{{ count }}#{{ tag }}{% endcapture %}
  {% assign tag_counts = tag_counts | push: tag_with_count %}
{% endfor %}

{% assign count_range = max_count | minus: min_count %}
{% assign sorted_tags = tag_counts | sort | reverse %}

<div class="tag-cloud">
  {% for tag_info in sorted_tags %}
    {% assign tag_parts = tag_info | split: '#' %}
    {% assign count = tag_parts[0] | plus: 0 %}
    {% assign tag = tag_parts[1] %}
    
    {% comment %}Calculate size class based on actual count range{% endcomment %}
    {% assign size_factor = count | minus: min_count | times: 100 | divided_by: count_range %}
    {% assign size_class = 1 %}
    {% if size_factor >= 80 %}
      {% assign size_class = 5 %}
    {% elsif size_factor >= 60 %}
      {% assign size_class = 4 %}
    {% elsif size_factor >= 40 %}
      {% assign size_class = 3 %}
    {% elsif size_factor >= 20 %}
      {% assign size_class = 2 %}
    {% endif %}
    
    <a href="/tag/{{ tag }}" class="tag-cloud-item" data-weight="{{ size_class }}">
      {{ tag }} <span class="tag-count">({{ count }})</span>
    </a>
  {% endfor %}
</div>
