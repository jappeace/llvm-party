-- | Disambugiute DITemplateParameter's name record
module LLVM.AST.Operand.DITemplateParameter
( DITemplateParameter(..)
  , TemplateValueParameterTag(..)
  , Metadata(..)
)
where

import LLVM.Prelude

import LLVM.AST.Name
import LLVM.AST.Constant
import LLVM.AST.InlineAssembly
import LLVM.AST.Type

data TemplateValueParameterTag
  = TemplateValueParameter
  | GNUTemplateTemplateParam
  | GNUTemplateParameterPack
  deriving (Eq, Ord, Read, Show, Typeable, Data, Generic)

-- | <http://llvm.org/docs/LangRef.html#metadata>
data Metadata
  = MDString ShortByteString -- ^ <http://llvm.org/docs/doxygen/html/classllvm_1_1MDNode.html>
  | MDNode (MDRef MDNode) -- ^ <http://llvm.org/docs/doxygen/html/classllvm_1_1MDNode.html>
  | MDValue Operand -- ^ <http://llvm.org/docs/doxygen/html/classllvm_1_1ValueAsMetadata.html>
  deriving (Eq, Ord, Read, Show, Typeable, Data, Generic)

-- | <https://llvm.org/doxygen/classllvm_1_1DITemplateParameter.html>
data DITemplateParameter
  = DITemplateTypeParameter
    { name :: ShortByteString
    , type' :: Maybe (MDRef DIType)
    -- ^ For DITemplateTypeParameter this field is required,
    -- for DITemplateValueParameter it is optional.
    }
  -- ^ <https://llvm.org/docs/LangRef.html#ditemplatetypeparameter>
  | DITemplateValueParameter
    { name :: ShortByteString
    , type' :: Maybe (MDRef DIType)
    , value :: Maybe Metadata
    , tag :: TemplateValueParameterTag
    }
  -- ^ <https://llvm.org/docs/LangRef.html#ditemplatevalueparameter>
  deriving (Eq, Ord, Read, Show, Typeable, Data, Generic)
