---
page_id: courses
layout: page
permalink: /courses/
title: Cursos
description: Materiais dos cursos que ministrei. Aqui há uma breve descrição do conteúdo dos cursos, mas mais informações podem ser encontradas no repositório do semestre correspondente, clique na categoria do nome. 
nav: true
nav_order: 6
display_categories: [ETITC-2024-1, ETITC-2024-2, others]
horizontal: true
---

<!-- pages/projects.md -->
<div class="projects">
  {% if site.enable_course_categories and page.display_categories %}
    <!-- Display categorized courses -->
    {% for category in page.display_categories %}
      <a id="{{ site.data[site.active_lang].strings.categories[category] }}" href="{{ site.data[site.active_lang].strings.links[category] }}">
        <h2 class="category">{{ site.data[site.active_lang].strings.categories[category] }}</h2>
      </a>
      <p>{{ site.data[site.active_lang].strings.categories_description[category] }} </p>
      {% assign categorized_courses = site.courses | where: "category", category %}
      {% assign sorted_courses = categorized_courses | sort: "importance" %}
      <!-- Generate cards for each course -->
      {% if page.horizontal %}
        <div class="container">
          <div class="row row-cols-1 row-cols-md-2">
            {% for course in sorted_courses %}
              {% include courses_horizontal.liquid %}
            {% endfor %}
          </div>
        </div>
      {% else %}
        <div class="row row-cols-1 row-cols-md-4">
          {% for course in sorted_courses %}
            {% include courses.liquid %}
          {% endfor %}
        </div>
      {% endif %}
    {% endfor %}
  {% else %}
    <!-- Display courses without categories -->
    {% assign sorted_courses = site.courses | sort: "importance" %}
    <!-- Generate cards for each course -->
    {% if page.horizontal %}
      <div class="container">
        <div class="row row-cols-1 row-cols-md-2">
          {% for course in sorted_courses %}
            {% include courses_horizontal.liquid %}
          {% endfor %}
        </div>
      </div>
    {% else %}
      <div class="row row-cols-1 row-cols-md-3">
        {% for course in sorted_courses %}
          {% include courses.liquid %}
        {% endfor %}
      </div>
    {% endif %}
  {% endif %}
</div>
