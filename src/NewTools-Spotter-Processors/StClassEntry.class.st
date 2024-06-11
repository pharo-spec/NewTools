"
I wrap a Class or Trait entry, to modify its behavior if required for the class
"
Class {
	#name : 'StClassEntry',
	#superclass : 'StEntry',
	#category : 'NewTools-Spotter-Processors-Entries',
	#package : 'NewTools-Spotter-Processors',
	#tag : 'Entries'
}

{ #category : 'converting' }
StClassEntry >> asString [

	^ content name
]

{ #category : 'evaluating' }
StClassEntry >> doEvaluate [
	content browse
]

{ #category : 'accessing' }
StClassEntry >> iconName [

	^ content systemIconName
]
