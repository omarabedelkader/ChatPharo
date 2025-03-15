# ChatPharo

ChatPharo is a set of classes designed to integrate AI/chat functionality into the Pharo environment. This plugin allows you to communicate with language models (such as OpenAI's ChatGPT) directly from Pharo, send prompts for completions, retrieve generated responses, and build more advanced AI-driven workflows within the Smalltalk ecosystem.

Features 🚀

Seamless AI Integration: Communicate with various LLMs like OpenAI, DeepSeek, Mistral, and CodeLlama.

Local & Cloud Support: Works with local models via Ollama and remote APIs like OpenAI, DeepSeek, and more.

Modular Design: Easily extendable to support additional models.

Spec UI Interface: Interactive chat interface for smooth user experience.

Function Calling (Planned): Enable AI to call Smalltalk functions.

Multimodal Support (Planned): Image and speech integration.

RAG (Planned): Use vector search for better context retention.


Getting Started 🚀
===============

To use ChatPharo, follow these steps:

1. Install the ChatPharo plugin using the Pharo package manager.
2. Import the ChatPharo package in your Pharo project.
3. Create an instance of the `ChatPharo` class and configure it with your preferred model
and API key.
4. Use the `sendMessage:` method to send prompts to the AI and retrieve responses.


Example Usage ---
===============
smalltalk

| chat response |
chat := ChatPharo new.
response := chat sendMessage: 'What is Pharo?'.
Transcript show: response.
| chat response |
This example creates a new instance of `ChatPharo`, sends a prompt to the AI, and
displays the response in the Transcript.


Installation 🔧

Prerequisites ----

Pharo 10+ (Recommended)
Ollama (for local models) (Optional, required for running local models)

Steps to Install
Open a Pharo image.

Load ChatPharo using Metacello:

Metacello new
    baseline: 'AIChatPharo';
    repository: 'github://your-repo/ChatPharo';
    load.

Start ChatPharo:
ChatPharo open.

Usage 📖
Basic Chat Interaction

| chat response |
chat := ChatPharo new.
response := chat sendMessage: 'What is Pharo?'.
Transcript show: response.

Switching AI Models

chat setModel: OLlamaModel new.
chat setModel: ODeepseekerCodeModel new.

Custom API Calls
LLMAPI new sendRequest: 'Translate this to French: Hello world'.


Contributing 🤝
We welcome contributions! To contribute:

Fork the repository.

Create a new branch (feature-new-model or fix-bug).

Submit a pull request with a clear description.


License 📜
ChatPharo is released under the MIT License. See the LICENSE file for details.


Acknowledgments 🙌
Special thanks to the Pharo community and open-source contributors making AI more accessible in Smalltalk!

🚀 Start ChatPharo today and bring AI into your Pharo workflow! 🚀