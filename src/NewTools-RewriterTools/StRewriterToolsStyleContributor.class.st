"
Style contributed for RewriterTools
"
Class {
	#name : #StRewriterToolsStyleContributor,
	#superclass : #StPharoStyleContributor,
	#category : #'NewTools-RewriterTools-Style'
}

{ #category : #styles }
StRewriterToolsStyleContributor >> styleSheetContribution [

	^  SpStyleVariableSTONReader fromString: '.application [
	.bgOpaque [ Draw { #backgroundColor: EnvironmentColor(#base) } ]
]'
]
