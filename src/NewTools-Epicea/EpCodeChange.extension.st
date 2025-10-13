Extension { #name : 'EpCodeChange' }

{ #category : '*NewTools-Epicea' }
EpCodeChange >> applyCodeChange [
	"Apply this code change in current image"

	^ self accept: EpApplyVisitor new
]

{ #category : '*NewTools-Epicea' }
EpCodeChange >> asRevertedCodeChange [
	"Answer a code change that represents my inverse operation. For example, a class addition will answer a class removal."

	^ self accept: EpInverseVisitor new
]

{ #category : '*NewTools-Epicea' }
EpCodeChange >> previewedApplyEvents [

	^ self accept: EpApplyPreviewer new
]
