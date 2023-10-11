"
I wrap a CompiledMethod, to modify its behavior if required for the class
"
Class {
	#name : 'StMethodEntry',
	#superclass : 'StEntry',
	#category : 'NewTools-Spotter-Processors-Entries',
	#package : 'NewTools-Spotter-Processors',
	#tag : 'Entries'
}

{ #category : 'converting' }
StMethodEntry >> asString [

	^ content selector
]

{ #category : 'evaluating' }
StMethodEntry >> doEvaluate [

	^ content browse
]

{ #category : 'accessing' }
StMethodEntry >> iconName [

	^ content systemIconName
]

{ #category : 'accessing' }
StMethodEntry >> label [

	^ content printString
]
