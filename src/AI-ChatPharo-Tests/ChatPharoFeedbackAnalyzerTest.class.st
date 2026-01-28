Class {
	#name : 'ChatPharoFeedbackAnalyzerTest',
	#superclass : 'TestCase',
	#instVars : [
		'analyzer',
		'memory',
		'originalMemory'
	],
	#category : 'AI-ChatPharo-Tests-Memory',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Memory'
}

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> setUp [

	super setUp.
	"Save original memory and create a fresh one for testing"
	originalMemory := ChatPharoMemory default.
	memory := ChatPharoMemory new.
	ChatPharoMemory setDefault: memory.
	analyzer := ChatPharoFeedbackAnalyzer new
]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> tearDown [

	"Restore original memory"
	ChatPharoMemory setDefault: originalMemory.
	super tearDown
]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> testAcceptanceRateWithMixedFeedback [

	"Add some positive and negative feedback"
	memory addFeedback: 'Good suggestion' positive: true.
	memory addFeedback: 'Bad suggestion' positive: false.
	memory addFeedback: 'Excellent' positive: true.
	memory addFeedback: 'Not helpful' positive: false.
	memory addFeedback: 'Perfect' positive: true.

	"Should be 60% (3 out of 5)"
	self assert: analyzer acceptanceRate closeTo: 0.6 precision: 0.01
]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> testAcceptanceRateWithNoFeedback [

	"With no feedback, acceptance rate should be 0"
	self assert: analyzer acceptanceRate equals: 0.0
]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> testAcceptanceRateWithOnlyPositive [

	"Add only positive feedback"
	memory addFeedback: 'Great' positive: true.
	memory addFeedback: 'Excellent' positive: true.

	"Should be 100%"
	self assert: analyzer acceptanceRate equals: 1.0
]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> testAnalyzeFeedbackPatternsWithCorrections [
	"Add many corrections"

	| patterns |
	1 to: 6 do: [ :i |
		memory addCorrection: 'Correction ', i asString
	].

	patterns := analyzer analyzeFeedbackPatterns. "Should detect frequent corrections pattern"

	self assert: (
		patterns anySatisfy: [ :p |
			(p at: 'pattern') = 'Frequent corrections'
		]
	)

]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> testAnalyzeFeedbackPatternsWithNoData [

	| patterns |
	patterns := analyzer analyzeFeedbackPatterns.

	"Should return empty collection when no feedback"
	self assert: patterns isEmpty
]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> testFeedbackSummary [

	| summary |
	memory addFeedback: 'Good' positive: true.
	memory addFeedback: 'Bad' positive: false.
	memory addCorrection: 'Fix this'.
	memory addUserPreference: 'Use tabs'.


	summary := analyzer feedbackSummary.

	self assert: (summary at: 'totalFeedback') equals: 2.
	self assert: (summary at: 'positiveFeedback') equals: 1.
	self assert: (summary at: 'negativeFeedback') equals: 1.
	self assert: (summary at: 'corrections') equals: 1.
	self assert: (summary at: 'preferences') equals: 1.
	self assert: (summary at: 'acceptanceRate') equals: 0.5
]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> testGenerateReport [

	| report |
	memory addFeedback: 'Good' positive: true.
	memory addFeedback: 'Bad' positive: false.
	report := analyzer generateReport.

	"Report should contain key sections"
	self assert: (report includesSubstring: 'Statistics').
	self assert: (report includesSubstring: 'Patterns Detected').
	self assert: (report includesSubstring: 'Recommendations').
	self assert: (report includesSubstring: 'Total feedback: 2')
]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> testImprovementRecommendationsWithLowAcceptance [

	"Add mostly negative feedback"
	| recommendations |
	memory addFeedback: 'Bad' positive: false.
	memory addFeedback: 'Not good' positive: false.
	memory addFeedback: 'Ok' positive: true.

	recommendations := analyzer improvementRecommendations.

	"Should provide recommendations for low acceptance"
	self deny: recommendations isEmpty.
	self assert: (recommendations anySatisfy: [ :rec |
			 rec includesSubstring: 'quality' ])
]

{ #category : 'running' }
ChatPharoFeedbackAnalyzerTest >> testRecentNegativeTrendDetection [

	"Add old positive feedback"
	10 timesRepeat: [
		| oldFeedback |
		oldFeedback := ChatPharoMemoryItem feedback: 'Good' positive: true.
		oldFeedback timestamp: DateAndTime now - 20 days.
		memory addMemory: oldFeedback ].

	"Add recent negative feedback"
	5 timesRepeat: [
		memory addFeedback: 'Bad' positive: false ].

	"Should detect negative trend"
	self assert: analyzer recentNegativeTrend
]
