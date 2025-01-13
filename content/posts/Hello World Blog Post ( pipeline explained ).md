---
title: Hello World Blog Post ( pipeline explained )
date: 2025-01-10
draft: false
tags:
  - blog
  - tutorial
---

## Why i'm doing this

i think in this modern AI automated world, we still need to write our personal thought and keep sharing value to people with our knowledge and experience.
I also think that this activity will help me to speak and write better in English and keep my brain full of quality information, not just a bunch of noise we see in modern social media 

## My pipeline

Hello everyone, this is my first post of the blog and in this post i'm going to explain the pipeline i use in order to publish new post within seconds !!

```SQL
SELECT * FROM MY_PERSONAL_KNOWLEDGE
```


!![Image Description](/image1.png)
## Some Tech Problems Encountered 

normally with obsidian you specify a presence of an image with   `![[image]]` but with Hugo this doesn't work and you have to specify an image with this tag `![Image of a chart] (/image1.png)`

## A Big Automated Script

if i want to make a new post i just run a bash, simple and beautiful script that take sync the folder where i write posts in obsidian with the folder content/posts in Hugo main folders


!![Image Description](/image2.png)

```bash
#!/bin/bash

rsync -av --delete "From/obsidianVaultPath/to_copy" "To_copy/Path"

echo "copy images"

rsync -av --delete "From/obsidianVaultPath/to_copy" "To_copy/Path"

echo "copy posts"

# with rsync i copy all my images and blog's posts into my hugo folders

echo "Connecting to GH via ssh"

hugo

ssh -T git@github.com
  
echo "push changes into EmotionalData.git repo"

git add .

git commit -m "Create new post !! :D "

git push

echo "everything fine and up to date"
```

Netlify will detect the changes on the master branch of the repo and deploy the new post

## IDEA : 

i take inspiration of the idea from a Youteber , i'll share his video if someone interested :
https://www.youtube.com/watch?v=dnE7c0ELEH8 but i don't like at all his HOSTINGER sponsorship and i just deploy my blog for free uusing NETLIFY

# Docs Followed

i follow this HUGO official docs to deploy everything with NETLIFY :
https://gohugo.io/hosting-and-deployment/hosting-on-netlify/

tags : [[blog]], [[guide]]
