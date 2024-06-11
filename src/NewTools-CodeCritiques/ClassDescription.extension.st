Extension { #name : 'ClassDescription' }

{ #category : '*NewTools-CodeCritiques' }
ClassDescription >> criticNameOn: aStream [
	"This behavior may be folded later by changing the name of this method or using another one."

	aStream << self name << ' (' << self package name << ')'
]
