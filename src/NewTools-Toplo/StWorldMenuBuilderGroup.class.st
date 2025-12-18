Class {
	#name : 'StWorldMenuBuilderGroup',
	#superclass : 'StWorldMenuBuilderItem',
	#category : 'NewTools-Toplo-Backend',
	#package : 'NewTools-Toplo',
	#tag : 'Backend'
}

{ #category : 'visiting' }
StWorldMenuBuilderGroup >> acceptVisitor: aVisitor [

	^ aVisitor visitGroup: self
]
