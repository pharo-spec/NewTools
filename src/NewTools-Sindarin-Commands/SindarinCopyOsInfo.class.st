Class {
	#name : 'SindarinCopyOsInfo',
	#superclass : 'SindarinCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'default' }
SindarinCopyOsInfo class >> defaultDescription [

 ^ 'Copy to clipboard system information and Pharo image version'
]

{ #category : 'initialization' }
SindarinCopyOsInfo class >> defaultIconName [
	^#smallCopy
]

{ #category : 'default' }
SindarinCopyOsInfo class >> defaultName [
<toolbarExtensionDebugCommand: 50>
<codeExtensionDebugCommand:1 >
	^ 'Copy system information'
]

{ #category : 'executing' }
SindarinCopyOsInfo >> execute [ 

Clipboard clipboardText: self systemInfo.
]

{ #category : 'as yet unclassified' }
SindarinCopyOsInfo >> systemInfo [

	^ Smalltalk os platformName,
	 Smalltalk os version ,
	 Character space asString ,
	 Smalltalk os subtype ,
	 Character cr asString,
	 Smalltalk image lastUpdateString
]
