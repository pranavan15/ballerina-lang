// This is an auto-generated file. Do not edit.
// Run 'BALLERINA_HOME="your/ballerina/home" npm run gen-ast-utils' to generate.
import { ASTNode } from "./ast-interfaces";

export class ASTKindChecker {
  public static isAbort(node: ASTNode) {
    return node.kind === "Abort";
  }

  public static isAnnotation(node: ASTNode) {
    return node.kind === "Annotation";
  }

  public static isAnnotationAttachment(node: ASTNode) {
    return node.kind === "AnnotationAttachment";
  }

  public static isArrayLiteralExpr(node: ASTNode) {
    return node.kind === "ArrayLiteralExpr";
  }

  public static isArrayType(node: ASTNode) {
    return node.kind === "ArrayType";
  }

  public static isArrowExpr(node: ASTNode) {
    return node.kind === "ArrowExpr";
  }

  public static isAssignment(node: ASTNode) {
    return node.kind === "Assignment";
  }

  public static isBinaryExpr(node: ASTNode) {
    return node.kind === "BinaryExpr";
  }

  public static isBlock(node: ASTNode) {
    return node.kind === "Block";
  }

  public static isBracedTupleExpr(node: ASTNode) {
    return node.kind === "BracedTupleExpr";
  }

  public static isBreak(node: ASTNode) {
    return node.kind === "Break";
  }

  public static isBuiltInRefType(node: ASTNode) {
    return node.kind === "BuiltInRefType";
  }

  public static isCatch(node: ASTNode) {
    return node.kind === "Catch";
  }

  public static isCheckExpr(node: ASTNode) {
    return node.kind === "CheckExpr";
  }

  public static isCompilationUnit(node: ASTNode) {
    return node.kind === "CompilationUnit";
  }

  public static isCompoundAssignment(node: ASTNode) {
    return node.kind === "CompoundAssignment";
  }

  public static isConstant(node: ASTNode) {
    return node.kind === "Constant";
  }

  public static isConstrainedType(node: ASTNode) {
    return node.kind === "ConstrainedType";
  }

  public static isDeprecated(node: ASTNode) {
    return node.kind === "Deprecated";
  }

  public static isDocumentationDescription(node: ASTNode) {
    return node.kind === "DocumentationDescription";
  }

  public static isDocumentationParameter(node: ASTNode) {
    return node.kind === "DocumentationParameter";
  }

  public static isElvisExpr(node: ASTNode) {
    return node.kind === "ElvisExpr";
  }

  public static isErrorConstructor(node: ASTNode) {
    return node.kind === "ErrorConstructor";
  }

  public static isErrorType(node: ASTNode) {
    return node.kind === "ErrorType";
  }

  public static isExpressionStatement(node: ASTNode) {
    return node.kind === "ExpressionStatement";
  }

  public static isFieldBasedAccessExpr(node: ASTNode) {
    return node.kind === "FieldBasedAccessExpr";
  }

  public static isFiniteTypeNode(node: ASTNode) {
    return node.kind === "FiniteTypeNode";
  }

  public static isForeach(node: ASTNode) {
    return node.kind === "Foreach";
  }

  public static isForever(node: ASTNode) {
    return node.kind === "Forever";
  }

  public static isForkJoin(node: ASTNode) {
    return node.kind === "ForkJoin";
  }

  public static isFunction(node: ASTNode) {
    return node.kind === "Function";
  }

  public static isFunctionType(node: ASTNode) {
    return node.kind === "FunctionType";
  }

  public static isGroupBy(node: ASTNode) {
    return node.kind === "GroupBy";
  }

  public static isHaving(node: ASTNode) {
    return node.kind === "Having";
  }

  public static isIdentifier(node: ASTNode) {
    return node.kind === "Identifier";
  }

  public static isIf(node: ASTNode) {
    return node.kind === "If";
  }

  public static isImport(node: ASTNode) {
    return node.kind === "Import";
  }

  public static isIndexBasedAccessExpr(node: ASTNode) {
    return node.kind === "IndexBasedAccessExpr";
  }

  public static isIntRangeExpr(node: ASTNode) {
    return node.kind === "IntRangeExpr";
  }

