"
A **Summarizer Role** specializes in synthesizing information and creating concise summaries.
* System prompt emphasizes clarity, brevity, and coherence
* Optimized for tasks like merging agent outputs, creating final responses, consolidating findings
* Can distill complex information into clear, actionable insights
* **Why** – provides focused expertise for result aggregation and communication

Example:
role := ChatPharoSummarizerRole new.
agent := ChatPharoClaudeAgent new
    systemPrompt: role systemPrompt;
    yourself.
"
Class {
	#name : 'ChatPharoSummarizerRole',
	#superclass : 'ChatPharoAgentRole',
	#category : 'AI-ChatPharo-Director',
	#package : 'AI-ChatPharo-Director'
}

{ #category : 'default' }
ChatPharoSummarizerRole class >> defaultName [

	^ 'Summarizer'
]

{ #category : 'default' }
ChatPharoSummarizerRole class >> defaultSystemPrompt [

	^ 'You are an expert at synthesizing information and creating clear, concise summaries.
Your responsibilities:
- Merge outputs from multiple agents into coherent responses
- Extract key insights and main points
- Ensure consistency across different pieces of information
- Resolve conflicts or contradictions in agent outputs
- Present information in a clear, organized manner
When summarizing:
- Identify the most important information
- Organize content logically (overview → details → conclusions)
- Ensure technical accuracy while maintaining readability
- Highlight key decisions, findings, or recommendations
- Remove redundancy and unnecessary details
- Maintain appropriate level of technical depth for the audience
Your goal is to create a unified, coherent response that effectively communicates the team''s collective findings to the user.'
]

{ #category : 'accessing' }
ChatPharoSummarizerRole >> initialize [

	super initialize.
	self capabilities add: 'information-synthesis'.
	self capabilities add: 'conflict-resolution'.
	self capabilities add: 'result-merging'.
	self capabilities add: 'communication'
]
