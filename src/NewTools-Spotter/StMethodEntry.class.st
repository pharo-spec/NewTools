"
I wrap a CompiledMethod, to modify its behavior if required for the class
"
Class {
	#name : 'StMethodEntry',
	#superclass : 'StEntry',
	#category : 'NewTools-Spotter-Entries',
	#package : 'NewTools-Spotter',
	#tag : 'Entries'
}

{ #category : 'accessing' }
StMethodEntry >> accept: aSpotter [

	aSpotter visitMethodEntry: self
]

{ #category : 'converting' }
StMethodEntry >> asHistoryEntry [

	^ StHistoryMethodEntry new: self
]

{ #category : 'converting' }
StMethodEntry >> asString [

	^ content selector
]

{ #category : 'accessing' }
StMethodEntry >> categoryLabel [

	^ 'method'
]

{ #category : 'evaluating' }
StMethodEntry >> doEvaluate [

	content browse
]

{ #category : 'accessing' }
StMethodEntry >> iconName [

	^ content systemIconName
]

{ #category : 'accessing' }
StMethodEntry >> label [

	^ content printString
]
