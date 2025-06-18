# ChatPharo

ChatPharo is designed to integrate AI/chat functionality into the Pharo environment. This plugin allows you to communicate with language models (such as OpenAI's ChatGPT) directly from Pharo.

To install `ChatPharo` in your image you can use:

```smalltalk
Metacello new
  githubUser: 'omarabedelkader' project: 'ChatPharo' commitish: 'main' path: 'src';
  baseline: 'AIChatPharo';
  load
```


