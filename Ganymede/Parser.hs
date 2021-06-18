module Ganymede.Parser where
import Ganymede.Types
import Text.Parsec
import qualified Text.Parsec.Token as Token
import Text.Parsec.Language


languageDef = emptyDef {
    Token.identStart = letter,
    Token.identLetter = alphaNum,
    Token.commentStart = "/*",
    Token.commentEnd = "*/",
    Token.reservedNames = [],
    Token.reservedOpNames = ["->", "=>", "."]
}

lexer = Token.makeTokenParser languageDef

identifier  = Token.identifier      lexer
reserved    = Token.reserved        lexer
reservedOp  = Token.reservedOp      lexer
integer     = Token.integer         lexer
semi        = Token.semi            lexer
whiteSpace  = Token.whiteSpace      lexer
stringLiteral = Token.stringLiteral lexer
float       = Token.float           lexer

program = do
    decls <- declarations
    call <- procedureCall
    return $ Program decls call

declarations = sepBy declaration (reservedOp ".")

declaration = do
    reserved "declare"
    whiteSpace
    id <- identifier
    whiteSpace
    expr <- expression
    return $ Declaration (Identifier id) expr

callable = ((identifier >>= return . IdentifierCall . Identifier) <|> (procedureDefinition >>= return . ProcedureLiteralCall) <|> (parametricDefinition >>= return . ParametricLiteralCall))

procedureDefinition = do
    reservedOp ";"
    call <- procedureCall
    return $ ProcedureDefinition call

procedureCall = do
    proc <- callable
    args <- actualParams
    return $ ProcedureCall proc args

parametricDefinition = parametricDefinitionSimple <|> parametricDefinitionSugared

parametricDefinitionSimple = do
    reservedOp "->"
    params <- formalParams
    proc <- procedureDefinition
    return $ ParametricDefinition params proc

parametricDefinitionSugared = do
    reservedOp "=>"
    params <- formalParams
    proc <- procedureDefinition
    reservedOp "."
    return $ ParametricDefinition (params ++ [Identifier "continue"]) proc

formalParams = sepBy (identifier >>= return . Identifier) whiteSpace

actualParams = sepBy expression whiteSpace

expression = 
           (identifier >>= return . IdentifierExpression . Identifier)
           <|>
           (literal >>= return . LiteralExpression)

literal = (stringLiteral >>= return . StringLiteral)
          <|>
          (float >>= return . NumberLiteral)
          <|>
          (procedureDefinition >>= return . ProcedureLiteral)
          <|>
          (parametricDefinition >>= return . ParametricLiteral)