  public static isInvocation(node: ASTNode) {
    return node.kind === "Invocation";
  }

  public static isJoinStreamingInput(node: ASTNode) {
    return node.kind === "JoinStreamingInput";
  }

  public static isLambda(node: ASTNode) {
    return node.kind === "Lambda";
  }

  public static isLimit(node: ASTNode) {
    return node.kind === "Limit";
  }

  public static isLiteral(node: ASTNode) {
    return node.kind === "Literal";
  }

  public static isLock(node: ASTNode) {
    return node.kind === "Lock";
  }

  public static isMarkdownDocumentation(node: ASTNode) {
    return node.kind === "MarkdownDocumentation";
  }

  public static isMatch(node: ASTNode) {
    return node.kind === "Match";
  }

  public static isMatchStaticPatternClause(node: ASTNode) {
    return node.kind === "MatchStaticPatternClause";
  }

  public static isMatchStructuredPatternClause(node: ASTNode) {
    return node.kind === "MatchStructuredPatternClause";
  }

  public static isNamedArgsExpr(node: ASTNode) {
    return node.kind === "NamedArgsExpr";
  }

  public static isNext(node: ASTNode) {
    return node.kind === "Next";
  }

  public static isObjectType(node: ASTNode) {
    return node.kind === "ObjectType";
  }

  public static isOrderBy(node: ASTNode) {
    return node.kind === "OrderBy";
  }

  public static isOrderByVariable(node: ASTNode) {
    return node.kind === "OrderByVariable";
  }

  public static isOutputRateLimit(node: ASTNode) {
    return node.kind === "OutputRateLimit";
  }

  public static isPanic(node: ASTNode) {
    return node.kind === "Panic";
  }

  public static isPatternClause(node: ASTNode) {
    return node.kind === "PatternClause";
  }

  public static isPatternStreamingEdgeInput(node: ASTNode) {
    return node.kind === "PatternStreamingEdgeInput";
  }

  public static isPatternStreamingInput(node: ASTNode) {
    return node.kind === "PatternStreamingInput";
  }

  public static isRecordDestructure(node: ASTNode) {
    return node.kind === "RecordDestructure";
  }

  public static isRecordLiteralExpr(node: ASTNode) {
    return node.kind === "RecordLiteralExpr";
  }

  public static isRecordLiteralKeyValue(node: ASTNode) {
    return node.kind === "RecordLiteralKeyValue";
  }

  public static isRecordType(node: ASTNode) {
    return node.kind === "RecordType";
  }

  public static isRecordVariable(node: ASTNode) {
    return node.kind === "RecordVariable";
  }

  public static isRecordVariableRef(node: ASTNode) {
    return node.kind === "RecordVariableRef";
  }

  public static isRestArgsExpr(node: ASTNode) {
    return node.kind === "RestArgsExpr";
  }

  public static isRetry(node: ASTNode) {
    return node.kind === "Retry";
  }

  public static isReturn(node: ASTNode) {
    return node.kind === "Return";
  }

  public static isSelectClause(node: ASTNode) {
    return node.kind === "SelectClause";
  }

  public static isSelectExpression(node: ASTNode) {
    return node.kind === "SelectExpression";
  }

  public static isService(node: ASTNode) {
    return node.kind === "Service";
  }

  public static isServiceConstructor(node: ASTNode) {
    return node.kind === "ServiceConstructor";
  }

  public static isSimpleVariableRef(node: ASTNode) {
    return node.kind === "SimpleVariableRef";
  }

  public static isStreamAction(node: ASTNode) {
    return node.kind === "StreamAction";
  }

  public static isStreamingInput(node: ASTNode) {
    return node.kind === "StreamingInput";
  }

  public static isStreamingQuery(node: ASTNode) {
    return node.kind === "StreamingQuery";
  }

  public static isStringTemplateLiteral(node: ASTNode) {
    return node.kind === "StringTemplateLiteral";
  }

  public static isTable(node: ASTNode) {
    return node.kind === "Table";
  }

  public static isTableColumn(node: ASTNode) {
    return node.kind === "TableColumn";
  }

  public static isTableQuery(node: ASTNode) {
    return node.kind === "TableQuery";
  }

