# ChatPharo

ChatPharo is designed to integrate AI/chat functionality into the Pharo environment. This plugin allows you to communicate with language models (such as OpenAI's ChatGPT) directly from Pharo.


# Prerequisites

- [Pharo](https://pharo.org/)
- [Ollama](https://ollama.com/) (installed on your system)

1. **Download and Install Ollama**

   Visit [https://ollama.com/](https://ollama.com/) and download the appropriate version for your system. Install and launch Ollama.

2. **Pull the Codellama Model**

   Open your terminal and run the following command:

   ```bash
   ollama pull codellama:7b

# Installation

To install `ChatPharo` in your image you can use:

```smalltalk
Metacello new
  githubUser: 'omarabedelkader' project: 'ChatPharo' commitish: 'main' path: 'src';
  baseline: 'AIChatPharo';
  load
```


