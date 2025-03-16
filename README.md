# ChatPharo

ChatPharo is a set of classes designed to integrate AI/chat functionality into the Pharo environment. This plugin allows you to communicate with language models (such as OpenAI's ChatGPT) directly from Pharo, send prompts for completions, retrieve generated responses, and build more advanced AI-driven workflows within the Smalltalk ecosystem.

Features 🚀

Seamless AI Integration: Communicate with various LLMs like OpenAI, DeepSeek, Mistral, and CodeLlama.

Local & Cloud Support: Works with local models via Ollama and remote APIs like OpenAI, DeepSeek, and more.

Modular Design: Easily extendable to support additional models.

Spec UI Interface: Interactive chat interface for smooth user experience.


Getting Started 🚀
===============

To use ChatPharo, follow these steps:

1. Install the ChatPharo plugin using the Pharo package manager.
2. Import the ChatPharo package in your Pharo project.
3. Create an instance of the `ChatPharo` class and configure it with your preferred model
and API key.
4. Use the `sendMessage:` method to send prompts to the AI and retrieve responses.


Installation 🔧

Prerequisites ----

Pharo 10+ (Recommended)
Ollama (for local models) (Optional, required for running local models)

Steps to Install
Open a Pharo image.

Load Pharo-LLMAPI using Metacello:

Metacello new
  githubUser: 'Evref-BL' project: 'Pharo-LLMAPI' commitish: 'main' path: 'src';
  baseline: 'LLMAPI';
  load


Example Usage ---
===============
smalltalk

For the example of using the Mistral model, you can use the following code:

api := LLMAPI chat.
api host: 'api.mistral.ai'.
api apiKey: '<apiKey>'.

api payload
	temperature: 0.5;
	model: 'mistral-small-latest';
	top_p: 1;
	max_tokens: 250;
	messages: {
		LLMAPIChatObjectMessage role: 'system' content: 'You are a usefull assistant'.
		LLMAPIChatObjectMessage role: 'user' content: 'How to write hello world in Pharo?'.
		 }.

result := api performRequest.

For the UI --
===============
You can use the following code to create a UI for the chat:

LLMAPISpec open

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