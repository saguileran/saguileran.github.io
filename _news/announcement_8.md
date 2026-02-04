---
layout: post
title:  Heavy accident 🤕 🩼
date: 2024-10-16 07:59:00-0400
description: I broke my ankle (fibula) in the second semestr of my masters.
tags: formatting images, USP
categories: sample-posts
thumbnail:
images:
  lightbox2: false
  photoswipe: false
  spotlight: false
  venobox: false
  compare: true
  slider: true
_styles: ".slider-wrapper {
  display: flex;
  gap: 10px;
  align-items: flex-start;
}

.slider1 {
  height: 500px;
  width: 250px;
}

.slider2 {
  height: 500px;
  width: 500px;
}

swiper-slide {
  display: flex;
  align-items: center;
  justify-content: center;
}
"
---

<div class="slider-wrapper">
  <swiper-container keyboard="true" navigation="true" pagination="true" pagination-clickable="true" pagination-dynamic-bullets="true" rewind="true" class="slider1">
    <swiper-slide>{% include figure.liquid loading="eager" path="../../assets/img/posts/ankle/Broken.jpeg" class="img-fluid rounded z-depth-1" %}</swiper-slide>
    <swiper-slide>{% include figure.liquid loading="eager" path="../../assets/img/posts/ankle/cirugy.jpeg" class="img-fluid rounded z-depth-1" %}</swiper-slide>
    <swiper-slide>{% include figure.liquid loading="eager" path="../../assets/img/posts/ankle/fractura.jpeg" class="img-fluid rounded z-depth-1" %}</swiper-slide>
    <swiper-slide>{% include figure.liquid loading="eager" path="../../assets/img/posts/ankle/USPUber.jpeg" class="img-fluid rounded z-depth-1" %}</swiper-slide>
    <swiper-slide>{% include figure.liquid loading="eager" path="../../assets/img/posts/ankle/FracturaTodos.jpeg" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  </swiper-container>

  <swiper-container keyboard="true" navigation="true" pagination="true" pagination-clickable="true" pagination-dynamic-bullets="true" rewind="true"  class="slider2">
    <swiper-slide>{% include figure.liquid loading="eager" path="../../assets/img/posts/ankle/FracturaTodos1.jpeg" class="img-fluid rounded z-depth-1" %}</swiper-slide>
    <swiper-slide>{% include figure.liquid loading="eager" path="../../assets/img/posts/ankle/EduardoHBP.jpeg" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  </swiper-container>
</div>
