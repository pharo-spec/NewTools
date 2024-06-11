"
Style contributed for RewriterTools
"
Class {
	#name : 'StRewriterToolsStyleContributor',
	#superclass : 'StPharoStyleContributor',
	#category : 'NewTools-RewriterTools-Style',
	#package : 'NewTools-RewriterTools',
	#tag : 'Style'
}

{ #category : 'styles' }
StRewriterToolsStyleContributor >> styleSheetContribution [

	^  SpStyleVariableSTONReader fromString: '.application [
	.bgOpaque [ Draw { #backgroundColor: EnvironmentColor(#base) } ]
]'
]
