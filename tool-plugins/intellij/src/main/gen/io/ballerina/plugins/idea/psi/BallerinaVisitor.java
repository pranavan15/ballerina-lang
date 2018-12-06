/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

// This is a generated file. Not intended for manual editing.
package io.ballerina.plugins.idea.psi;

import org.jetbrains.annotations.*;
import com.intellij.psi.PsiElementVisitor;
import io.ballerina.plugins.idea.psi.impl.BallerinaTopLevelDefinition;

public class BallerinaVisitor extends PsiElementVisitor {

  public void visitAbortStatement(@NotNull BallerinaAbortStatement o) {
    visitCompositeElement(o);
  }

  public void visitAbortedClause(@NotNull BallerinaAbortedClause o) {
    visitCompositeElement(o);
  }

  public void visitActionInvocation(@NotNull BallerinaActionInvocation o) {
    visitCompositeElement(o);
  }

  public void visitActionInvocationExpression(@NotNull BallerinaActionInvocationExpression o) {
    visitExpression(o);
  }

  public void visitAlias(@NotNull BallerinaAlias o) {
    visitNamedElement(o);
  }

  public void visitAnnotationAttachment(@NotNull BallerinaAnnotationAttachment o) {
    visitCompositeElement(o);
  }

  public void visitAnnotationDefinition(@NotNull BallerinaAnnotationDefinition o) {
    visitNamedElement(o);
    // visitTopLevelDefinition(o);
  }

  public void visitAnyDataTypeName(@NotNull BallerinaAnyDataTypeName o) {
    visitCompositeElement(o);
  }

  public void visitAnyIdentifierName(@NotNull BallerinaAnyIdentifierName o) {
    visitCompositeElement(o);
  }

  public void visitAnyTypeName(@NotNull BallerinaAnyTypeName o) {
    visitCompositeElement(o);
  }

  public void visitArrayLiteral(@NotNull BallerinaArrayLiteral o) {
    visitCompositeElement(o);
  }

  public void visitArrayLiteralExpression(@NotNull BallerinaArrayLiteralExpression o) {
    visitExpression(o);
  }

  public void visitArrayTypeName(@NotNull BallerinaArrayTypeName o) {
    visitTypeName(o);
  }

  public void visitArrowFunction(@NotNull BallerinaArrowFunction o) {
    visitCompositeElement(o);
  }

  public void visitArrowFunctionExpression(@NotNull BallerinaArrowFunctionExpression o) {
    visitExpression(o);
  }

  public void visitArrowParam(@NotNull BallerinaArrowParam o) {
    visitCompositeElement(o);
  }

  public void visitAssignmentStatement(@NotNull BallerinaAssignmentStatement o) {
    visitCompositeElement(o);
  }

  public void visitAttachedObject(@NotNull BallerinaAttachedObject o) {
    visitCompositeElement(o);
  }

  public void visitAttachmentPoint(@NotNull BallerinaAttachmentPoint o) {
    visitCompositeElement(o);
  }

  public void visitAttribute(@NotNull BallerinaAttribute o) {
    visitCompositeElement(o);
  }

  public void visitBinaryAddSubExpression(@NotNull BallerinaBinaryAddSubExpression o) {
    visitBinaryExpression(o);
  }

  public void visitBinaryAndExpression(@NotNull BallerinaBinaryAndExpression o) {
    visitBinaryExpression(o);
  }

  public void visitBinaryCompareExpression(@NotNull BallerinaBinaryCompareExpression o) {
    visitBinaryExpression(o);
  }

  public void visitBinaryDivMulModExpression(@NotNull BallerinaBinaryDivMulModExpression o) {
    visitBinaryExpression(o);
  }

  public void visitBinaryEqualExpression(@NotNull BallerinaBinaryEqualExpression o) {
    visitBinaryExpression(o);
  }

  public void visitBinaryExpression(@NotNull BallerinaBinaryExpression o) {
    visitExpression(o);
  }

  public void visitBinaryOrExpression(@NotNull BallerinaBinaryOrExpression o) {
    visitBinaryExpression(o);
  }

  public void visitBinaryRefEqualExpression(@NotNull BallerinaBinaryRefEqualExpression o) {
    visitExpression(o);
  }

