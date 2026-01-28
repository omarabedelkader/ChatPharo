"
Analyzes user feedback patterns to identify areas for improvement.
Tracks acceptance/rejection rates, common patterns, and generates recommendations.
## Features:
- Calculates acceptance/rejection statistics
- Identifies common feedback patterns
- Generates improvement recommendations
- Tracks trends over time
- Exports analysis reports
## Usage:
```smalltalk
\""\""\""Get acceptance rate for suggestions\""\""\""
ChatPharoFeedbackAnalyzer default acceptanceRate.
\""\""\""Analyze feedback patterns\""\""\""
ChatPharoFeedbackAnalyzer default analyzeFeedbackPatterns.
\""\""\""Get improvement recommendations\""\""\""
ChatPharoFeedbackAnalyzer default improvementRecommendations.
\""\""\""Generate a comprehensive report\""\""\""
ChatPharoFeedbackAnalyzer default generateReport.
```
"
Class {
	#name : 'ChatPharoFeedbackAnalyzer',
	#superclass : 'Object',
	#instVars : [
		'memory'
	],
	#classInstVars : [
		'default'
	],
	#category : 'AI-ChatPharo-Memory',
	#package : 'AI-ChatPharo-Memory'
}

{ #category : 'accessing' }
ChatPharoFeedbackAnalyzer class >> default [
	"Return the default analyzer instance"

	^ default ifNil: [ default := self new ]
]

{ #category : 'accessing' }
ChatPharoFeedbackAnalyzer class >> reset [
	"Reset the default analyzer"

	<script>
	default := nil
]

{ #category : 'statistics' }
ChatPharoFeedbackAnalyzer >> acceptanceRate [
	"Calculate the acceptance rate for suggestions (positive feedback / total feedback)"

	| positiveFeedback totalFeedback |
	totalFeedback := self feedbackMemories.
	totalFeedback ifEmpty: [ ^ 0.0 ].

	positiveFeedback := totalFeedback select: [ :m |
		                    (m metadata at: 'positive' ifAbsent: [ false ]) = true ].

	^ (positiveFeedback size / totalFeedback size) asFloat
]

{ #category : 'analyzing' }
ChatPharoFeedbackAnalyzer >> analyzeFeedbackPatterns [
	"Analyze feedback patterns and return insights"

	| patterns positiveFeedback negativeFeedback corrections preferences |
	patterns := OrderedCollection new.

	positiveFeedback := self positiveFeedbackMemories.
	negativeFeedback := self negativeFeedbackMemories.
	corrections := self correctionMemories.
	preferences := self preferenceMemories.

	"Add pattern: High rejection rate"
	self acceptanceRate < 0.5 ifTrue: [
		patterns add: (Dictionary new
				 at: 'pattern' put: 'Low acceptance rate';
				 at: 'severity' put: 'high';
				 at: 'description' put: 'More than 50% of suggestions are rejected';
				 at: 'recommendation' put: 'Review and adjust suggestion quality';
				 yourself) ].

	"Add pattern: Many corrections"
	corrections size > 5 ifTrue: [
		patterns add: (Dictionary new
				 at: 'pattern' put: 'Frequent corrections';
				 at: 'severity' put: 'medium';
				 at: 'description' put: corrections size asString , ' corrections recorded';
				 at: 'recommendation' put: 'Analyze correction patterns to improve accuracy';
				 yourself) ].

	"Add pattern: Strong preferences"
	preferences size > 3 ifTrue: [
		patterns add: (Dictionary new
				 at: 'pattern' put: 'Strong user preferences';
				 at: 'severity' put: 'info';
				 at: 'description' put: preferences size asString , ' preferences recorded';
				 at: 'recommendation' put: 'Ensure preferences are consistently applied';
				 yourself) ].

	"Add pattern: Recent negative trend"
	(self recentNegativeTrend) ifTrue: [
		patterns add: (Dictionary new
				 at: 'pattern' put: 'Recent negative trend';
				 at: 'severity' put: 'high';
				 at: 'description' put: 'Increasing negative feedback in recent interactions';
				 at: 'recommendation' put: 'Review recent changes and adjust approach';
				 yourself) ].

	^ patterns
]

{ #category : 'statistics' }
ChatPharoFeedbackAnalyzer >> correctionMemories [
	"Return all correction memories"

	^ memory memoriesOfType: 'correction'
]

{ #category : 'private' }
ChatPharoFeedbackAnalyzer >> extractKeywordsFrom: aString [
	"Extract keywords from a string for topic analysis"

	| words stopWords |
	stopWords := #('the' 'a' 'an' 'and' 'or' 'but' 'is' 'was' 'are' 'were' 'to' 'from' 'in' 'on' 'at' 'for' 'with' 'by').
	words := aString asLowercase substrings.
	^ words reject: [ :word | (stopWords includes: word) or: [ word size < 4 ] ]
]

{ #category : 'statistics' }
ChatPharoFeedbackAnalyzer >> feedbackByTimeRange: daysBack [
	"Return feedback from the last N days"

	| cutoffDate |
	cutoffDate := DateAndTime now - daysBack days.
	^ self feedbackMemories select: [ :m |
		  m timestamp >= cutoffDate ]
]

{ #category : 'private' }
ChatPharoFeedbackAnalyzer >> feedbackMemories [
	"Return all feedback memories"

	^ memory memoriesOfType: 'feedback'
]

{ #category : 'statistics' }
ChatPharoFeedbackAnalyzer >> feedbackSummary [
	"Return a summary of all feedback statistics"

	^ Dictionary new
		  at: 'totalFeedback' put: self feedbackMemories size;
		  at: 'positiveFeedback' put: self positiveFeedbackMemories size;
		  at: 'negativeFeedback' put: self negativeFeedbackMemories size;
		  at: 'acceptanceRate' put: self acceptanceRate;
		  at: 'corrections' put: self correctionMemories size;
		  at: 'preferences' put: self preferenceMemories size;
		  at: 'recentTrend' put: (self recentNegativeTrend
				   ifTrue: [ 'negative' ]
				   ifFalse: [ 'stable' ]);
		  yourself
]

{ #category : 'reporting' }
ChatPharoFeedbackAnalyzer >> generateReport [
	"Generate a comprehensive feedback analysis report"

	| report |
	report := String streamContents: [ :stream |
		          | summary patterns recommendations |
		          stream
			          nextPutAll: '=== ChatPharo Feedback Analysis Report ===';
			          cr;
			          cr. "Summary statistics"
		          summary := self feedbackSummary.
		          stream
			          nextPutAll: '## Statistics';
			          cr;
			          nextPutAll: 'Total feedback: ' , (summary at: 'totalFeedback') asString;
			          cr;
			          nextPutAll: 'Positive: ' , (summary at: 'positiveFeedback') asString;
			          cr;
			          nextPutAll: 'Negative: ' , (summary at: 'negativeFeedback') asString;
			          cr;
			          nextPutAll: 'Acceptance rate: '
				          , ((summary at: 'acceptanceRate') * 100) printShowingDecimalPlaces: 1;
			          nextPutAll: '%';
			          cr;
			          nextPutAll: 'Corrections: ' , (summary at: 'corrections') asString;
			          cr;
			          nextPutAll: 'Preferences: ' , (summary at: 'preferences') asString;
			          cr;
			          cr. "Patterns"
		          patterns := self analyzeFeedbackPatterns.
		          stream
			          nextPutAll: '## Patterns Detected';
			          cr.
		          patterns ifEmpty: [
			          stream
				          nextPutAll: 'No significant patterns detected.';
				          cr ].
		          patterns do: [ :pattern |
			          stream
				          nextPutAll: '- [' , (pattern at: 'severity') asUppercase , '] ';
				          nextPutAll: (pattern at: 'pattern');
				          cr;
				          nextPutAll: '  ' , (pattern at: 'description');
				          cr ].
		          stream cr. "Recommendations"
		          recommendations := self improvementRecommendations.
		          stream
			          nextPutAll: '## Recommendations';
			          cr.
		          recommendations ifEmpty: [
			          stream
				          nextPutAll: 'No specific recommendations at this time.';
				          cr ].
		          recommendations do: [ :rec |
			          stream
				          nextPutAll: '• ';
				          nextPutAll: rec;
				          cr ].
		          stream cr.
		          stream
			          nextPutAll: '=== End of Report ===';
			          cr ].

	^ report
]

{ #category : 'analyzing' }
ChatPharoFeedbackAnalyzer >> improvementRecommendations [
	"Generate specific improvement recommendations based on feedback"

	| recommendations patterns |
	recommendations := OrderedCollection new.
	patterns := self analyzeFeedbackPatterns.

	patterns do: [ :pattern |
		recommendations add: (pattern at: 'recommendation') ].

	"Add general recommendations based on statistics"
	self acceptanceRate < 0.7 ifTrue: [
		recommendations add: 'Consider reviewing the quality and relevance of suggestions' ].

	self correctionMemories size > 10 ifTrue: [
		recommendations add: 'Review common correction patterns to prevent recurring mistakes' ].

	self preferenceMemories size > 5 ifTrue: [
		recommendations add: 'Create a preference profile to automatically apply user preferences' ].

	^ recommendations
]

{ #category : 'analyzing' }
ChatPharoFeedbackAnalyzer >> initialize [

	super initialize.
	memory := ChatPharoMemory default
]

{ #category : 'statistics' }
ChatPharoFeedbackAnalyzer >> mostCommonFeedbackTopics [
	"Identify the most common topics in feedback"

	| topicCounts |
	topicCounts := Dictionary new.

	self feedbackMemories do: [ :feedback |
		| keywords |
		keywords := self extractKeywordsFrom: feedback content.
		keywords do: [ :keyword |
			topicCounts
				at: keyword
				put: (topicCounts at: keyword ifAbsent: [ 0 ]) + 1 ] ].

	^ (topicCounts associations sorted: [ :a :b | a value > b value ]) first: (5 min: topicCounts size)
]

{ #category : 'private' }
ChatPharoFeedbackAnalyzer >> negativeFeedbackMemories [
	"Return all negative feedback memories"

	^ self feedbackMemories select: [ :m |
		  (m metadata at: 'positive' ifAbsent: [ false ]) = false ]
]

{ #category : 'private' }
ChatPharoFeedbackAnalyzer >> positiveFeedbackMemories [
	"Return all positive feedback memories"

	^ self feedbackMemories select: [ :m |
		  (m metadata at: 'positive' ifAbsent: [ false ]) = true ]
]

{ #category : 'private' }
ChatPharoFeedbackAnalyzer >> preferenceMemories [
	"Return all user preference memories"

	^ memory memoriesOfType: 'user_preference'
]

{ #category : 'private' }
ChatPharoFeedbackAnalyzer >> recentNegativeTrend [
	"Check if there's a recent negative trend in feedback"

	| recentFeedback olderFeedback recentNegativeRate olderNegativeRate |
	recentFeedback := self feedbackByTimeRange: 7.
	olderFeedback := self feedbackByTimeRange: 30.

	recentFeedback size < 3 ifTrue: [ ^ false ]. "Not enough data"

	recentNegativeRate := (recentFeedback select: [ :m |
		                       (m metadata at: 'positive' ifAbsent: [ false ]) = false ]) size
	                      / recentFeedback size asFloat.

	olderFeedback := olderFeedback reject: [ :m | recentFeedback includes: m ].
	olderFeedback ifEmpty: [ ^ recentNegativeRate > 0.5 ]. "No history, just check recent"

	olderNegativeRate := (olderFeedback select: [ :m |
		                      (m metadata at: 'positive' ifAbsent: [ false ]) = false ]) size
	                     / olderFeedback size asFloat.

	"Trend is negative if recent rate is significantly worse"
	^ recentNegativeRate > (olderNegativeRate + 0.2)
]
