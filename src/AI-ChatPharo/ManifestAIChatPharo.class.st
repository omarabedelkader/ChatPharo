"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestAIChatPharo',
	#superclass : 'PackageManifest',
	#category : 'AI-ChatPharo-Manifest',
	#package : 'AI-ChatPharo',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestAIChatPharo class >> ruleReTemporaryNeitherReadNorWrittenRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChatPharoIni #build #false)) #'2025-04-25T14:39:45.644629+02:00') )
]