  public static isTableQueryExpression(node: ASTNode) {
    return node.kind === "TableQueryExpression";
  }

  public static isTernaryExpr(node: ASTNode) {
    return node.kind === "TernaryExpr";
  }

  public static isTransaction(node: ASTNode) {
    return node.kind === "Transaction";
  }

  public static isTrapExpr(node: ASTNode) {
    return node.kind === "TrapExpr";
  }

  public static isTry(node: ASTNode) {
    return node.kind === "Try";
  }

  public static isTupleDestructure(node: ASTNode) {
    return node.kind === "TupleDestructure";
  }

  public static isTupleTypeNode(node: ASTNode) {
    return node.kind === "TupleTypeNode";
  }

  public static isTupleVariable(node: ASTNode) {
    return node.kind === "TupleVariable";
  }

  public static isTupleVariableRef(node: ASTNode) {
    return node.kind === "TupleVariableRef";
  }

  public static isTypeConversionExpr(node: ASTNode) {
    return node.kind === "TypeConversionExpr";
  }

  public static isTypeDefinition(node: ASTNode) {
    return node.kind === "TypeDefinition";
  }

  public static isTypeInitExpr(node: ASTNode) {
    return node.kind === "TypeInitExpr";
  }

  public static isTypeTestExpr(node: ASTNode) {
    return node.kind === "TypeTestExpr";
  }

  public static isTypedescExpression(node: ASTNode) {
    return node.kind === "TypedescExpression";
  }

  public static isUnaryExpr(node: ASTNode) {
    return node.kind === "UnaryExpr";
  }

  public static isUnionTypeNode(node: ASTNode) {
    return node.kind === "UnionTypeNode";
  }

  public static isUserDefinedType(node: ASTNode) {
    return node.kind === "UserDefinedType";
  }

  public static isValueType(node: ASTNode) {
    return node.kind === "ValueType";
  }

  public static isVariable(node: ASTNode) {
    return node.kind === "Variable";
  }

  public static isVariableDef(node: ASTNode) {
    return node.kind === "VariableDef";
  }

  public static isVisibleEndpoint(node: ASTNode) {
    return node.kind === "VisibleEndpoint";
  }

  public static isWaitExpr(node: ASTNode) {
    return node.kind === "WaitExpr";
  }

  public static isWaitLiteralKeyValue(node: ASTNode) {
    return node.kind === "WaitLiteralKeyValue";
  }

  public static isWhere(node: ASTNode) {
    return node.kind === "Where";
  }

  public static isWhile(node: ASTNode) {
    return node.kind === "While";
  }

  public static isWindowClause(node: ASTNode) {
    return node.kind === "WindowClause";
  }

  public static isWithin(node: ASTNode) {
    return node.kind === "Within";
  }

  public static isWorkerFlush(node: ASTNode) {
    return node.kind === "WorkerFlush";
  }

  public static isWorkerReceive(node: ASTNode) {
    return node.kind === "WorkerReceive";
  }

  public static isWorkerSend(node: ASTNode) {
    return node.kind === "WorkerSend";
  }

  public static isWorkerSyncSend(node: ASTNode) {
    return node.kind === "WorkerSyncSend";
  }

  public static isXmlAttribute(node: ASTNode) {
    return node.kind === "XmlAttribute";
  }

  public static isXmlAttributeAccessExpr(node: ASTNode) {
    return node.kind === "XmlAttributeAccessExpr";
  }

  public static isXmlCommentLiteral(node: ASTNode) {
    return node.kind === "XmlCommentLiteral";
  }

  public static isXmlElementLiteral(node: ASTNode) {
    return node.kind === "XmlElementLiteral";
  }

  public static isXmlPiLiteral(node: ASTNode) {
    return node.kind === "XmlPiLiteral";
  }

  public static isXmlQname(node: ASTNode) {
    return node.kind === "XmlQname";
  }

  public static isXmlQuotedString(node: ASTNode) {
    return node.kind === "XmlQuotedString";
  }

  public static isXmlTextLiteral(node: ASTNode) {
    return node.kind === "XmlTextLiteral";
  }

  public static isXmlns(node: ASTNode) {
    return node.kind === "Xmlns";
  }
}
