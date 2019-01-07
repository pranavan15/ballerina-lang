/**
 * Generated using theia-extension-generator
 */

import { BallerinaCommandContribution, BallerinaMenuContribution } from './ballerina-contribution';
import {
    CommandContribution,
    MenuContribution
} from "@theia/core/lib/common";
import { bindViewContribution, WidgetFactory } from "@theia/core/lib/browser";
import { LanguageClientContribution } from "@theia/languages/lib/browser";
import { LanguageGrammarDefinitionContribution } from "@theia/monaco/lib/browser/textmate";
import { BallerinaGrammarContribution } from "./ballerina-grammar-contribution";
import { BallerinaLanguageClientContribution } from './ballerina-language-client-contribution';
import { BALLERINA_PREVIEW_WIDGET_FACTORY_ID, BallerinaPreviewContribution} from './ballerina-preview-contribution';
import { BallerinaPreviewWidget } from './ballerina-preview-widget';
import { LabelProviderContribution } from "@theia/core/lib/browser/label-provider";
import { BallerinaLabelProviderContribution } from './ballerina-label-contribution';

import { ContainerModule } from "inversify";

export default new ContainerModule(bind => {

    bind(BallerinaPreviewWidget).toSelf();
    bind(WidgetFactory).toDynamicValue(context => ({
        id: BALLERINA_PREVIEW_WIDGET_FACTORY_ID,
        createWidget: () => context.container.get<BallerinaPreviewWidget>(BallerinaPreviewWidget)
    }));

    bindViewContribution(bind, BallerinaPreviewContribution);

    bind(LanguageClientContribution).to(BallerinaLanguageClientContribution).inSingletonScope();
    bind(CommandContribution).to(BallerinaCommandContribution);
    bind(MenuContribution).to(BallerinaMenuContribution);
    bind(LanguageGrammarDefinitionContribution).to(BallerinaGrammarContribution).inSingletonScope();
    bind(LabelProviderContribution).to(BallerinaLabelProviderContribution).inSingletonScope();
});