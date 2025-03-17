# ChatPharo

ChatPharo is a set of classes designed to integrate AI/chat functionality into the Pharo environment. This plugin allows you to communicate with language models (such as OpenAI's ChatGPT) directly from Pharo, send prompts for completions, retrieve generated responses, and build more advanced AI-driven workflows within the Smalltalk ecosystem.

# Installation

To install `ChatPharo` in your image you can use:

```smalltalk
Metacello new
  githubUser: 'omarabedelkader' project: 'ChatPharo' commitish: 'main' path: 'src';
  baseline: 'AIChatPharo';
  load
```
