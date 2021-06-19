module Ganymede.Runtime where

import qualified Data.Map as Map
import Ganymede.Types

data RuntimeValue = RuntimeNumber Double | RuntimeString String | RuntimeClosure (ActivationRecord, ProcedureDefinition)

data ActivationRecord = ActivationRecord {
    environment :: (Map String RuntimeValue)
}

class GanymedeEvaluable a where
    eval a = IO ()

instance GanymedeEvaluable Program where
    eval = 