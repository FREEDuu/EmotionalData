---
title: Hello World Blog Post ( pipeline explained )
date: 2025-01-09
draft: false
tags:
  - helloworld
  - blog
---

## Why i'm doing this

i think in this modern AI automated world, we still need to write our personal thought and keep sharing value to people with our knowledge and experience.
I also think that this activity will help me to speak and write better in English and keep my brain full of quality information, not just a bunch of noise we see in modern social media 

## My pipeline

Hello everyone, this is my first post of the blog and in this post i'm going to explain the pipeline i use in order to publish new post within seconds !!

```SQL
SELECT * FROM MY_PERSONAL_KNOWLEDGE
```

![Image of a chart](/image1.png)

## Some Tech Problems Encountered 

normally with obsidian you specify a presence of an image with   `![[image]]` but with Hugo this doesn't work and you have to specify an image with this tag `![Image of a chart] (/image1.png)`

## A Big Automated Script

if i want to make a new post i just run a bash, simple and beautiful script that take sync the folder where i write posts in obsidian with the folder content/posts in Hugo main folders


![Image of a chart](/image2.png)

```bash
#!/bin/bash

  

rsync -av --delete "/home/francesco/Documents/Obsidian Vault/static" "/home/francesco/Desktop/PersonalBlog/"

  

echo "copy images"

  

rsync -av --delete "/home/francesco/Documents/Obsidian Vault/posts" "/home/francesco/Desktop/PersonalBlog/static"

  

echo "copy posts"

  

echo "Connecting to GH via ssh"

hugo

ssh -T git@github.com

  

echo "push changes into PersonalBlog.git repo"

  

git add .

git commit -m "Create hugo.yaml"

git push

  

echo "everything fine and up to date"
```