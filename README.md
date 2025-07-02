# ChatPharo

ChatPharo is designed to integrate AI/chat functionality into the Pharo environment. This plugin allows you to communicate with language models directly from Pharo.

To install stable version of `ChatPharo` in your image you can use:

```smalltalk
Metacello new
  githubUser: 'omarabedelkader' project: 'ChatPharo' commitish: 'v0.1.0' path: 'src';
  baseline: 'AIChatPharo';
  load
```


For development version install it with this:

```smalltalk
Metacello new
  githubUser: 'omarabedelkader' project: 'ChatPharo' commitish: 'main' path: 'src';
  baseline: 'AIChatPharo';
  load.
```

