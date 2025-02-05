---
title: How my Telegram BOT works
date: 2025-02-05
draft: false
tags:
  - blog
  - ai
  - vectors
---

Used Tech Stack : 
- Mistral AI (to embed the description the user gives)
- Pinecone (a vector DB to store all the anime embeddings)
- Telegram.py API  (to handle the bot behavior)
- Selenium (to scrape data)

## First PART : Scrape the data (selenium)

![Image Description](/Pasted%20image%2020250205144459.png)


Using selenium i scrape lots of anime from anime websites and store data about lots of anime (including title, image, descriptions, genres , etc . . .)

I store everything in a json file to handle easily everything offline !

## Second part : Embedding the anime (MistralAI and Pinecone)

![Image Description](/Pasted%20image%2020250205145619.png)

Using a python script I send to Mistral AI mi anime, with description , title and other informations.
Mistral return for each anime a vector rappresenting the embedding for each anime (1024 float value), this embedding store in a vector the real meaning and soul of every anime

After that i store every embedding in a Pinecone (vector DB) in order to query efficiently in the future. In fact, a vector DB can return, based on the embeddings, and given a new embedding, the most k similar vector, based on cosine similarity.

## Third Part : Telegram Bot (python)

![Image Description](/Pasted%20image%2020250205150906.png)

A python script that powers the telegram bot, get the user description of the anime, after that, the script retrieve the embedding of this description from an API request to a Mistral AI.
Once we know the embedding of the description, we can get the most similar anime from the pinecone DB and reply with that to the user !!

## Code available on my github repo : 

https://github.com/FREEDuu/TelegramBOT-anime

fell free to take the code, pull request or contact me for any questions !! :D