  public void visitBindingPattern(@NotNull BallerinaBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitBindingRefPattern(@NotNull BallerinaBindingRefPattern o) {
    visitCompositeElement(o);
  }

  public void visitBitwiseExpression(@NotNull BallerinaBitwiseExpression o) {
    visitExpression(o);
  }

  public void visitBitwiseShiftExpression(@NotNull BallerinaBitwiseShiftExpression o) {
    visitExpression(o);
  }

  public void visitBlobLiteral(@NotNull BallerinaBlobLiteral o) {
    visitCompositeElement(o);
  }

  public void visitBlock(@NotNull BallerinaBlock o) {
    visitCompositeElement(o);
  }

  public void visitBracedOrTupleExpression(@NotNull BallerinaBracedOrTupleExpression o) {
    visitExpression(o);
  }

  public void visitBreakStatement(@NotNull BallerinaBreakStatement o) {
    visitCompositeElement(o);
  }

  public void visitBuiltInReferenceTypeName(@NotNull BallerinaBuiltInReferenceTypeName o) {
    visitCompositeElement(o);
  }

  public void visitCallableUnitBody(@NotNull BallerinaCallableUnitBody o) {
    visitCompositeElement(o);
  }

  public void visitCallableUnitSignature(@NotNull BallerinaCallableUnitSignature o) {
    visitCompositeElement(o);
  }

  public void visitCatchClause(@NotNull BallerinaCatchClause o) {
    visitCompositeElement(o);
  }

  public void visitCatchClauses(@NotNull BallerinaCatchClauses o) {
    visitCompositeElement(o);
  }

  public void visitCheckedExpression(@NotNull BallerinaCheckedExpression o) {
    visitExpression(o);
  }

  public void visitCloseTag(@NotNull BallerinaCloseTag o) {
    visitCompositeElement(o);
  }

  public void visitComment(@NotNull BallerinaComment o) {
    visitCompositeElement(o);
  }

  public void visitCommittedAbortedClauses(@NotNull BallerinaCommittedAbortedClauses o) {
    visitCompositeElement(o);
  }

  public void visitCommittedClause(@NotNull BallerinaCommittedClause o) {
    visitCompositeElement(o);
  }

  public void visitCompletePackageName(@NotNull BallerinaCompletePackageName o) {
    visitCompositeElement(o);
  }

  public void visitCompoundAssignmentStatement(@NotNull BallerinaCompoundAssignmentStatement o) {
    visitCompositeElement(o);
  }

  public void visitCompoundOperator(@NotNull BallerinaCompoundOperator o) {
    visitCompositeElement(o);
  }

  public void visitConstantDefinition(@NotNull BallerinaConstantDefinition o) {
    visitCompositeElement(o);
  }

  public void visitContent(@NotNull BallerinaContent o) {
    visitCompositeElement(o);
  }

  public void visitContinueStatement(@NotNull BallerinaContinueStatement o) {
    visitCompositeElement(o);
  }

  public void visitDefaultableParameter(@NotNull BallerinaDefaultableParameter o) {
    visitCompositeElement(o);
  }

  public void visitDefinition(@NotNull BallerinaDefinition o) {
    visitCompositeElement(o);
  }

  public void visitElement(@NotNull BallerinaElement o) {
    visitCompositeElement(o);
  }

  public void visitElseClause(@NotNull BallerinaElseClause o) {
    visitCompositeElement(o);
  }

  public void visitElseIfClause(@NotNull BallerinaElseIfClause o) {
    visitCompositeElement(o);
  }

  public void visitElvisExpression(@NotNull BallerinaElvisExpression o) {
    visitExpression(o);
  }

  public void visitEmptyTag(@NotNull BallerinaEmptyTag o) {
    visitCompositeElement(o);
  }

  public void visitEmptyTupleLiteral(@NotNull BallerinaEmptyTupleLiteral o) {
    visitCompositeElement(o);
  }

  public void visitEntryBindingPattern(@NotNull BallerinaEntryBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitEntryRefBindingPattern(@NotNull BallerinaEntryRefBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitErrorBindingPattern(@NotNull BallerinaErrorBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitErrorConstructorExpression(@NotNull BallerinaErrorConstructorExpression o) {
    visitExpression(o);
  }

  public void visitErrorDestructuringStatement(@NotNull BallerinaErrorDestructuringStatement o) {
    visitCompositeElement(o);
  }

  public void visitErrorRefBindingPattern(@NotNull BallerinaErrorRefBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitErrorTypeName(@NotNull BallerinaErrorTypeName o) {
    visitCompositeElement(o);
  }

  public void visitExpression(@NotNull BallerinaExpression o) {
    visitCompositeElement(o);
  }

  public void visitExpressionList(@NotNull BallerinaExpressionList o) {
    visitCompositeElement(o);
  }

  public void visitExpressionStmt(@NotNull BallerinaExpressionStmt o) {
    visitCompositeElement(o);
  }

  public void visitField(@NotNull BallerinaField o) {
    visitCompositeElement(o);
  }

  public void visitFieldBindingPattern(@NotNull BallerinaFieldBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitFieldDefinition(@NotNull BallerinaFieldDefinition o) {
    visitCompositeElement(o);
  }

  public void visitFieldRefBindingPattern(@NotNull BallerinaFieldRefBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitFieldVariableReference(@NotNull BallerinaFieldVariableReference o) {
    visitVariableReference(o);
  }

  public void visitFinallyClause(@NotNull BallerinaFinallyClause o) {
    visitCompositeElement(o);
  }

  public void visitFiniteType(@NotNull BallerinaFiniteType o) {
    visitCompositeElement(o);
  }

  public void visitFiniteTypeUnit(@NotNull BallerinaFiniteTypeUnit o) {
    visitCompositeElement(o);
  }

  public void visitFloatingPointLiteral(@NotNull BallerinaFloatingPointLiteral o) {
    visitCompositeElement(o);
  }

  public void visitFlushWorker(@NotNull BallerinaFlushWorker o) {
    visitCompositeElement(o);
  }

  public void visitFlushWorkerExpression(@NotNull BallerinaFlushWorkerExpression o) {
    visitExpression(o);
  }

  public void visitForeachStatement(@NotNull BallerinaForeachStatement o) {
    visitCompositeElement(o);
  }

  public void visitForeverStatement(@NotNull BallerinaForeverStatement o) {
    visitCompositeElement(o);
  }

  public void visitForeverStatementBody(@NotNull BallerinaForeverStatementBody o) {
    visitCompositeElement(o);
  }

  public void visitForkJoinStatement(@NotNull BallerinaForkJoinStatement o) {
    visitCompositeElement(o);
  }

  public void visitFormalParameterList(@NotNull BallerinaFormalParameterList o) {
    visitCompositeElement(o);
  }

  public void visitFunctionDefinition(@NotNull BallerinaFunctionDefinition o) {
    visitNamedElement(o);
    // visitTopLevelDefinition(o);
  }

  public void visitFunctionInvocation(@NotNull BallerinaFunctionInvocation o) {
    visitCompositeElement(o);
  }

  public void visitFunctionInvocationReference(@NotNull BallerinaFunctionInvocationReference o) {
    visitVariableReference(o);
  }

  public void visitFunctionTypeName(@NotNull BallerinaFunctionTypeName o) {
    visitCompositeElement(o);
  }

  public void visitFutureTypeName(@NotNull BallerinaFutureTypeName o) {
    visitCompositeElement(o);
  }

  public void visitGlobalVariableDefinition(@NotNull BallerinaGlobalVariableDefinition o) {
    visitCompositeElement(o);
  }

  public void visitGroupByClause(@NotNull BallerinaGroupByClause o) {
    visitCompositeElement(o);
  }

  public void visitGroupTypeName(@NotNull BallerinaGroupTypeName o) {
    visitTypeName(o);
  }

  public void visitHavingClause(@NotNull BallerinaHavingClause o) {
    visitCompositeElement(o);
  }

  public void visitIfClause(@NotNull BallerinaIfClause o) {
    visitCompositeElement(o);
  }

  public void visitIfElseStatement(@NotNull BallerinaIfElseStatement o) {
    visitCompositeElement(o);
  }

  public void visitImportDeclaration(@NotNull BallerinaImportDeclaration o) {
    visitCompositeElement(o);
  }

  public void visitIndex(@NotNull BallerinaIndex o) {
    visitCompositeElement(o);
  }

  public void visitIntRangeExpression(@NotNull BallerinaIntRangeExpression o) {
    visitCompositeElement(o);
  }

  public void visitIntegerLiteral(@NotNull BallerinaIntegerLiteral o) {
    visitCompositeElement(o);
  }

  public void visitIntegerRangeExpression(@NotNull BallerinaIntegerRangeExpression o) {
    visitExpression(o);
  }

  public void visitInvocation(@NotNull BallerinaInvocation o) {
    visitCompositeElement(o);
  }

  public void visitInvocationArg(@NotNull BallerinaInvocationArg o) {
    visitCompositeElement(o);
  }

  public void visitInvocationArgList(@NotNull BallerinaInvocationArgList o) {
    visitCompositeElement(o);
  }

  public void visitInvocationReference(@NotNull BallerinaInvocationReference o) {
    visitVariableReference(o);
  }

  public void visitJoinStreamingInput(@NotNull BallerinaJoinStreamingInput o) {
    visitCompositeElement(o);
  }

  public void visitJoinType(@NotNull BallerinaJoinType o) {
    visitCompositeElement(o);
  }

  public void visitJsonTypeName(@NotNull BallerinaJsonTypeName o) {
    visitCompositeElement(o);
  }

  public void visitLambdaFunction(@NotNull BallerinaLambdaFunction o) {
    visitCompositeElement(o);
  }

  public void visitLambdaFunctionExpression(@NotNull BallerinaLambdaFunctionExpression o) {
    visitExpression(o);
  }

  public void visitLambdaReturnParameter(@NotNull BallerinaLambdaReturnParameter o) {
    visitCompositeElement(o);
  }

  public void visitLimitClause(@NotNull BallerinaLimitClause o) {
    visitCompositeElement(o);
  }

  public void visitLockStatement(@NotNull BallerinaLockStatement o) {
    visitCompositeElement(o);
  }

  public void visitMapArrayVariableReference(@NotNull BallerinaMapArrayVariableReference o) {
    visitVariableReference(o);
  }

  public void visitMapTypeName(@NotNull BallerinaMapTypeName o) {
    visitCompositeElement(o);
  }

  public void visitNameReference(@NotNull BallerinaNameReference o) {
    visitNamedElement(o);
    // visitReferenceExpressionBase(o);
  }

  public void visitNamedArgs(@NotNull BallerinaNamedArgs o) {
    visitCompositeElement(o);
  }

  public void visitNamespaceDeclaration(@NotNull BallerinaNamespaceDeclaration o) {
    visitNamedElement(o);
  }

  public void visitNamespaceDeclarationStatement(@NotNull BallerinaNamespaceDeclarationStatement o) {
    visitCompositeElement(o);
  }

  public void visitNullableTypeName(@NotNull BallerinaNullableTypeName o) {
    visitTypeName(o);
  }

  public void visitObjectBody(@NotNull BallerinaObjectBody o) {
    visitCompositeElement(o);
  }

  public void visitObjectFieldDefinition(@NotNull BallerinaObjectFieldDefinition o) {
    visitCompositeElement(o);
  }

  public void visitObjectFunctionDefinition(@NotNull BallerinaObjectFunctionDefinition o) {
    visitCompositeElement(o);
  }

  public void visitObjectTypeName(@NotNull BallerinaObjectTypeName o) {
    visitTypeName(o);
  }

  public void visitOnRetryClause(@NotNull BallerinaOnRetryClause o) {
    visitCompositeElement(o);
  }

  public void visitOrderByClause(@NotNull BallerinaOrderByClause o) {
    visitCompositeElement(o);
  }

  public void visitOrderByType(@NotNull BallerinaOrderByType o) {
    visitCompositeElement(o);
  }

  public void visitOrderByVariable(@NotNull BallerinaOrderByVariable o) {
    visitCompositeElement(o);
  }

  public void visitOrgName(@NotNull BallerinaOrgName o) {
    visitNamedElement(o);
  }

  public void visitOutputRateLimit(@NotNull BallerinaOutputRateLimit o) {
    visitCompositeElement(o);
  }

  public void visitPackageName(@NotNull BallerinaPackageName o) {
    visitNamedElement(o);
  }

  public void visitPackageReference(@NotNull BallerinaPackageReference o) {
    visitNamedElement(o);
  }

  public void visitPackageVersion(@NotNull BallerinaPackageVersion o) {
    visitNamedElement(o);
  }

  public void visitPanicStatement(@NotNull BallerinaPanicStatement o) {
    visitCompositeElement(o);
  }

  public void visitParameter(@NotNull BallerinaParameter o) {
    visitCompositeElement(o);
  }

  public void visitParameterList(@NotNull BallerinaParameterList o) {
    visitCompositeElement(o);
  }

  public void visitParameterTypeNameList(@NotNull BallerinaParameterTypeNameList o) {
    visitCompositeElement(o);
  }

  public void visitPatternClause(@NotNull BallerinaPatternClause o) {
    visitCompositeElement(o);
  }

  public void visitPatternStreamingEdgeInput(@NotNull BallerinaPatternStreamingEdgeInput o) {
    visitCompositeElement(o);
  }

  public void visitPatternStreamingInput(@NotNull BallerinaPatternStreamingInput o) {
    visitCompositeElement(o);
  }

  public void visitProcIns(@NotNull BallerinaProcIns o) {
    visitCompositeElement(o);
  }

  public void visitRecordBindingPattern(@NotNull BallerinaRecordBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitRecordDestructuringStatement(@NotNull BallerinaRecordDestructuringStatement o) {
    visitCompositeElement(o);
  }

  public void visitRecordFieldDefinitionList(@NotNull BallerinaRecordFieldDefinitionList o) {
    visitCompositeElement(o);
  }

  public void visitRecordKey(@NotNull BallerinaRecordKey o) {
    visitCompositeElement(o);
  }

  public void visitRecordKeyValue(@NotNull BallerinaRecordKeyValue o) {
    visitCompositeElement(o);
  }

  public void visitRecordLiteral(@NotNull BallerinaRecordLiteral o) {
    visitCompositeElement(o);
  }

  public void visitRecordLiteralBody(@NotNull BallerinaRecordLiteralBody o) {
    visitCompositeElement(o);
  }

  public void visitRecordLiteralExpression(@NotNull BallerinaRecordLiteralExpression o) {
    visitExpression(o);
  }

  public void visitRecordRefBindingPattern(@NotNull BallerinaRecordRefBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitRecordRestFieldDefinition(@NotNull BallerinaRecordRestFieldDefinition o) {
    visitCompositeElement(o);
  }

  public void visitRecordTypeName(@NotNull BallerinaRecordTypeName o) {
    visitTypeName(o);
  }

  public void visitReferenceTypeName(@NotNull BallerinaReferenceTypeName o) {
    visitCompositeElement(o);
  }

  public void visitReservedWord(@NotNull BallerinaReservedWord o) {
    visitCompositeElement(o);
  }

  public void visitRestArgs(@NotNull BallerinaRestArgs o) {
    visitCompositeElement(o);
  }

  public void visitRestBindingPattern(@NotNull BallerinaRestBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitRestParameter(@NotNull BallerinaRestParameter o) {
    visitCompositeElement(o);
  }

  public void visitRestRefBindingPattern(@NotNull BallerinaRestRefBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitRetriesStatement(@NotNull BallerinaRetriesStatement o) {
    visitCompositeElement(o);
  }

  public void visitRetryStatement(@NotNull BallerinaRetryStatement o) {
    visitCompositeElement(o);
  }

  public void visitReturnParameter(@NotNull BallerinaReturnParameter o) {
    visitCompositeElement(o);
  }

  public void visitReturnStatement(@NotNull BallerinaReturnStatement o) {
    visitCompositeElement(o);
  }

  public void visitReturnType(@NotNull BallerinaReturnType o) {
    visitCompositeElement(o);
  }

  public void visitSealedLiteral(@NotNull BallerinaSealedLiteral o) {
    visitCompositeElement(o);
  }

  public void visitSelectClause(@NotNull BallerinaSelectClause o) {
    visitCompositeElement(o);
  }

  public void visitSelectExpression(@NotNull BallerinaSelectExpression o) {
    visitCompositeElement(o);
  }

  public void visitSelectExpressionList(@NotNull BallerinaSelectExpressionList o) {
    visitCompositeElement(o);
  }

  public void visitServiceBody(@NotNull BallerinaServiceBody o) {
    visitCompositeElement(o);
  }

  public void visitServiceBodyMember(@NotNull BallerinaServiceBodyMember o) {
    visitCompositeElement(o);
  }

  public void visitServiceConstructorExpression(@NotNull BallerinaServiceConstructorExpression o) {
    visitExpression(o);
  }

  public void visitServiceDefinition(@NotNull BallerinaServiceDefinition o) {
    visitCompositeElement(o);
  }

  public void visitServiceTypeName(@NotNull BallerinaServiceTypeName o) {
    visitCompositeElement(o);
  }

  public void visitSetAssignmentClause(@NotNull BallerinaSetAssignmentClause o) {
    visitCompositeElement(o);
  }

  public void visitSetClause(@NotNull BallerinaSetClause o) {
    visitCompositeElement(o);
  }

  public void visitShiftExpression(@NotNull BallerinaShiftExpression o) {
    visitCompositeElement(o);
  }

  public void visitSimpleLiteral(@NotNull BallerinaSimpleLiteral o) {
    visitCompositeElement(o);
  }

  public void visitSimpleLiteralExpression(@NotNull BallerinaSimpleLiteralExpression o) {
    visitExpression(o);
  }

  public void visitSimpleTypeName(@NotNull BallerinaSimpleTypeName o) {
    visitTypeName(o);
  }

  public void visitSimpleVariableReference(@NotNull BallerinaSimpleVariableReference o) {
    visitVariableReference(o);
  }

  public void visitStartTag(@NotNull BallerinaStartTag o) {
    visitCompositeElement(o);
  }

  public void visitStatement(@NotNull BallerinaStatement o) {
    visitCompositeElement(o);
  }

  public void visitStaticMatchIdentifierLiteral(@NotNull BallerinaStaticMatchIdentifierLiteral o) {
    visitStaticMatchLiterals(o);
  }

  public void visitStaticMatchLiterals(@NotNull BallerinaStaticMatchLiterals o) {
    visitCompositeElement(o);
  }

  public void visitStaticMatchOrExpression(@NotNull BallerinaStaticMatchOrExpression o) {
    visitStaticMatchLiterals(o);
  }

  public void visitStaticMatchRecordLiteral(@NotNull BallerinaStaticMatchRecordLiteral o) {
    visitStaticMatchLiterals(o);
  }

  public void visitStaticMatchSimpleLiteral(@NotNull BallerinaStaticMatchSimpleLiteral o) {
    visitStaticMatchLiterals(o);
  }

  public void visitStaticMatchTupleLiteral(@NotNull BallerinaStaticMatchTupleLiteral o) {
    visitStaticMatchLiterals(o);
  }

  public void visitStreamTypeName(@NotNull BallerinaStreamTypeName o) {
    visitCompositeElement(o);
  }

  public void visitStreamingAction(@NotNull BallerinaStreamingAction o) {
    visitCompositeElement(o);
  }

  public void visitStreamingInput(@NotNull BallerinaStreamingInput o) {
    visitCompositeElement(o);
  }

  public void visitStreamingQueryStatement(@NotNull BallerinaStreamingQueryStatement o) {
    visitCompositeElement(o);
  }

  public void visitStringTemplateContent(@NotNull BallerinaStringTemplateContent o) {
    visitCompositeElement(o);
  }

  public void visitStringTemplateLiteral(@NotNull BallerinaStringTemplateLiteral o) {
    visitCompositeElement(o);
  }

  public void visitStringTemplateLiteralExpression(@NotNull BallerinaStringTemplateLiteralExpression o) {
    visitExpression(o);
  }

  public void visitStructuredBindingPattern(@NotNull BallerinaStructuredBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitStructuredRefBindingPattern(@NotNull BallerinaStructuredRefBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitTableColumn(@NotNull BallerinaTableColumn o) {
    visitCompositeElement(o);
  }

  public void visitTableColumnDefinition(@NotNull BallerinaTableColumnDefinition o) {
    visitCompositeElement(o);
  }

  public void visitTableData(@NotNull BallerinaTableData o) {
    visitCompositeElement(o);
  }

  public void visitTableDataArray(@NotNull BallerinaTableDataArray o) {
    visitCompositeElement(o);
  }

  public void visitTableDataList(@NotNull BallerinaTableDataList o) {
    visitCompositeElement(o);
  }

  public void visitTableLiteral(@NotNull BallerinaTableLiteral o) {
    visitCompositeElement(o);
  }

  public void visitTableLiteralExpression(@NotNull BallerinaTableLiteralExpression o) {
    visitExpression(o);
  }

  public void visitTableQuery(@NotNull BallerinaTableQuery o) {
    visitCompositeElement(o);
  }

  public void visitTableQueryExpression(@NotNull BallerinaTableQueryExpression o) {
    visitExpression(o);
  }

  public void visitTableTypeName(@NotNull BallerinaTableTypeName o) {
    visitCompositeElement(o);
  }

  public void visitTernaryExpression(@NotNull BallerinaTernaryExpression o) {
    visitExpression(o);
  }

  public void visitThrowStatement(@NotNull BallerinaThrowStatement o) {
    visitCompositeElement(o);
  }

  public void visitTimeScale(@NotNull BallerinaTimeScale o) {
    visitCompositeElement(o);
  }

  public void visitTransactionClause(@NotNull BallerinaTransactionClause o) {
    visitCompositeElement(o);
  }

  public void visitTransactionPropertyInitStatement(@NotNull BallerinaTransactionPropertyInitStatement o) {
    visitCompositeElement(o);
  }

  public void visitTransactionPropertyInitStatementList(@NotNull BallerinaTransactionPropertyInitStatementList o) {
    visitCompositeElement(o);
  }

  public void visitTransactionStatement(@NotNull BallerinaTransactionStatement o) {
    visitCompositeElement(o);
  }

  public void visitTrapExpression(@NotNull BallerinaTrapExpression o) {
    visitExpression(o);
  }

  public void visitTryCatchStatement(@NotNull BallerinaTryCatchStatement o) {
    visitCompositeElement(o);
  }

  public void visitTupleBindingPattern(@NotNull BallerinaTupleBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitTupleLiteral(@NotNull BallerinaTupleLiteral o) {
    visitCompositeElement(o);
  }

  public void visitTupleRefBindingPattern(@NotNull BallerinaTupleRefBindingPattern o) {
    visitCompositeElement(o);
  }

  public void visitTupleTypeName(@NotNull BallerinaTupleTypeName o) {
    visitTypeName(o);
  }

  public void visitTypeAccessExprInvocationReference(@NotNull BallerinaTypeAccessExprInvocationReference o) {
    visitVariableReference(o);
  }

  public void visitTypeAccessExpression(@NotNull BallerinaTypeAccessExpression o) {
    visitExpression(o);
  }

  public void visitTypeConversionExpression(@NotNull BallerinaTypeConversionExpression o) {
    visitExpression(o);
  }

  public void visitTypeDefinition(@NotNull BallerinaTypeDefinition o) {
    visitNamedElement(o);
    // visitTopLevelDefinition(o);
  }

  public void visitTypeDescTypeName(@NotNull BallerinaTypeDescTypeName o) {
    visitCompositeElement(o);
  }

  public void visitTypeInitExpression(@NotNull BallerinaTypeInitExpression o) {
    visitExpression(o);
  }

  public void visitTypeName(@NotNull BallerinaTypeName o) {
    visitCompositeElement(o);
  }

  public void visitTypeReference(@NotNull BallerinaTypeReference o) {
    visitCompositeElement(o);
  }

  public void visitTypeTestExpression(@NotNull BallerinaTypeTestExpression o) {
    visitExpression(o);
  }

  public void visitUnaryExpression(@NotNull BallerinaUnaryExpression o) {
    visitExpression(o);
  }

  public void visitUnionTypeName(@NotNull BallerinaUnionTypeName o) {
    visitTypeName(o);
  }

  public void visitUserDefineTypeName(@NotNull BallerinaUserDefineTypeName o) {
    visitCompositeElement(o);
  }

  public void visitValueTypeName(@NotNull BallerinaValueTypeName o) {
    visitCompositeElement(o);
  }

  public void visitVariableDefinitionStatement(@NotNull BallerinaVariableDefinitionStatement o) {
    visitCompositeElement(o);
  }

  public void visitVariableReference(@NotNull BallerinaVariableReference o) {
    visitCompositeElement(o);
  }

  public void visitVariableReferenceExpression(@NotNull BallerinaVariableReferenceExpression o) {
    visitExpression(o);
  }

  public void visitVariableReferenceList(@NotNull BallerinaVariableReferenceList o) {
    visitCompositeElement(o);
  }

  public void visitWaitExpression(@NotNull BallerinaWaitExpression o) {
    visitExpression(o);
  }

  public void visitWaitForCollection(@NotNull BallerinaWaitForCollection o) {
    visitCompositeElement(o);
  }

  public void visitWaitKeyValue(@NotNull BallerinaWaitKeyValue o) {
    visitCompositeElement(o);
  }

  public void visitWhereClause(@NotNull BallerinaWhereClause o) {
    visitCompositeElement(o);
  }

  public void visitWhileStatement(@NotNull BallerinaWhileStatement o) {
    visitCompositeElement(o);
  }

  public void visitWhileStatementBody(@NotNull BallerinaWhileStatementBody o) {
    visitCompositeElement(o);
  }

  public void visitWindowClause(@NotNull BallerinaWindowClause o) {
    visitCompositeElement(o);
  }

  public void visitWithinClause(@NotNull BallerinaWithinClause o) {
    visitCompositeElement(o);
  }

  public void visitWorkerBody(@NotNull BallerinaWorkerBody o) {
    visitCompositeElement(o);
  }

  public void visitWorkerDefinition(@NotNull BallerinaWorkerDefinition o) {
    visitNamedElement(o);
    // visitTopLevelDefinition(o);
  }

  public void visitWorkerReceiveExpression(@NotNull BallerinaWorkerReceiveExpression o) {
    visitExpression(o);
  }

  public void visitWorkerSendAsyncExpression(@NotNull BallerinaWorkerSendAsyncExpression o) {
    visitExpression(o);
  }

  public void visitWorkerSendAsyncStatement(@NotNull BallerinaWorkerSendAsyncStatement o) {
    visitCompositeElement(o);
  }

  public void visitXmlAttrib(@NotNull BallerinaXmlAttrib o) {
    visitCompositeElement(o);
  }

  public void visitXmlAttribVariableReference(@NotNull BallerinaXmlAttribVariableReference o) {
    visitVariableReference(o);
  }

  public void visitXmlDoubleQuotedString(@NotNull BallerinaXmlDoubleQuotedString o) {
    visitCompositeElement(o);
  }

  public void visitXmlItem(@NotNull BallerinaXmlItem o) {
    visitCompositeElement(o);
  }

  public void visitXmlLiteral(@NotNull BallerinaXmlLiteral o) {
    visitCompositeElement(o);
  }

  public void visitXmlLiteralExpression(@NotNull BallerinaXmlLiteralExpression o) {
    visitExpression(o);
  }

  public void visitXmlLocalName(@NotNull BallerinaXmlLocalName o) {
    visitCompositeElement(o);
  }

  public void visitXmlNamespaceName(@NotNull BallerinaXmlNamespaceName o) {
    visitCompositeElement(o);
  }

  public void visitXmlQualifiedName(@NotNull BallerinaXmlQualifiedName o) {
    visitCompositeElement(o);
  }

  public void visitXmlQuotedString(@NotNull BallerinaXmlQuotedString o) {
    visitCompositeElement(o);
  }

  public void visitXmlSingleQuotedString(@NotNull BallerinaXmlSingleQuotedString o) {
    visitCompositeElement(o);
  }

  public void visitXmlText(@NotNull BallerinaXmlText o) {
    visitCompositeElement(o);
  }

  public void visitXmlTypeName(@NotNull BallerinaXmlTypeName o) {
    visitCompositeElement(o);
  }

  public void visitBacktickedBlock(@NotNull BallerinaBacktickedBlock o) {
    visitCompositeElement(o);
  }

  public void visitChannelType(@NotNull BallerinaChannelType o) {
    visitCompositeElement(o);
  }

  public void visitDefinitionReferenceType(@NotNull BallerinaDefinitionReferenceType o) {
    visitCompositeElement(o);
  }

  public void visitDeprecatedAttachment(@NotNull BallerinaDeprecatedAttachment o) {
    visitCompositeElement(o);
  }

  public void visitDeprecatedTemplateInlineCode(@NotNull BallerinaDeprecatedTemplateInlineCode o) {
    visitCompositeElement(o);
  }

  public void visitDeprecatedText(@NotNull BallerinaDeprecatedText o) {
    visitCompositeElement(o);
  }

  public void visitDocParameterDescription(@NotNull BallerinaDocParameterDescription o) {
    visitCompositeElement(o);
  }

  public void visitDocumentationContent(@NotNull BallerinaDocumentationContent o) {
    visitCompositeElement(o);
  }

  public void visitDocumentationDefinitionReference(@NotNull BallerinaDocumentationDefinitionReference o) {
    visitCompositeElement(o);
  }

  public void visitDocumentationLine(@NotNull BallerinaDocumentationLine o) {
    visitCompositeElement(o);
  }

  public void visitDocumentationReference(@NotNull BallerinaDocumentationReference o) {
    visitCompositeElement(o);
  }

  public void visitDocumentationString(@NotNull BallerinaDocumentationString o) {
    visitCompositeElement(o);
  }

  public void visitDocumentationText(@NotNull BallerinaDocumentationText o) {
    visitCompositeElement(o);
  }

  public void visitDoubleBackTickDeprecatedInlineCode(@NotNull BallerinaDoubleBackTickDeprecatedInlineCode o) {
    visitCompositeElement(o);
  }

  public void visitDoubleBacktickedBlock(@NotNull BallerinaDoubleBacktickedBlock o) {
    visitCompositeElement(o);
  }

  public void visitFunctionNameReference(@NotNull BallerinaFunctionNameReference o) {
    visitCompositeElement(o);
  }

  public void visitInitWithType(@NotNull BallerinaInitWithType o) {
    visitCompositeElement(o);
  }

  public void visitInitWithoutType(@NotNull BallerinaInitWithoutType o) {
    visitCompositeElement(o);
  }

  public void visitMatchPatternClause(@NotNull BallerinaMatchPatternClause o) {
    visitCompositeElement(o);
  }

  public void visitMatchStatement(@NotNull BallerinaMatchStatement o) {
    visitCompositeElement(o);
  }

  public void visitMatchStatementBody(@NotNull BallerinaMatchStatementBody o) {
    visitCompositeElement(o);
  }

  public void visitParameterDescription(@NotNull BallerinaParameterDescription o) {
    visitCompositeElement(o);
  }

  public void visitParameterDocumentation(@NotNull BallerinaParameterDocumentation o) {
    visitCompositeElement(o);
  }

  public void visitParameterDocumentationLine(@NotNull BallerinaParameterDocumentationLine o) {
    visitCompositeElement(o);
  }

  public void visitParameterTypeName(@NotNull BallerinaParameterTypeName o) {
    visitCompositeElement(o);
  }

  public void visitParameterWithType(@NotNull BallerinaParameterWithType o) {
    visitCompositeElement(o);
  }

  public void visitReturnParameterDescription(@NotNull BallerinaReturnParameterDescription o) {
    visitCompositeElement(o);
  }

  public void visitReturnParameterDocumentation(@NotNull BallerinaReturnParameterDocumentation o) {
    visitCompositeElement(o);
  }

  public void visitReturnParameterDocumentationLine(@NotNull BallerinaReturnParameterDocumentationLine o) {
    visitCompositeElement(o);
  }

  public void visitSingleBackTickDeprecatedInlineCode(@NotNull BallerinaSingleBackTickDeprecatedInlineCode o) {
    visitCompositeElement(o);
  }

  public void visitSingleBacktickedBlock(@NotNull BallerinaSingleBacktickedBlock o) {
    visitCompositeElement(o);
  }

  public void visitStaticMatchPattern(@NotNull BallerinaStaticMatchPattern o) {
    visitCompositeElement(o);
  }

  public void visitTripleBackTickDeprecatedInlineCode(@NotNull BallerinaTripleBackTickDeprecatedInlineCode o) {
    visitCompositeElement(o);
  }

  public void visitTripleBacktickedBlock(@NotNull BallerinaTripleBacktickedBlock o) {
    visitCompositeElement(o);
  }

  public void visitTupleDestructuringStatement(@NotNull BallerinaTupleDestructuringStatement o) {
    visitCompositeElement(o);
  }

  public void visitVarMatchPattern(@NotNull BallerinaVarMatchPattern o) {
    visitCompositeElement(o);
  }

  public void visitVariableDefinitionStatementWithAssignment(@NotNull BallerinaVariableDefinitionStatementWithAssignment o) {
    visitCompositeElement(o);
  }

  public void visitVariableDefinitionStatementWithoutAssignment(@NotNull BallerinaVariableDefinitionStatementWithoutAssignment o) {
    visitCompositeElement(o);
  }

  public void visitNamedElement(@NotNull BallerinaNamedElement o) {
    visitCompositeElement(o);
  }

  public void visitCompositeElement(@NotNull BallerinaCompositeElement o) {
    visitElement(o);
  }

}
